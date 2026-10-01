import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../async_handlers/async_request.dart';
import '../async_handlers/response.dart';
import '../utils/debug/debug_service.dart';

/// Centralized error handler used by repository implementations.
///
/// Keeps repository methods clean and ensures all user-facing errors
/// are deterministic, friendly, and never leak internal database details.
mixin class ErrorHandler {
  AsyncRequest<T> asyncTryCatch<T>({
    required Future<RepoResponse<T>> Function() tryFunc,
    Debugger? debugger,
  }) async {
    late final FailedRepoCall<T> error;

    try {
      return await tryFunc();
    } on SocketException catch (e, s) {
      error = FailedRepoCall<T>(
        message: 'ইন্টারনেট সংযোগ পাওয়া যায়নি। অনুগ্রহ করে সংযোগ পরীক্ষা করুন।',
        exception: e,
        stackTrace: s,
      );
    } catch (e, s) {
      final msg = _extractErrorMessage(e);
      error = FailedRepoCall<T>(
        message: msg,
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: s,
      );
    }

    if (kDebugMode) {
      debugPrint('🔴 [ErrorHandler] Caught error: ${error.message}');
      debugPrint('📍 [ErrorHandler] StackTrace: ${error.stackTrace}');
      debugger?.log('Error: ${error.toString()}');
    }

    return error;
  }

  String _extractErrorMessage(dynamic e) {
    if (e == null) return 'অনুরোধটি সম্পন্ন করা সম্ভব হয়নি।';

    // 1. Supabase Edge Functions exception
    if (e is FunctionsHttpException) {
      final details = e.details;
      if (details is Map) {
        final message = details['message'] ?? details['error'];
        if (message != null && message.toString().trim().isNotEmpty) {
          return _cleanTechnicalError(message.toString());
        }
      }
      return getFriendlyStatusMessage(e.status, 'অনুরোধটি সম্পন্ন করা সম্ভব হয়নি।');
    }

    // 2. Supabase Auth exception
    if (e is AuthException) {
      return _cleanTechnicalError(e.message);
    }

    // 3. Supabase Postgrest exception
    if (e is PostgrestException) {
      return _cleanTechnicalError(e.message);
    }

    final str = e.toString();
    return _cleanTechnicalError(str);
  }

  String _cleanTechnicalError(String raw) {
    var str = raw.trim();

    // Strip common exception class prefixes
    if (str.startsWith('Exception: ')) str = str.substring('Exception: '.length).trim();
    if (str.startsWith('StateError: ')) str = str.substring('StateError: '.length).trim();
    if (str.startsWith('AuthException: ')) str = str.substring('AuthException: '.length).trim();
    if (str.startsWith('PostgrestException(')) {
      final match = RegExp(r'message:\s*([^,)]+)').firstMatch(str);
      if (match != null) str = match.group(1)!.trim();
    }
    if (str.startsWith('FunctionsHttpException(')) {
      final match = RegExp(r'error:\s*([^,}]+)').firstMatch(str);
      if (match != null) str = match.group(1)!.trim();
    }

    final lower = str.toLowerCase();

    // Specific duplicate key constraints
    if (lower.contains('divisions_name_key') || lower.contains('divisions_name_unique')) {
      return 'এই নামের বিভাগটি ইতিমধ্যে যুক্ত করা হয়েছে। (This division already exists!)';
    }
    if (lower.contains('districts_name_key') || lower.contains('districts_name_unique')) {
      return 'এই নামের জেলাটি ইতিমধ্যে যুক্ত করা হয়েছে। (This district already exists!)';
    }
    if (lower.contains('uq_district_upazila') || lower.contains('upazilas_district_id_name_key')) {
      return 'এই জেলায় এই নামের উপজেলাটি ইতিমধ্যে যুক্ত রয়েছে। (This upazila already exists in this district!)';
    }
    if (lower.contains('pathshalas_code_key')) {
      return 'এই পাঠশালা কোডটি ইতিমধ্যে ব্যবহৃত হয়েছে। (Pathshala code already in use!)';
    }
    if (lower.contains('email') && (lower.contains('unique') || lower.contains('duplicate key'))) {
      return 'এই ইমেইলটি ইতিমধ্যে ব্যবহৃত হচ্ছে। (Email already in use!)';
    }
    if (lower.contains('phone') && (lower.contains('unique') || lower.contains('duplicate key'))) {
      return 'এই ফোন নম্বরটি ইতিমধ্যে ব্যবহৃত হচ্ছে। (Phone number already in use!)';
    }

    // Generic SQL uniqueness
    if (lower.contains('duplicate key value') || lower.contains('violates unique constraint')) {
      return 'কিছু তথ্য ইতিমধ্যে সিস্টেমে বিদ্যমান, অনন্য তথ্য প্রদান করুন। (Duplicate entry: information must be unique!)';
    }

    // Foreign key / reference
    if (lower.contains('violates foreign key constraint') || lower.contains('foreign key constraint')) {
      return 'সম্পর্কিত প্রয়োজনীয় রেকর্ডটি ডাটাবেজে পাওয়া যায়নি। (Referenced record not found!)';
    }

    // Not null constraint
    if (lower.contains('violates not-null constraint')) {
      return 'প্রয়োজনীয় কিছু তথ্য প্রদান করা হয়নি। (Required information missing!)';
    }

    // UUID or syntax errors
    if (lower.contains('invalid input syntax for type uuid')) {
      return 'অনুরোধের তথ্যের ফরম্যাট সঠিক নয়। (Invalid request format!)';
    }

    // Network / Socket
    if (lower.contains('socketexception') || lower.contains('failed host lookup') || lower.contains('connection refused')) {
      return 'ইন্টারনেট সংযোগ পাওয়া যায়নি। অনুগ্রহ করে সংযোগ পরীক্ষা করুন।';
    }
    if (lower.contains('timeoutexception')) {
      return 'সার্ভার সাড়া দিতে অতিরিক্ত সময় নিয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';
    }

    // Auth messages
    if (lower.contains('invalid login credentials') || lower.contains('invalid email or password')) {
      return 'ইমেইল বা পাসওয়ার্ড সঠিক নয়। (Invalid email or password!)';
    }
    if (lower.contains('jwt') || lower.contains('unauthorized')) {
      return 'অনুমতি নেই! অনুগ্রহ করে পুনরায় লগইন করুন। (Unauthorized access)';
    }

    return str.isNotEmpty ? str : 'অনুরোধটি সম্পন্ন করা সম্ভব হয়নি।';
  }

  String getFriendlyStatusMessage(int? statusCode, String responseMessage) {
    switch (statusCode) {
      case 400:
        return 'অনুরোধটি সম্পন্ন করা সম্ভব হয়নি। (Bad Request)';
      case 401:
        return 'অনুমতি নেই। অনুগ্রহ করে লগইন করুন। (Unauthorized access)';
      case 403:
        return 'এই কাজটি করার প্রয়োজনীয় অনুমতি আপনার নেই। (Insufficient permissions)';
      case 404:
        return 'অনুরোধকৃত তথ্যটি খুঁজে পাওয়া যায়নি। (Not found)';
      case 408:
        return 'অনুরোধের সময়সীমা পার হয়ে গেছে। অনুগ্রহ করে আবার চেষ্টা করুন।';
      case 429:
        return 'অতিরিক্ত সংখ্যক অনুরোধ পাঠানো হয়েছে। অনুগ্রহ করে কিছুক্ষণ পর চেষ্টা করুন।';
      case final code? when code >= 500:
        return 'সার্ভারে সমস্যা হয়েছে। অনুগ্রহ করে কিছুক্ষণ পর আবার চেষ্টা করুন। (Internal server error)';
      default:
        return responseMessage;
    }
  }
}

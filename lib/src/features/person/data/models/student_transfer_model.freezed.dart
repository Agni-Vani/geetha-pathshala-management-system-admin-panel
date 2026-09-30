// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_transfer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentTransferModel {

 String get id; String get personId; String get fromPathshalaId; String get toPathshalaId; DateTime get requestedDate; TransferStatus get status; String? get reason; String? get approvedByUserId;
/// Create a copy of StudentTransferModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentTransferModelCopyWith<StudentTransferModel> get copyWith => _$StudentTransferModelCopyWithImpl<StudentTransferModel>(this as StudentTransferModel, _$identity);

  /// Serializes this StudentTransferModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentTransferModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.fromPathshalaId, fromPathshalaId) || other.fromPathshalaId == fromPathshalaId)&&(identical(other.toPathshalaId, toPathshalaId) || other.toPathshalaId == toPathshalaId)&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.approvedByUserId, approvedByUserId) || other.approvedByUserId == approvedByUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,fromPathshalaId,toPathshalaId,requestedDate,status,reason,approvedByUserId);

@override
String toString() {
  return 'StudentTransferModel(id: $id, personId: $personId, fromPathshalaId: $fromPathshalaId, toPathshalaId: $toPathshalaId, requestedDate: $requestedDate, status: $status, reason: $reason, approvedByUserId: $approvedByUserId)';
}


}

/// @nodoc
abstract mixin class $StudentTransferModelCopyWith<$Res>  {
  factory $StudentTransferModelCopyWith(StudentTransferModel value, $Res Function(StudentTransferModel) _then) = _$StudentTransferModelCopyWithImpl;
@useResult
$Res call({
 String id, String personId, String fromPathshalaId, String toPathshalaId, DateTime requestedDate, TransferStatus status, String? reason, String? approvedByUserId
});




}
/// @nodoc
class _$StudentTransferModelCopyWithImpl<$Res>
    implements $StudentTransferModelCopyWith<$Res> {
  _$StudentTransferModelCopyWithImpl(this._self, this._then);

  final StudentTransferModel _self;
  final $Res Function(StudentTransferModel) _then;

/// Create a copy of StudentTransferModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? personId = null,Object? fromPathshalaId = null,Object? toPathshalaId = null,Object? requestedDate = null,Object? status = null,Object? reason = freezed,Object? approvedByUserId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,fromPathshalaId: null == fromPathshalaId ? _self.fromPathshalaId : fromPathshalaId // ignore: cast_nullable_to_non_nullable
as String,toPathshalaId: null == toPathshalaId ? _self.toPathshalaId : toPathshalaId // ignore: cast_nullable_to_non_nullable
as String,requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,approvedByUserId: freezed == approvedByUserId ? _self.approvedByUserId : approvedByUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentTransferModel].
extension StudentTransferModelPatterns on StudentTransferModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentTransferModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentTransferModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentTransferModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentTransferModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentTransferModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentTransferModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String personId,  String fromPathshalaId,  String toPathshalaId,  DateTime requestedDate,  TransferStatus status,  String? reason,  String? approvedByUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentTransferModel() when $default != null:
return $default(_that.id,_that.personId,_that.fromPathshalaId,_that.toPathshalaId,_that.requestedDate,_that.status,_that.reason,_that.approvedByUserId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String personId,  String fromPathshalaId,  String toPathshalaId,  DateTime requestedDate,  TransferStatus status,  String? reason,  String? approvedByUserId)  $default,) {final _that = this;
switch (_that) {
case _StudentTransferModel():
return $default(_that.id,_that.personId,_that.fromPathshalaId,_that.toPathshalaId,_that.requestedDate,_that.status,_that.reason,_that.approvedByUserId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String personId,  String fromPathshalaId,  String toPathshalaId,  DateTime requestedDate,  TransferStatus status,  String? reason,  String? approvedByUserId)?  $default,) {final _that = this;
switch (_that) {
case _StudentTransferModel() when $default != null:
return $default(_that.id,_that.personId,_that.fromPathshalaId,_that.toPathshalaId,_that.requestedDate,_that.status,_that.reason,_that.approvedByUserId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentTransferModel extends StudentTransferModel {
  const _StudentTransferModel({required this.id, required this.personId, required this.fromPathshalaId, required this.toPathshalaId, required this.requestedDate, required this.status, required this.reason, required this.approvedByUserId}): super._();
  factory _StudentTransferModel.fromJson(Map<String, dynamic> json) => _$StudentTransferModelFromJson(json);

@override final  String id;
@override final  String personId;
@override final  String fromPathshalaId;
@override final  String toPathshalaId;
@override final  DateTime requestedDate;
@override final  TransferStatus status;
@override final  String? reason;
@override final  String? approvedByUserId;

/// Create a copy of StudentTransferModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentTransferModelCopyWith<_StudentTransferModel> get copyWith => __$StudentTransferModelCopyWithImpl<_StudentTransferModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentTransferModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentTransferModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.fromPathshalaId, fromPathshalaId) || other.fromPathshalaId == fromPathshalaId)&&(identical(other.toPathshalaId, toPathshalaId) || other.toPathshalaId == toPathshalaId)&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.approvedByUserId, approvedByUserId) || other.approvedByUserId == approvedByUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,fromPathshalaId,toPathshalaId,requestedDate,status,reason,approvedByUserId);

@override
String toString() {
  return 'StudentTransferModel(id: $id, personId: $personId, fromPathshalaId: $fromPathshalaId, toPathshalaId: $toPathshalaId, requestedDate: $requestedDate, status: $status, reason: $reason, approvedByUserId: $approvedByUserId)';
}


}

/// @nodoc
abstract mixin class _$StudentTransferModelCopyWith<$Res> implements $StudentTransferModelCopyWith<$Res> {
  factory _$StudentTransferModelCopyWith(_StudentTransferModel value, $Res Function(_StudentTransferModel) _then) = __$StudentTransferModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String personId, String fromPathshalaId, String toPathshalaId, DateTime requestedDate, TransferStatus status, String? reason, String? approvedByUserId
});




}
/// @nodoc
class __$StudentTransferModelCopyWithImpl<$Res>
    implements _$StudentTransferModelCopyWith<$Res> {
  __$StudentTransferModelCopyWithImpl(this._self, this._then);

  final _StudentTransferModel _self;
  final $Res Function(_StudentTransferModel) _then;

/// Create a copy of StudentTransferModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? personId = null,Object? fromPathshalaId = null,Object? toPathshalaId = null,Object? requestedDate = null,Object? status = null,Object? reason = freezed,Object? approvedByUserId = freezed,}) {
  return _then(_StudentTransferModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,fromPathshalaId: null == fromPathshalaId ? _self.fromPathshalaId : fromPathshalaId // ignore: cast_nullable_to_non_nullable
as String,toPathshalaId: null == toPathshalaId ? _self.toPathshalaId : toPathshalaId // ignore: cast_nullable_to_non_nullable
as String,requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,approvedByUserId: freezed == approvedByUserId ? _self.approvedByUserId : approvedByUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

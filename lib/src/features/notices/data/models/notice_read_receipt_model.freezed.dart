// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_read_receipt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoticeReadReceiptModel {

 String get id; String get noticeId; String get personId; String get userAccountId; DateTime get readAt;
/// Create a copy of NoticeReadReceiptModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeReadReceiptModelCopyWith<NoticeReadReceiptModel> get copyWith => _$NoticeReadReceiptModelCopyWithImpl<NoticeReadReceiptModel>(this as NoticeReadReceiptModel, _$identity);

  /// Serializes this NoticeReadReceiptModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeReadReceiptModel&&(identical(other.id, id) || other.id == id)&&(identical(other.noticeId, noticeId) || other.noticeId == noticeId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noticeId,personId,userAccountId,readAt);

@override
String toString() {
  return 'NoticeReadReceiptModel(id: $id, noticeId: $noticeId, personId: $personId, userAccountId: $userAccountId, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class $NoticeReadReceiptModelCopyWith<$Res>  {
  factory $NoticeReadReceiptModelCopyWith(NoticeReadReceiptModel value, $Res Function(NoticeReadReceiptModel) _then) = _$NoticeReadReceiptModelCopyWithImpl;
@useResult
$Res call({
 String id, String noticeId, String personId, String userAccountId, DateTime readAt
});




}
/// @nodoc
class _$NoticeReadReceiptModelCopyWithImpl<$Res>
    implements $NoticeReadReceiptModelCopyWith<$Res> {
  _$NoticeReadReceiptModelCopyWithImpl(this._self, this._then);

  final NoticeReadReceiptModel _self;
  final $Res Function(NoticeReadReceiptModel) _then;

/// Create a copy of NoticeReadReceiptModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? noticeId = null,Object? personId = null,Object? userAccountId = null,Object? readAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,userAccountId: null == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NoticeReadReceiptModel].
extension NoticeReadReceiptModelPatterns on NoticeReadReceiptModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeReadReceiptModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeReadReceiptModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeReadReceiptModel value)  $default,){
final _that = this;
switch (_that) {
case _NoticeReadReceiptModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeReadReceiptModel value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeReadReceiptModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String noticeId,  String personId,  String userAccountId,  DateTime readAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeReadReceiptModel() when $default != null:
return $default(_that.id,_that.noticeId,_that.personId,_that.userAccountId,_that.readAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String noticeId,  String personId,  String userAccountId,  DateTime readAt)  $default,) {final _that = this;
switch (_that) {
case _NoticeReadReceiptModel():
return $default(_that.id,_that.noticeId,_that.personId,_that.userAccountId,_that.readAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String noticeId,  String personId,  String userAccountId,  DateTime readAt)?  $default,) {final _that = this;
switch (_that) {
case _NoticeReadReceiptModel() when $default != null:
return $default(_that.id,_that.noticeId,_that.personId,_that.userAccountId,_that.readAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeReadReceiptModel extends NoticeReadReceiptModel {
  const _NoticeReadReceiptModel({required this.id, required this.noticeId, required this.personId, required this.userAccountId, required this.readAt}): super._();
  factory _NoticeReadReceiptModel.fromJson(Map<String, dynamic> json) => _$NoticeReadReceiptModelFromJson(json);

@override final  String id;
@override final  String noticeId;
@override final  String personId;
@override final  String userAccountId;
@override final  DateTime readAt;

/// Create a copy of NoticeReadReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeReadReceiptModelCopyWith<_NoticeReadReceiptModel> get copyWith => __$NoticeReadReceiptModelCopyWithImpl<_NoticeReadReceiptModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeReadReceiptModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeReadReceiptModel&&(identical(other.id, id) || other.id == id)&&(identical(other.noticeId, noticeId) || other.noticeId == noticeId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noticeId,personId,userAccountId,readAt);

@override
String toString() {
  return 'NoticeReadReceiptModel(id: $id, noticeId: $noticeId, personId: $personId, userAccountId: $userAccountId, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class _$NoticeReadReceiptModelCopyWith<$Res> implements $NoticeReadReceiptModelCopyWith<$Res> {
  factory _$NoticeReadReceiptModelCopyWith(_NoticeReadReceiptModel value, $Res Function(_NoticeReadReceiptModel) _then) = __$NoticeReadReceiptModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String noticeId, String personId, String userAccountId, DateTime readAt
});




}
/// @nodoc
class __$NoticeReadReceiptModelCopyWithImpl<$Res>
    implements _$NoticeReadReceiptModelCopyWith<$Res> {
  __$NoticeReadReceiptModelCopyWithImpl(this._self, this._then);

  final _NoticeReadReceiptModel _self;
  final $Res Function(_NoticeReadReceiptModel) _then;

/// Create a copy of NoticeReadReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? noticeId = null,Object? personId = null,Object? userAccountId = null,Object? readAt = null,}) {
  return _then(_NoticeReadReceiptModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,userAccountId: null == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

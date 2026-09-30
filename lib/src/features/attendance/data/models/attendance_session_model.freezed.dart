// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceSessionModel {

 String get id; String get groupId; DateTime get sessionDate; String get takenByUserId; SessionStatus get status; DateTime get createdAt;
/// Create a copy of AttendanceSessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceSessionModelCopyWith<AttendanceSessionModel> get copyWith => _$AttendanceSessionModelCopyWithImpl<AttendanceSessionModel>(this as AttendanceSessionModel, _$identity);

  /// Serializes this AttendanceSessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceSessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.sessionDate, sessionDate) || other.sessionDate == sessionDate)&&(identical(other.takenByUserId, takenByUserId) || other.takenByUserId == takenByUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,sessionDate,takenByUserId,status,createdAt);

@override
String toString() {
  return 'AttendanceSessionModel(id: $id, groupId: $groupId, sessionDate: $sessionDate, takenByUserId: $takenByUserId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AttendanceSessionModelCopyWith<$Res>  {
  factory $AttendanceSessionModelCopyWith(AttendanceSessionModel value, $Res Function(AttendanceSessionModel) _then) = _$AttendanceSessionModelCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, DateTime sessionDate, String takenByUserId, SessionStatus status, DateTime createdAt
});




}
/// @nodoc
class _$AttendanceSessionModelCopyWithImpl<$Res>
    implements $AttendanceSessionModelCopyWith<$Res> {
  _$AttendanceSessionModelCopyWithImpl(this._self, this._then);

  final AttendanceSessionModel _self;
  final $Res Function(AttendanceSessionModel) _then;

/// Create a copy of AttendanceSessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? sessionDate = null,Object? takenByUserId = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,sessionDate: null == sessionDate ? _self.sessionDate : sessionDate // ignore: cast_nullable_to_non_nullable
as DateTime,takenByUserId: null == takenByUserId ? _self.takenByUserId : takenByUserId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceSessionModel].
extension AttendanceSessionModelPatterns on AttendanceSessionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceSessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceSessionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceSessionModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceSessionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceSessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceSessionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  DateTime sessionDate,  String takenByUserId,  SessionStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceSessionModel() when $default != null:
return $default(_that.id,_that.groupId,_that.sessionDate,_that.takenByUserId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  DateTime sessionDate,  String takenByUserId,  SessionStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AttendanceSessionModel():
return $default(_that.id,_that.groupId,_that.sessionDate,_that.takenByUserId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  DateTime sessionDate,  String takenByUserId,  SessionStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceSessionModel() when $default != null:
return $default(_that.id,_that.groupId,_that.sessionDate,_that.takenByUserId,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceSessionModel extends AttendanceSessionModel {
  const _AttendanceSessionModel({required this.id, required this.groupId, required this.sessionDate, required this.takenByUserId, required this.status, required this.createdAt}): super._();
  factory _AttendanceSessionModel.fromJson(Map<String, dynamic> json) => _$AttendanceSessionModelFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  DateTime sessionDate;
@override final  String takenByUserId;
@override final  SessionStatus status;
@override final  DateTime createdAt;

/// Create a copy of AttendanceSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceSessionModelCopyWith<_AttendanceSessionModel> get copyWith => __$AttendanceSessionModelCopyWithImpl<_AttendanceSessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceSessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceSessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.sessionDate, sessionDate) || other.sessionDate == sessionDate)&&(identical(other.takenByUserId, takenByUserId) || other.takenByUserId == takenByUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,sessionDate,takenByUserId,status,createdAt);

@override
String toString() {
  return 'AttendanceSessionModel(id: $id, groupId: $groupId, sessionDate: $sessionDate, takenByUserId: $takenByUserId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AttendanceSessionModelCopyWith<$Res> implements $AttendanceSessionModelCopyWith<$Res> {
  factory _$AttendanceSessionModelCopyWith(_AttendanceSessionModel value, $Res Function(_AttendanceSessionModel) _then) = __$AttendanceSessionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, DateTime sessionDate, String takenByUserId, SessionStatus status, DateTime createdAt
});




}
/// @nodoc
class __$AttendanceSessionModelCopyWithImpl<$Res>
    implements _$AttendanceSessionModelCopyWith<$Res> {
  __$AttendanceSessionModelCopyWithImpl(this._self, this._then);

  final _AttendanceSessionModel _self;
  final $Res Function(_AttendanceSessionModel) _then;

/// Create a copy of AttendanceSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? sessionDate = null,Object? takenByUserId = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_AttendanceSessionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,sessionDate: null == sessionDate ? _self.sessionDate : sessionDate // ignore: cast_nullable_to_non_nullable
as DateTime,takenByUserId: null == takenByUserId ? _self.takenByUserId : takenByUserId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_enrollment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupEnrollmentModel {

 String get id; String get groupId; String get studentAdmissionId; String get personId; AdmissionStatus get status; DateTime get enrolledAt;
/// Create a copy of GroupEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupEnrollmentModelCopyWith<GroupEnrollmentModel> get copyWith => _$GroupEnrollmentModelCopyWithImpl<GroupEnrollmentModel>(this as GroupEnrollmentModel, _$identity);

  /// Serializes this GroupEnrollmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupEnrollmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.studentAdmissionId, studentAdmissionId) || other.studentAdmissionId == studentAdmissionId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.status, status) || other.status == status)&&(identical(other.enrolledAt, enrolledAt) || other.enrolledAt == enrolledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,studentAdmissionId,personId,status,enrolledAt);

@override
String toString() {
  return 'GroupEnrollmentModel(id: $id, groupId: $groupId, studentAdmissionId: $studentAdmissionId, personId: $personId, status: $status, enrolledAt: $enrolledAt)';
}


}

/// @nodoc
abstract mixin class $GroupEnrollmentModelCopyWith<$Res>  {
  factory $GroupEnrollmentModelCopyWith(GroupEnrollmentModel value, $Res Function(GroupEnrollmentModel) _then) = _$GroupEnrollmentModelCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String studentAdmissionId, String personId, AdmissionStatus status, DateTime enrolledAt
});




}
/// @nodoc
class _$GroupEnrollmentModelCopyWithImpl<$Res>
    implements $GroupEnrollmentModelCopyWith<$Res> {
  _$GroupEnrollmentModelCopyWithImpl(this._self, this._then);

  final GroupEnrollmentModel _self;
  final $Res Function(GroupEnrollmentModel) _then;

/// Create a copy of GroupEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? studentAdmissionId = null,Object? personId = null,Object? status = null,Object? enrolledAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,studentAdmissionId: null == studentAdmissionId ? _self.studentAdmissionId : studentAdmissionId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdmissionStatus,enrolledAt: null == enrolledAt ? _self.enrolledAt : enrolledAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupEnrollmentModel].
extension GroupEnrollmentModelPatterns on GroupEnrollmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupEnrollmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupEnrollmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupEnrollmentModel value)  $default,){
final _that = this;
switch (_that) {
case _GroupEnrollmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupEnrollmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _GroupEnrollmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String studentAdmissionId,  String personId,  AdmissionStatus status,  DateTime enrolledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupEnrollmentModel() when $default != null:
return $default(_that.id,_that.groupId,_that.studentAdmissionId,_that.personId,_that.status,_that.enrolledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String studentAdmissionId,  String personId,  AdmissionStatus status,  DateTime enrolledAt)  $default,) {final _that = this;
switch (_that) {
case _GroupEnrollmentModel():
return $default(_that.id,_that.groupId,_that.studentAdmissionId,_that.personId,_that.status,_that.enrolledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String studentAdmissionId,  String personId,  AdmissionStatus status,  DateTime enrolledAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupEnrollmentModel() when $default != null:
return $default(_that.id,_that.groupId,_that.studentAdmissionId,_that.personId,_that.status,_that.enrolledAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupEnrollmentModel extends GroupEnrollmentModel {
  const _GroupEnrollmentModel({required this.id, required this.groupId, required this.studentAdmissionId, required this.personId, required this.status, required this.enrolledAt}): super._();
  factory _GroupEnrollmentModel.fromJson(Map<String, dynamic> json) => _$GroupEnrollmentModelFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  String studentAdmissionId;
@override final  String personId;
@override final  AdmissionStatus status;
@override final  DateTime enrolledAt;

/// Create a copy of GroupEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupEnrollmentModelCopyWith<_GroupEnrollmentModel> get copyWith => __$GroupEnrollmentModelCopyWithImpl<_GroupEnrollmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupEnrollmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupEnrollmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.studentAdmissionId, studentAdmissionId) || other.studentAdmissionId == studentAdmissionId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.status, status) || other.status == status)&&(identical(other.enrolledAt, enrolledAt) || other.enrolledAt == enrolledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,studentAdmissionId,personId,status,enrolledAt);

@override
String toString() {
  return 'GroupEnrollmentModel(id: $id, groupId: $groupId, studentAdmissionId: $studentAdmissionId, personId: $personId, status: $status, enrolledAt: $enrolledAt)';
}


}

/// @nodoc
abstract mixin class _$GroupEnrollmentModelCopyWith<$Res> implements $GroupEnrollmentModelCopyWith<$Res> {
  factory _$GroupEnrollmentModelCopyWith(_GroupEnrollmentModel value, $Res Function(_GroupEnrollmentModel) _then) = __$GroupEnrollmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String studentAdmissionId, String personId, AdmissionStatus status, DateTime enrolledAt
});




}
/// @nodoc
class __$GroupEnrollmentModelCopyWithImpl<$Res>
    implements _$GroupEnrollmentModelCopyWith<$Res> {
  __$GroupEnrollmentModelCopyWithImpl(this._self, this._then);

  final _GroupEnrollmentModel _self;
  final $Res Function(_GroupEnrollmentModel) _then;

/// Create a copy of GroupEnrollmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? studentAdmissionId = null,Object? personId = null,Object? status = null,Object? enrolledAt = null,}) {
  return _then(_GroupEnrollmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,studentAdmissionId: null == studentAdmissionId ? _self.studentAdmissionId : studentAdmissionId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdmissionStatus,enrolledAt: null == enrolledAt ? _self.enrolledAt : enrolledAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

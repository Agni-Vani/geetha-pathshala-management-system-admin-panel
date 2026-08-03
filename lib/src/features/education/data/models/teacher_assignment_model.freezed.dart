// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_assignment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeacherAssignmentModel {

 String get id; String get teacherProfileId; String get pathshalaId; String get groupId; String get role; DateTime get effectiveFrom; DateTime? get effectiveTo;
/// Create a copy of TeacherAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherAssignmentModelCopyWith<TeacherAssignmentModel> get copyWith => _$TeacherAssignmentModelCopyWithImpl<TeacherAssignmentModel>(this as TeacherAssignmentModel, _$identity);

  /// Serializes this TeacherAssignmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherAssignmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherProfileId, teacherProfileId) || other.teacherProfileId == teacherProfileId)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.role, role) || other.role == role)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teacherProfileId,pathshalaId,groupId,role,effectiveFrom,effectiveTo);

@override
String toString() {
  return 'TeacherAssignmentModel(id: $id, teacherProfileId: $teacherProfileId, pathshalaId: $pathshalaId, groupId: $groupId, role: $role, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
}


}

/// @nodoc
abstract mixin class $TeacherAssignmentModelCopyWith<$Res>  {
  factory $TeacherAssignmentModelCopyWith(TeacherAssignmentModel value, $Res Function(TeacherAssignmentModel) _then) = _$TeacherAssignmentModelCopyWithImpl;
@useResult
$Res call({
 String id, String teacherProfileId, String pathshalaId, String groupId, String role, DateTime effectiveFrom, DateTime? effectiveTo
});




}
/// @nodoc
class _$TeacherAssignmentModelCopyWithImpl<$Res>
    implements $TeacherAssignmentModelCopyWith<$Res> {
  _$TeacherAssignmentModelCopyWithImpl(this._self, this._then);

  final TeacherAssignmentModel _self;
  final $Res Function(TeacherAssignmentModel) _then;

/// Create a copy of TeacherAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? teacherProfileId = null,Object? pathshalaId = null,Object? groupId = null,Object? role = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teacherProfileId: null == teacherProfileId ? _self.teacherProfileId : teacherProfileId // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: null == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherAssignmentModel].
extension TeacherAssignmentModelPatterns on TeacherAssignmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherAssignmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherAssignmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherAssignmentModel value)  $default,){
final _that = this;
switch (_that) {
case _TeacherAssignmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherAssignmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherAssignmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String teacherProfileId,  String pathshalaId,  String groupId,  String role,  DateTime effectiveFrom,  DateTime? effectiveTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherAssignmentModel() when $default != null:
return $default(_that.id,_that.teacherProfileId,_that.pathshalaId,_that.groupId,_that.role,_that.effectiveFrom,_that.effectiveTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String teacherProfileId,  String pathshalaId,  String groupId,  String role,  DateTime effectiveFrom,  DateTime? effectiveTo)  $default,) {final _that = this;
switch (_that) {
case _TeacherAssignmentModel():
return $default(_that.id,_that.teacherProfileId,_that.pathshalaId,_that.groupId,_that.role,_that.effectiveFrom,_that.effectiveTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String teacherProfileId,  String pathshalaId,  String groupId,  String role,  DateTime effectiveFrom,  DateTime? effectiveTo)?  $default,) {final _that = this;
switch (_that) {
case _TeacherAssignmentModel() when $default != null:
return $default(_that.id,_that.teacherProfileId,_that.pathshalaId,_that.groupId,_that.role,_that.effectiveFrom,_that.effectiveTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherAssignmentModel extends TeacherAssignmentModel {
  const _TeacherAssignmentModel({required this.id, required this.teacherProfileId, required this.pathshalaId, required this.groupId, required this.role, required this.effectiveFrom, required this.effectiveTo}): super._();
  factory _TeacherAssignmentModel.fromJson(Map<String, dynamic> json) => _$TeacherAssignmentModelFromJson(json);

@override final  String id;
@override final  String teacherProfileId;
@override final  String pathshalaId;
@override final  String groupId;
@override final  String role;
@override final  DateTime effectiveFrom;
@override final  DateTime? effectiveTo;

/// Create a copy of TeacherAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherAssignmentModelCopyWith<_TeacherAssignmentModel> get copyWith => __$TeacherAssignmentModelCopyWithImpl<_TeacherAssignmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherAssignmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherAssignmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherProfileId, teacherProfileId) || other.teacherProfileId == teacherProfileId)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.role, role) || other.role == role)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teacherProfileId,pathshalaId,groupId,role,effectiveFrom,effectiveTo);

@override
String toString() {
  return 'TeacherAssignmentModel(id: $id, teacherProfileId: $teacherProfileId, pathshalaId: $pathshalaId, groupId: $groupId, role: $role, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
}


}

/// @nodoc
abstract mixin class _$TeacherAssignmentModelCopyWith<$Res> implements $TeacherAssignmentModelCopyWith<$Res> {
  factory _$TeacherAssignmentModelCopyWith(_TeacherAssignmentModel value, $Res Function(_TeacherAssignmentModel) _then) = __$TeacherAssignmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String teacherProfileId, String pathshalaId, String groupId, String role, DateTime effectiveFrom, DateTime? effectiveTo
});




}
/// @nodoc
class __$TeacherAssignmentModelCopyWithImpl<$Res>
    implements _$TeacherAssignmentModelCopyWith<$Res> {
  __$TeacherAssignmentModelCopyWithImpl(this._self, this._then);

  final _TeacherAssignmentModel _self;
  final $Res Function(_TeacherAssignmentModel) _then;

/// Create a copy of TeacherAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? teacherProfileId = null,Object? pathshalaId = null,Object? groupId = null,Object? role = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,}) {
  return _then(_TeacherAssignmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teacherProfileId: null == teacherProfileId ? _self.teacherProfileId : teacherProfileId // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: null == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'educational_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EducationalGroupModel {

 String get id; String get pathshalaId; String get academicYearId; String get name; String get gradeLevel; GroupStatus get status; DateTime get createdAt;
/// Create a copy of EducationalGroupModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EducationalGroupModelCopyWith<EducationalGroupModel> get copyWith => _$EducationalGroupModelCopyWithImpl<EducationalGroupModel>(this as EducationalGroupModel, _$identity);

  /// Serializes this EducationalGroupModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EducationalGroupModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.name, name) || other.name == name)&&(identical(other.gradeLevel, gradeLevel) || other.gradeLevel == gradeLevel)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pathshalaId,academicYearId,name,gradeLevel,status,createdAt);

@override
String toString() {
  return 'EducationalGroupModel(id: $id, pathshalaId: $pathshalaId, academicYearId: $academicYearId, name: $name, gradeLevel: $gradeLevel, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EducationalGroupModelCopyWith<$Res>  {
  factory $EducationalGroupModelCopyWith(EducationalGroupModel value, $Res Function(EducationalGroupModel) _then) = _$EducationalGroupModelCopyWithImpl;
@useResult
$Res call({
 String id, String pathshalaId, String academicYearId, String name, String gradeLevel, GroupStatus status, DateTime createdAt
});




}
/// @nodoc
class _$EducationalGroupModelCopyWithImpl<$Res>
    implements $EducationalGroupModelCopyWith<$Res> {
  _$EducationalGroupModelCopyWithImpl(this._self, this._then);

  final EducationalGroupModel _self;
  final $Res Function(EducationalGroupModel) _then;

/// Create a copy of EducationalGroupModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pathshalaId = null,Object? academicYearId = null,Object? name = null,Object? gradeLevel = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: null == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gradeLevel: null == gradeLevel ? _self.gradeLevel : gradeLevel // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GroupStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EducationalGroupModel].
extension EducationalGroupModelPatterns on EducationalGroupModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EducationalGroupModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EducationalGroupModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EducationalGroupModel value)  $default,){
final _that = this;
switch (_that) {
case _EducationalGroupModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EducationalGroupModel value)?  $default,){
final _that = this;
switch (_that) {
case _EducationalGroupModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String pathshalaId,  String academicYearId,  String name,  String gradeLevel,  GroupStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EducationalGroupModel() when $default != null:
return $default(_that.id,_that.pathshalaId,_that.academicYearId,_that.name,_that.gradeLevel,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String pathshalaId,  String academicYearId,  String name,  String gradeLevel,  GroupStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _EducationalGroupModel():
return $default(_that.id,_that.pathshalaId,_that.academicYearId,_that.name,_that.gradeLevel,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String pathshalaId,  String academicYearId,  String name,  String gradeLevel,  GroupStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EducationalGroupModel() when $default != null:
return $default(_that.id,_that.pathshalaId,_that.academicYearId,_that.name,_that.gradeLevel,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EducationalGroupModel extends EducationalGroupModel {
  const _EducationalGroupModel({required this.id, required this.pathshalaId, required this.academicYearId, required this.name, required this.gradeLevel, required this.status, required this.createdAt}): super._();
  factory _EducationalGroupModel.fromJson(Map<String, dynamic> json) => _$EducationalGroupModelFromJson(json);

@override final  String id;
@override final  String pathshalaId;
@override final  String academicYearId;
@override final  String name;
@override final  String gradeLevel;
@override final  GroupStatus status;
@override final  DateTime createdAt;

/// Create a copy of EducationalGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EducationalGroupModelCopyWith<_EducationalGroupModel> get copyWith => __$EducationalGroupModelCopyWithImpl<_EducationalGroupModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EducationalGroupModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EducationalGroupModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.name, name) || other.name == name)&&(identical(other.gradeLevel, gradeLevel) || other.gradeLevel == gradeLevel)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pathshalaId,academicYearId,name,gradeLevel,status,createdAt);

@override
String toString() {
  return 'EducationalGroupModel(id: $id, pathshalaId: $pathshalaId, academicYearId: $academicYearId, name: $name, gradeLevel: $gradeLevel, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EducationalGroupModelCopyWith<$Res> implements $EducationalGroupModelCopyWith<$Res> {
  factory _$EducationalGroupModelCopyWith(_EducationalGroupModel value, $Res Function(_EducationalGroupModel) _then) = __$EducationalGroupModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String pathshalaId, String academicYearId, String name, String gradeLevel, GroupStatus status, DateTime createdAt
});




}
/// @nodoc
class __$EducationalGroupModelCopyWithImpl<$Res>
    implements _$EducationalGroupModelCopyWith<$Res> {
  __$EducationalGroupModelCopyWithImpl(this._self, this._then);

  final _EducationalGroupModel _self;
  final $Res Function(_EducationalGroupModel) _then;

/// Create a copy of EducationalGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pathshalaId = null,Object? academicYearId = null,Object? name = null,Object? gradeLevel = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_EducationalGroupModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: null == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String,academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gradeLevel: null == gradeLevel ? _self.gradeLevel : gradeLevel // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GroupStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

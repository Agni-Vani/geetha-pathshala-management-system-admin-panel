// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeacherProfileModel {

 String get id; String get personId; String get organizationId; TeacherStatus get status; DateTime get joinedDate;
/// Create a copy of TeacherProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherProfileModelCopyWith<TeacherProfileModel> get copyWith => _$TeacherProfileModelCopyWithImpl<TeacherProfileModel>(this as TeacherProfileModel, _$identity);

  /// Serializes this TeacherProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.joinedDate, joinedDate) || other.joinedDate == joinedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,organizationId,status,joinedDate);

@override
String toString() {
  return 'TeacherProfileModel(id: $id, personId: $personId, organizationId: $organizationId, status: $status, joinedDate: $joinedDate)';
}


}

/// @nodoc
abstract mixin class $TeacherProfileModelCopyWith<$Res>  {
  factory $TeacherProfileModelCopyWith(TeacherProfileModel value, $Res Function(TeacherProfileModel) _then) = _$TeacherProfileModelCopyWithImpl;
@useResult
$Res call({
 String id, String personId, String organizationId, TeacherStatus status, DateTime joinedDate
});




}
/// @nodoc
class _$TeacherProfileModelCopyWithImpl<$Res>
    implements $TeacherProfileModelCopyWith<$Res> {
  _$TeacherProfileModelCopyWithImpl(this._self, this._then);

  final TeacherProfileModel _self;
  final $Res Function(TeacherProfileModel) _then;

/// Create a copy of TeacherProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? personId = null,Object? organizationId = null,Object? status = null,Object? joinedDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeacherStatus,joinedDate: null == joinedDate ? _self.joinedDate : joinedDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherProfileModel].
extension TeacherProfileModelPatterns on TeacherProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _TeacherProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String personId,  String organizationId,  TeacherStatus status,  DateTime joinedDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherProfileModel() when $default != null:
return $default(_that.id,_that.personId,_that.organizationId,_that.status,_that.joinedDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String personId,  String organizationId,  TeacherStatus status,  DateTime joinedDate)  $default,) {final _that = this;
switch (_that) {
case _TeacherProfileModel():
return $default(_that.id,_that.personId,_that.organizationId,_that.status,_that.joinedDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String personId,  String organizationId,  TeacherStatus status,  DateTime joinedDate)?  $default,) {final _that = this;
switch (_that) {
case _TeacherProfileModel() when $default != null:
return $default(_that.id,_that.personId,_that.organizationId,_that.status,_that.joinedDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherProfileModel extends TeacherProfileModel {
  const _TeacherProfileModel({required this.id, required this.personId, required this.organizationId, required this.status, required this.joinedDate}): super._();
  factory _TeacherProfileModel.fromJson(Map<String, dynamic> json) => _$TeacherProfileModelFromJson(json);

@override final  String id;
@override final  String personId;
@override final  String organizationId;
@override final  TeacherStatus status;
@override final  DateTime joinedDate;

/// Create a copy of TeacherProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherProfileModelCopyWith<_TeacherProfileModel> get copyWith => __$TeacherProfileModelCopyWithImpl<_TeacherProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.joinedDate, joinedDate) || other.joinedDate == joinedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,organizationId,status,joinedDate);

@override
String toString() {
  return 'TeacherProfileModel(id: $id, personId: $personId, organizationId: $organizationId, status: $status, joinedDate: $joinedDate)';
}


}

/// @nodoc
abstract mixin class _$TeacherProfileModelCopyWith<$Res> implements $TeacherProfileModelCopyWith<$Res> {
  factory _$TeacherProfileModelCopyWith(_TeacherProfileModel value, $Res Function(_TeacherProfileModel) _then) = __$TeacherProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String personId, String organizationId, TeacherStatus status, DateTime joinedDate
});




}
/// @nodoc
class __$TeacherProfileModelCopyWithImpl<$Res>
    implements _$TeacherProfileModelCopyWith<$Res> {
  __$TeacherProfileModelCopyWithImpl(this._self, this._then);

  final _TeacherProfileModel _self;
  final $Res Function(_TeacherProfileModel) _then;

/// Create a copy of TeacherProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? personId = null,Object? organizationId = null,Object? status = null,Object? joinedDate = null,}) {
  return _then(_TeacherProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeacherStatus,joinedDate: null == joinedDate ? _self.joinedDate : joinedDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

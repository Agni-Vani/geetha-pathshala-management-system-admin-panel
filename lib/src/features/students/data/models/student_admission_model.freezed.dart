// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_admission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentAdmissionModel {

 String get id; String get organizationId; String get pathshalaId; String get personId; String get rollNumber; DateTime get admissionDate; AdmissionStatus get status; DateTime get createdAt;
/// Create a copy of StudentAdmissionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentAdmissionModelCopyWith<StudentAdmissionModel> get copyWith => _$StudentAdmissionModelCopyWithImpl<StudentAdmissionModel>(this as StudentAdmissionModel, _$identity);

  /// Serializes this StudentAdmissionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentAdmissionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.rollNumber, rollNumber) || other.rollNumber == rollNumber)&&(identical(other.admissionDate, admissionDate) || other.admissionDate == admissionDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,pathshalaId,personId,rollNumber,admissionDate,status,createdAt);

@override
String toString() {
  return 'StudentAdmissionModel(id: $id, organizationId: $organizationId, pathshalaId: $pathshalaId, personId: $personId, rollNumber: $rollNumber, admissionDate: $admissionDate, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StudentAdmissionModelCopyWith<$Res>  {
  factory $StudentAdmissionModelCopyWith(StudentAdmissionModel value, $Res Function(StudentAdmissionModel) _then) = _$StudentAdmissionModelCopyWithImpl;
@useResult
$Res call({
 String id, String organizationId, String pathshalaId, String personId, String rollNumber, DateTime admissionDate, AdmissionStatus status, DateTime createdAt
});




}
/// @nodoc
class _$StudentAdmissionModelCopyWithImpl<$Res>
    implements $StudentAdmissionModelCopyWith<$Res> {
  _$StudentAdmissionModelCopyWithImpl(this._self, this._then);

  final StudentAdmissionModel _self;
  final $Res Function(StudentAdmissionModel) _then;

/// Create a copy of StudentAdmissionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationId = null,Object? pathshalaId = null,Object? personId = null,Object? rollNumber = null,Object? admissionDate = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: null == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,rollNumber: null == rollNumber ? _self.rollNumber : rollNumber // ignore: cast_nullable_to_non_nullable
as String,admissionDate: null == admissionDate ? _self.admissionDate : admissionDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdmissionStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentAdmissionModel].
extension StudentAdmissionModelPatterns on StudentAdmissionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentAdmissionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentAdmissionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentAdmissionModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentAdmissionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentAdmissionModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentAdmissionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String organizationId,  String pathshalaId,  String personId,  String rollNumber,  DateTime admissionDate,  AdmissionStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentAdmissionModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.pathshalaId,_that.personId,_that.rollNumber,_that.admissionDate,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String organizationId,  String pathshalaId,  String personId,  String rollNumber,  DateTime admissionDate,  AdmissionStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StudentAdmissionModel():
return $default(_that.id,_that.organizationId,_that.pathshalaId,_that.personId,_that.rollNumber,_that.admissionDate,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String organizationId,  String pathshalaId,  String personId,  String rollNumber,  DateTime admissionDate,  AdmissionStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StudentAdmissionModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.pathshalaId,_that.personId,_that.rollNumber,_that.admissionDate,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentAdmissionModel extends StudentAdmissionModel {
  const _StudentAdmissionModel({required this.id, required this.organizationId, required this.pathshalaId, required this.personId, required this.rollNumber, required this.admissionDate, required this.status, required this.createdAt}): super._();
  factory _StudentAdmissionModel.fromJson(Map<String, dynamic> json) => _$StudentAdmissionModelFromJson(json);

@override final  String id;
@override final  String organizationId;
@override final  String pathshalaId;
@override final  String personId;
@override final  String rollNumber;
@override final  DateTime admissionDate;
@override final  AdmissionStatus status;
@override final  DateTime createdAt;

/// Create a copy of StudentAdmissionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentAdmissionModelCopyWith<_StudentAdmissionModel> get copyWith => __$StudentAdmissionModelCopyWithImpl<_StudentAdmissionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentAdmissionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentAdmissionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.rollNumber, rollNumber) || other.rollNumber == rollNumber)&&(identical(other.admissionDate, admissionDate) || other.admissionDate == admissionDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,pathshalaId,personId,rollNumber,admissionDate,status,createdAt);

@override
String toString() {
  return 'StudentAdmissionModel(id: $id, organizationId: $organizationId, pathshalaId: $pathshalaId, personId: $personId, rollNumber: $rollNumber, admissionDate: $admissionDate, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StudentAdmissionModelCopyWith<$Res> implements $StudentAdmissionModelCopyWith<$Res> {
  factory _$StudentAdmissionModelCopyWith(_StudentAdmissionModel value, $Res Function(_StudentAdmissionModel) _then) = __$StudentAdmissionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String organizationId, String pathshalaId, String personId, String rollNumber, DateTime admissionDate, AdmissionStatus status, DateTime createdAt
});




}
/// @nodoc
class __$StudentAdmissionModelCopyWithImpl<$Res>
    implements _$StudentAdmissionModelCopyWith<$Res> {
  __$StudentAdmissionModelCopyWithImpl(this._self, this._then);

  final _StudentAdmissionModel _self;
  final $Res Function(_StudentAdmissionModel) _then;

/// Create a copy of StudentAdmissionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationId = null,Object? pathshalaId = null,Object? personId = null,Object? rollNumber = null,Object? admissionDate = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_StudentAdmissionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: null == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,rollNumber: null == rollNumber ? _self.rollNumber : rollNumber // ignore: cast_nullable_to_non_nullable
as String,admissionDate: null == admissionDate ? _self.admissionDate : admissionDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdmissionStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'academic_year_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AcademicYearModel {

 String get id; String get organizationId; String get name; DateTime get startDate; DateTime get endDate; AcademicYearStatus get status; DateTime get createdAt;
/// Create a copy of AcademicYearModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcademicYearModelCopyWith<AcademicYearModel> get copyWith => _$AcademicYearModelCopyWithImpl<AcademicYearModel>(this as AcademicYearModel, _$identity);

  /// Serializes this AcademicYearModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcademicYearModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,name,startDate,endDate,status,createdAt);

@override
String toString() {
  return 'AcademicYearModel(id: $id, organizationId: $organizationId, name: $name, startDate: $startDate, endDate: $endDate, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AcademicYearModelCopyWith<$Res>  {
  factory $AcademicYearModelCopyWith(AcademicYearModel value, $Res Function(AcademicYearModel) _then) = _$AcademicYearModelCopyWithImpl;
@useResult
$Res call({
 String id, String organizationId, String name, DateTime startDate, DateTime endDate, AcademicYearStatus status, DateTime createdAt
});




}
/// @nodoc
class _$AcademicYearModelCopyWithImpl<$Res>
    implements $AcademicYearModelCopyWith<$Res> {
  _$AcademicYearModelCopyWithImpl(this._self, this._then);

  final AcademicYearModel _self;
  final $Res Function(AcademicYearModel) _then;

/// Create a copy of AcademicYearModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationId = null,Object? name = null,Object? startDate = null,Object? endDate = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AcademicYearStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AcademicYearModel].
extension AcademicYearModelPatterns on AcademicYearModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcademicYearModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcademicYearModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcademicYearModel value)  $default,){
final _that = this;
switch (_that) {
case _AcademicYearModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcademicYearModel value)?  $default,){
final _that = this;
switch (_that) {
case _AcademicYearModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String organizationId,  String name,  DateTime startDate,  DateTime endDate,  AcademicYearStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcademicYearModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.name,_that.startDate,_that.endDate,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String organizationId,  String name,  DateTime startDate,  DateTime endDate,  AcademicYearStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AcademicYearModel():
return $default(_that.id,_that.organizationId,_that.name,_that.startDate,_that.endDate,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String organizationId,  String name,  DateTime startDate,  DateTime endDate,  AcademicYearStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AcademicYearModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.name,_that.startDate,_that.endDate,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AcademicYearModel extends AcademicYearModel {
  const _AcademicYearModel({required this.id, required this.organizationId, required this.name, required this.startDate, required this.endDate, required this.status, required this.createdAt}): super._();
  factory _AcademicYearModel.fromJson(Map<String, dynamic> json) => _$AcademicYearModelFromJson(json);

@override final  String id;
@override final  String organizationId;
@override final  String name;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  AcademicYearStatus status;
@override final  DateTime createdAt;

/// Create a copy of AcademicYearModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcademicYearModelCopyWith<_AcademicYearModel> get copyWith => __$AcademicYearModelCopyWithImpl<_AcademicYearModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AcademicYearModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcademicYearModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,name,startDate,endDate,status,createdAt);

@override
String toString() {
  return 'AcademicYearModel(id: $id, organizationId: $organizationId, name: $name, startDate: $startDate, endDate: $endDate, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AcademicYearModelCopyWith<$Res> implements $AcademicYearModelCopyWith<$Res> {
  factory _$AcademicYearModelCopyWith(_AcademicYearModel value, $Res Function(_AcademicYearModel) _then) = __$AcademicYearModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String organizationId, String name, DateTime startDate, DateTime endDate, AcademicYearStatus status, DateTime createdAt
});




}
/// @nodoc
class __$AcademicYearModelCopyWithImpl<$Res>
    implements _$AcademicYearModelCopyWith<$Res> {
  __$AcademicYearModelCopyWithImpl(this._self, this._then);

  final _AcademicYearModel _self;
  final $Res Function(_AcademicYearModel) _then;

/// Create a copy of AcademicYearModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationId = null,Object? name = null,Object? startDate = null,Object? endDate = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_AcademicYearModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AcademicYearStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pathshala_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PathshalaModel {

 String get id; String get organizationId; String get code; String get name; PathshalaStatus get status; PathshalaAddressModel get address; GeoCoordinateModel? get coordinate; DateTime? get startedOn; DateTime? get closedOn; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of PathshalaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathshalaModelCopyWith<PathshalaModel> get copyWith => _$PathshalaModelCopyWithImpl<PathshalaModel>(this as PathshalaModel, _$identity);

  /// Serializes this PathshalaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathshalaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.address, address) || other.address == address)&&(identical(other.coordinate, coordinate) || other.coordinate == coordinate)&&(identical(other.startedOn, startedOn) || other.startedOn == startedOn)&&(identical(other.closedOn, closedOn) || other.closedOn == closedOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,code,name,status,address,coordinate,startedOn,closedOn,createdAt,updatedAt);

@override
String toString() {
  return 'PathshalaModel(id: $id, organizationId: $organizationId, code: $code, name: $name, status: $status, address: $address, coordinate: $coordinate, startedOn: $startedOn, closedOn: $closedOn, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PathshalaModelCopyWith<$Res>  {
  factory $PathshalaModelCopyWith(PathshalaModel value, $Res Function(PathshalaModel) _then) = _$PathshalaModelCopyWithImpl;
@useResult
$Res call({
 String id, String organizationId, String code, String name, PathshalaStatus status, PathshalaAddressModel address, GeoCoordinateModel? coordinate, DateTime? startedOn, DateTime? closedOn, DateTime createdAt, DateTime updatedAt
});


$PathshalaAddressModelCopyWith<$Res> get address;$GeoCoordinateModelCopyWith<$Res>? get coordinate;

}
/// @nodoc
class _$PathshalaModelCopyWithImpl<$Res>
    implements $PathshalaModelCopyWith<$Res> {
  _$PathshalaModelCopyWithImpl(this._self, this._then);

  final PathshalaModel _self;
  final $Res Function(PathshalaModel) _then;

/// Create a copy of PathshalaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationId = null,Object? code = null,Object? name = null,Object? status = null,Object? address = null,Object? coordinate = freezed,Object? startedOn = freezed,Object? closedOn = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PathshalaStatus,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as PathshalaAddressModel,coordinate: freezed == coordinate ? _self.coordinate : coordinate // ignore: cast_nullable_to_non_nullable
as GeoCoordinateModel?,startedOn: freezed == startedOn ? _self.startedOn : startedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,closedOn: freezed == closedOn ? _self.closedOn : closedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of PathshalaModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PathshalaAddressModelCopyWith<$Res> get address {
  
  return $PathshalaAddressModelCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of PathshalaModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoCoordinateModelCopyWith<$Res>? get coordinate {
    if (_self.coordinate == null) {
    return null;
  }

  return $GeoCoordinateModelCopyWith<$Res>(_self.coordinate!, (value) {
    return _then(_self.copyWith(coordinate: value));
  });
}
}


/// Adds pattern-matching-related methods to [PathshalaModel].
extension PathshalaModelPatterns on PathshalaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathshalaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathshalaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathshalaModel value)  $default,){
final _that = this;
switch (_that) {
case _PathshalaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathshalaModel value)?  $default,){
final _that = this;
switch (_that) {
case _PathshalaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String organizationId,  String code,  String name,  PathshalaStatus status,  PathshalaAddressModel address,  GeoCoordinateModel? coordinate,  DateTime? startedOn,  DateTime? closedOn,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathshalaModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.code,_that.name,_that.status,_that.address,_that.coordinate,_that.startedOn,_that.closedOn,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String organizationId,  String code,  String name,  PathshalaStatus status,  PathshalaAddressModel address,  GeoCoordinateModel? coordinate,  DateTime? startedOn,  DateTime? closedOn,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PathshalaModel():
return $default(_that.id,_that.organizationId,_that.code,_that.name,_that.status,_that.address,_that.coordinate,_that.startedOn,_that.closedOn,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String organizationId,  String code,  String name,  PathshalaStatus status,  PathshalaAddressModel address,  GeoCoordinateModel? coordinate,  DateTime? startedOn,  DateTime? closedOn,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PathshalaModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.code,_that.name,_that.status,_that.address,_that.coordinate,_that.startedOn,_that.closedOn,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PathshalaModel extends PathshalaModel {
  const _PathshalaModel({required this.id, required this.organizationId, required this.code, required this.name, required this.status, required this.address, required this.coordinate, required this.startedOn, required this.closedOn, required this.createdAt, required this.updatedAt}): super._();
  factory _PathshalaModel.fromJson(Map<String, dynamic> json) => _$PathshalaModelFromJson(json);

@override final  String id;
@override final  String organizationId;
@override final  String code;
@override final  String name;
@override final  PathshalaStatus status;
@override final  PathshalaAddressModel address;
@override final  GeoCoordinateModel? coordinate;
@override final  DateTime? startedOn;
@override final  DateTime? closedOn;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of PathshalaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathshalaModelCopyWith<_PathshalaModel> get copyWith => __$PathshalaModelCopyWithImpl<_PathshalaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PathshalaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathshalaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.address, address) || other.address == address)&&(identical(other.coordinate, coordinate) || other.coordinate == coordinate)&&(identical(other.startedOn, startedOn) || other.startedOn == startedOn)&&(identical(other.closedOn, closedOn) || other.closedOn == closedOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,code,name,status,address,coordinate,startedOn,closedOn,createdAt,updatedAt);

@override
String toString() {
  return 'PathshalaModel(id: $id, organizationId: $organizationId, code: $code, name: $name, status: $status, address: $address, coordinate: $coordinate, startedOn: $startedOn, closedOn: $closedOn, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PathshalaModelCopyWith<$Res> implements $PathshalaModelCopyWith<$Res> {
  factory _$PathshalaModelCopyWith(_PathshalaModel value, $Res Function(_PathshalaModel) _then) = __$PathshalaModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String organizationId, String code, String name, PathshalaStatus status, PathshalaAddressModel address, GeoCoordinateModel? coordinate, DateTime? startedOn, DateTime? closedOn, DateTime createdAt, DateTime updatedAt
});


@override $PathshalaAddressModelCopyWith<$Res> get address;@override $GeoCoordinateModelCopyWith<$Res>? get coordinate;

}
/// @nodoc
class __$PathshalaModelCopyWithImpl<$Res>
    implements _$PathshalaModelCopyWith<$Res> {
  __$PathshalaModelCopyWithImpl(this._self, this._then);

  final _PathshalaModel _self;
  final $Res Function(_PathshalaModel) _then;

/// Create a copy of PathshalaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationId = null,Object? code = null,Object? name = null,Object? status = null,Object? address = null,Object? coordinate = freezed,Object? startedOn = freezed,Object? closedOn = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PathshalaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PathshalaStatus,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as PathshalaAddressModel,coordinate: freezed == coordinate ? _self.coordinate : coordinate // ignore: cast_nullable_to_non_nullable
as GeoCoordinateModel?,startedOn: freezed == startedOn ? _self.startedOn : startedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,closedOn: freezed == closedOn ? _self.closedOn : closedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of PathshalaModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PathshalaAddressModelCopyWith<$Res> get address {
  
  return $PathshalaAddressModelCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of PathshalaModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoCoordinateModelCopyWith<$Res>? get coordinate {
    if (_self.coordinate == null) {
    return null;
  }

  return $GeoCoordinateModelCopyWith<$Res>(_self.coordinate!, (value) {
    return _then(_self.copyWith(coordinate: value));
  });
}
}


/// @nodoc
mixin _$PathshalaAddressModel {

 String get addressLine1; String? get addressLine2; String get city; String get region; String get country; String? get postalCode;
/// Create a copy of PathshalaAddressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathshalaAddressModelCopyWith<PathshalaAddressModel> get copyWith => _$PathshalaAddressModelCopyWithImpl<PathshalaAddressModel>(this as PathshalaAddressModel, _$identity);

  /// Serializes this PathshalaAddressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathshalaAddressModel&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.city, city) || other.city == city)&&(identical(other.region, region) || other.region == region)&&(identical(other.country, country) || other.country == country)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,addressLine1,addressLine2,city,region,country,postalCode);

@override
String toString() {
  return 'PathshalaAddressModel(addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, region: $region, country: $country, postalCode: $postalCode)';
}


}

/// @nodoc
abstract mixin class $PathshalaAddressModelCopyWith<$Res>  {
  factory $PathshalaAddressModelCopyWith(PathshalaAddressModel value, $Res Function(PathshalaAddressModel) _then) = _$PathshalaAddressModelCopyWithImpl;
@useResult
$Res call({
 String addressLine1, String? addressLine2, String city, String region, String country, String? postalCode
});




}
/// @nodoc
class _$PathshalaAddressModelCopyWithImpl<$Res>
    implements $PathshalaAddressModelCopyWith<$Res> {
  _$PathshalaAddressModelCopyWithImpl(this._self, this._then);

  final PathshalaAddressModel _self;
  final $Res Function(PathshalaAddressModel) _then;

/// Create a copy of PathshalaAddressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? addressLine1 = null,Object? addressLine2 = freezed,Object? city = null,Object? region = null,Object? country = null,Object? postalCode = freezed,}) {
  return _then(_self.copyWith(
addressLine1: null == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PathshalaAddressModel].
extension PathshalaAddressModelPatterns on PathshalaAddressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathshalaAddressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathshalaAddressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathshalaAddressModel value)  $default,){
final _that = this;
switch (_that) {
case _PathshalaAddressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathshalaAddressModel value)?  $default,){
final _that = this;
switch (_that) {
case _PathshalaAddressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String addressLine1,  String? addressLine2,  String city,  String region,  String country,  String? postalCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathshalaAddressModel() when $default != null:
return $default(_that.addressLine1,_that.addressLine2,_that.city,_that.region,_that.country,_that.postalCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String addressLine1,  String? addressLine2,  String city,  String region,  String country,  String? postalCode)  $default,) {final _that = this;
switch (_that) {
case _PathshalaAddressModel():
return $default(_that.addressLine1,_that.addressLine2,_that.city,_that.region,_that.country,_that.postalCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String addressLine1,  String? addressLine2,  String city,  String region,  String country,  String? postalCode)?  $default,) {final _that = this;
switch (_that) {
case _PathshalaAddressModel() when $default != null:
return $default(_that.addressLine1,_that.addressLine2,_that.city,_that.region,_that.country,_that.postalCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PathshalaAddressModel extends PathshalaAddressModel {
  const _PathshalaAddressModel({required this.addressLine1, required this.addressLine2, required this.city, required this.region, required this.country, required this.postalCode}): super._();
  factory _PathshalaAddressModel.fromJson(Map<String, dynamic> json) => _$PathshalaAddressModelFromJson(json);

@override final  String addressLine1;
@override final  String? addressLine2;
@override final  String city;
@override final  String region;
@override final  String country;
@override final  String? postalCode;

/// Create a copy of PathshalaAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathshalaAddressModelCopyWith<_PathshalaAddressModel> get copyWith => __$PathshalaAddressModelCopyWithImpl<_PathshalaAddressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PathshalaAddressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathshalaAddressModel&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.city, city) || other.city == city)&&(identical(other.region, region) || other.region == region)&&(identical(other.country, country) || other.country == country)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,addressLine1,addressLine2,city,region,country,postalCode);

@override
String toString() {
  return 'PathshalaAddressModel(addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, region: $region, country: $country, postalCode: $postalCode)';
}


}

/// @nodoc
abstract mixin class _$PathshalaAddressModelCopyWith<$Res> implements $PathshalaAddressModelCopyWith<$Res> {
  factory _$PathshalaAddressModelCopyWith(_PathshalaAddressModel value, $Res Function(_PathshalaAddressModel) _then) = __$PathshalaAddressModelCopyWithImpl;
@override @useResult
$Res call({
 String addressLine1, String? addressLine2, String city, String region, String country, String? postalCode
});




}
/// @nodoc
class __$PathshalaAddressModelCopyWithImpl<$Res>
    implements _$PathshalaAddressModelCopyWith<$Res> {
  __$PathshalaAddressModelCopyWithImpl(this._self, this._then);

  final _PathshalaAddressModel _self;
  final $Res Function(_PathshalaAddressModel) _then;

/// Create a copy of PathshalaAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? addressLine1 = null,Object? addressLine2 = freezed,Object? city = null,Object? region = null,Object? country = null,Object? postalCode = freezed,}) {
  return _then(_PathshalaAddressModel(
addressLine1: null == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GeoCoordinateModel {

 double get latitude; double get longitude;
/// Create a copy of GeoCoordinateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoCoordinateModelCopyWith<GeoCoordinateModel> get copyWith => _$GeoCoordinateModelCopyWithImpl<GeoCoordinateModel>(this as GeoCoordinateModel, _$identity);

  /// Serializes this GeoCoordinateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoCoordinateModel&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'GeoCoordinateModel(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $GeoCoordinateModelCopyWith<$Res>  {
  factory $GeoCoordinateModelCopyWith(GeoCoordinateModel value, $Res Function(GeoCoordinateModel) _then) = _$GeoCoordinateModelCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$GeoCoordinateModelCopyWithImpl<$Res>
    implements $GeoCoordinateModelCopyWith<$Res> {
  _$GeoCoordinateModelCopyWithImpl(this._self, this._then);

  final GeoCoordinateModel _self;
  final $Res Function(GeoCoordinateModel) _then;

/// Create a copy of GeoCoordinateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoCoordinateModel].
extension GeoCoordinateModelPatterns on GeoCoordinateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoCoordinateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoCoordinateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoCoordinateModel value)  $default,){
final _that = this;
switch (_that) {
case _GeoCoordinateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoCoordinateModel value)?  $default,){
final _that = this;
switch (_that) {
case _GeoCoordinateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoCoordinateModel() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _GeoCoordinateModel():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _GeoCoordinateModel() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoCoordinateModel extends GeoCoordinateModel {
  const _GeoCoordinateModel({required this.latitude, required this.longitude}): super._();
  factory _GeoCoordinateModel.fromJson(Map<String, dynamic> json) => _$GeoCoordinateModelFromJson(json);

@override final  double latitude;
@override final  double longitude;

/// Create a copy of GeoCoordinateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoCoordinateModelCopyWith<_GeoCoordinateModel> get copyWith => __$GeoCoordinateModelCopyWithImpl<_GeoCoordinateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoCoordinateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoCoordinateModel&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'GeoCoordinateModel(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$GeoCoordinateModelCopyWith<$Res> implements $GeoCoordinateModelCopyWith<$Res> {
  factory _$GeoCoordinateModelCopyWith(_GeoCoordinateModel value, $Res Function(_GeoCoordinateModel) _then) = __$GeoCoordinateModelCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$GeoCoordinateModelCopyWithImpl<$Res>
    implements _$GeoCoordinateModelCopyWith<$Res> {
  __$GeoCoordinateModelCopyWithImpl(this._self, this._then);

  final _GeoCoordinateModel _self;
  final $Res Function(_GeoCoordinateModel) _then;

/// Create a copy of GeoCoordinateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_GeoCoordinateModel(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

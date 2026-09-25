// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonModel {

 String get id; String get organizationId; String get legalName; String? get preferredName; DateTime? get dateOfBirth; String? get gender; String? get primaryPhone; String? get primaryEmail; PersonStatus get status; String? get createdByUserId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of PersonModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonModelCopyWith<PersonModel> get copyWith => _$PersonModelCopyWithImpl<PersonModel>(this as PersonModel, _$identity);

  /// Serializes this PersonModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.preferredName, preferredName) || other.preferredName == preferredName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.primaryPhone, primaryPhone) || other.primaryPhone == primaryPhone)&&(identical(other.primaryEmail, primaryEmail) || other.primaryEmail == primaryEmail)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,legalName,preferredName,dateOfBirth,gender,primaryPhone,primaryEmail,status,createdByUserId,createdAt,updatedAt);

@override
String toString() {
  return 'PersonModel(id: $id, organizationId: $organizationId, legalName: $legalName, preferredName: $preferredName, dateOfBirth: $dateOfBirth, gender: $gender, primaryPhone: $primaryPhone, primaryEmail: $primaryEmail, status: $status, createdByUserId: $createdByUserId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PersonModelCopyWith<$Res>  {
  factory $PersonModelCopyWith(PersonModel value, $Res Function(PersonModel) _then) = _$PersonModelCopyWithImpl;
@useResult
$Res call({
 String id, String organizationId, String legalName, String? preferredName, DateTime? dateOfBirth, String? gender, String? primaryPhone, String? primaryEmail, PersonStatus status, String? createdByUserId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PersonModelCopyWithImpl<$Res>
    implements $PersonModelCopyWith<$Res> {
  _$PersonModelCopyWithImpl(this._self, this._then);

  final PersonModel _self;
  final $Res Function(PersonModel) _then;

/// Create a copy of PersonModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationId = null,Object? legalName = null,Object? preferredName = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? primaryPhone = freezed,Object? primaryEmail = freezed,Object? status = null,Object? createdByUserId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,legalName: null == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String,preferredName: freezed == preferredName ? _self.preferredName : preferredName // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,primaryPhone: freezed == primaryPhone ? _self.primaryPhone : primaryPhone // ignore: cast_nullable_to_non_nullable
as String?,primaryEmail: freezed == primaryEmail ? _self.primaryEmail : primaryEmail // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PersonStatus,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonModel].
extension PersonModelPatterns on PersonModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonModel value)  $default,){
final _that = this;
switch (_that) {
case _PersonModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonModel value)?  $default,){
final _that = this;
switch (_that) {
case _PersonModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String organizationId,  String legalName,  String? preferredName,  DateTime? dateOfBirth,  String? gender,  String? primaryPhone,  String? primaryEmail,  PersonStatus status,  String? createdByUserId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.legalName,_that.preferredName,_that.dateOfBirth,_that.gender,_that.primaryPhone,_that.primaryEmail,_that.status,_that.createdByUserId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String organizationId,  String legalName,  String? preferredName,  DateTime? dateOfBirth,  String? gender,  String? primaryPhone,  String? primaryEmail,  PersonStatus status,  String? createdByUserId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PersonModel():
return $default(_that.id,_that.organizationId,_that.legalName,_that.preferredName,_that.dateOfBirth,_that.gender,_that.primaryPhone,_that.primaryEmail,_that.status,_that.createdByUserId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String organizationId,  String legalName,  String? preferredName,  DateTime? dateOfBirth,  String? gender,  String? primaryPhone,  String? primaryEmail,  PersonStatus status,  String? createdByUserId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PersonModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.legalName,_that.preferredName,_that.dateOfBirth,_that.gender,_that.primaryPhone,_that.primaryEmail,_that.status,_that.createdByUserId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonModel extends PersonModel {
  const _PersonModel({required this.id, required this.organizationId, required this.legalName, required this.preferredName, required this.dateOfBirth, required this.gender, required this.primaryPhone, required this.primaryEmail, required this.status, required this.createdByUserId, required this.createdAt, required this.updatedAt}): super._();
  factory _PersonModel.fromJson(Map<String, dynamic> json) => _$PersonModelFromJson(json);

@override final  String id;
@override final  String organizationId;
@override final  String legalName;
@override final  String? preferredName;
@override final  DateTime? dateOfBirth;
@override final  String? gender;
@override final  String? primaryPhone;
@override final  String? primaryEmail;
@override final  PersonStatus status;
@override final  String? createdByUserId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of PersonModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonModelCopyWith<_PersonModel> get copyWith => __$PersonModelCopyWithImpl<_PersonModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.preferredName, preferredName) || other.preferredName == preferredName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.primaryPhone, primaryPhone) || other.primaryPhone == primaryPhone)&&(identical(other.primaryEmail, primaryEmail) || other.primaryEmail == primaryEmail)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,legalName,preferredName,dateOfBirth,gender,primaryPhone,primaryEmail,status,createdByUserId,createdAt,updatedAt);

@override
String toString() {
  return 'PersonModel(id: $id, organizationId: $organizationId, legalName: $legalName, preferredName: $preferredName, dateOfBirth: $dateOfBirth, gender: $gender, primaryPhone: $primaryPhone, primaryEmail: $primaryEmail, status: $status, createdByUserId: $createdByUserId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PersonModelCopyWith<$Res> implements $PersonModelCopyWith<$Res> {
  factory _$PersonModelCopyWith(_PersonModel value, $Res Function(_PersonModel) _then) = __$PersonModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String organizationId, String legalName, String? preferredName, DateTime? dateOfBirth, String? gender, String? primaryPhone, String? primaryEmail, PersonStatus status, String? createdByUserId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PersonModelCopyWithImpl<$Res>
    implements _$PersonModelCopyWith<$Res> {
  __$PersonModelCopyWithImpl(this._self, this._then);

  final _PersonModel _self;
  final $Res Function(_PersonModel) _then;

/// Create a copy of PersonModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationId = null,Object? legalName = null,Object? preferredName = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? primaryPhone = freezed,Object? primaryEmail = freezed,Object? status = null,Object? createdByUserId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PersonModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,legalName: null == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String,preferredName: freezed == preferredName ? _self.preferredName : preferredName // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,primaryPhone: freezed == primaryPhone ? _self.primaryPhone : primaryPhone // ignore: cast_nullable_to_non_nullable
as String?,primaryEmail: freezed == primaryEmail ? _self.primaryEmail : primaryEmail // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PersonStatus,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PersonContactModel {

 String get id; String get personId; ContactType get type; String get label; String get value; bool get isPrimary; DateTime? get verifiedAt;
/// Create a copy of PersonContactModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonContactModelCopyWith<PersonContactModel> get copyWith => _$PersonContactModelCopyWithImpl<PersonContactModel>(this as PersonContactModel, _$identity);

  /// Serializes this PersonContactModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonContactModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,type,label,value,isPrimary,verifiedAt);

@override
String toString() {
  return 'PersonContactModel(id: $id, personId: $personId, type: $type, label: $label, value: $value, isPrimary: $isPrimary, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class $PersonContactModelCopyWith<$Res>  {
  factory $PersonContactModelCopyWith(PersonContactModel value, $Res Function(PersonContactModel) _then) = _$PersonContactModelCopyWithImpl;
@useResult
$Res call({
 String id, String personId, ContactType type, String label, String value, bool isPrimary, DateTime? verifiedAt
});




}
/// @nodoc
class _$PersonContactModelCopyWithImpl<$Res>
    implements $PersonContactModelCopyWith<$Res> {
  _$PersonContactModelCopyWithImpl(this._self, this._then);

  final PersonContactModel _self;
  final $Res Function(PersonContactModel) _then;

/// Create a copy of PersonContactModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? personId = null,Object? type = null,Object? label = null,Object? value = null,Object? isPrimary = null,Object? verifiedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ContactType,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonContactModel].
extension PersonContactModelPatterns on PersonContactModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonContactModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonContactModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonContactModel value)  $default,){
final _that = this;
switch (_that) {
case _PersonContactModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonContactModel value)?  $default,){
final _that = this;
switch (_that) {
case _PersonContactModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String personId,  ContactType type,  String label,  String value,  bool isPrimary,  DateTime? verifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonContactModel() when $default != null:
return $default(_that.id,_that.personId,_that.type,_that.label,_that.value,_that.isPrimary,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String personId,  ContactType type,  String label,  String value,  bool isPrimary,  DateTime? verifiedAt)  $default,) {final _that = this;
switch (_that) {
case _PersonContactModel():
return $default(_that.id,_that.personId,_that.type,_that.label,_that.value,_that.isPrimary,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String personId,  ContactType type,  String label,  String value,  bool isPrimary,  DateTime? verifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _PersonContactModel() when $default != null:
return $default(_that.id,_that.personId,_that.type,_that.label,_that.value,_that.isPrimary,_that.verifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonContactModel extends PersonContactModel {
  const _PersonContactModel({required this.id, required this.personId, required this.type, required this.label, required this.value, required this.isPrimary, required this.verifiedAt}): super._();
  factory _PersonContactModel.fromJson(Map<String, dynamic> json) => _$PersonContactModelFromJson(json);

@override final  String id;
@override final  String personId;
@override final  ContactType type;
@override final  String label;
@override final  String value;
@override final  bool isPrimary;
@override final  DateTime? verifiedAt;

/// Create a copy of PersonContactModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonContactModelCopyWith<_PersonContactModel> get copyWith => __$PersonContactModelCopyWithImpl<_PersonContactModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonContactModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonContactModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,type,label,value,isPrimary,verifiedAt);

@override
String toString() {
  return 'PersonContactModel(id: $id, personId: $personId, type: $type, label: $label, value: $value, isPrimary: $isPrimary, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class _$PersonContactModelCopyWith<$Res> implements $PersonContactModelCopyWith<$Res> {
  factory _$PersonContactModelCopyWith(_PersonContactModel value, $Res Function(_PersonContactModel) _then) = __$PersonContactModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String personId, ContactType type, String label, String value, bool isPrimary, DateTime? verifiedAt
});




}
/// @nodoc
class __$PersonContactModelCopyWithImpl<$Res>
    implements _$PersonContactModelCopyWith<$Res> {
  __$PersonContactModelCopyWithImpl(this._self, this._then);

  final _PersonContactModel _self;
  final $Res Function(_PersonContactModel) _then;

/// Create a copy of PersonContactModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? personId = null,Object? type = null,Object? label = null,Object? value = null,Object? isPrimary = null,Object? verifiedAt = freezed,}) {
  return _then(_PersonContactModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ContactType,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PersonRelationshipModel {

 String get id; String get personId; String get relatedPersonId; PersonRelationshipType get type; bool get isPrimaryGuardian; DateTime get effectiveFrom; DateTime? get effectiveTo;
/// Create a copy of PersonRelationshipModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonRelationshipModelCopyWith<PersonRelationshipModel> get copyWith => _$PersonRelationshipModelCopyWithImpl<PersonRelationshipModel>(this as PersonRelationshipModel, _$identity);

  /// Serializes this PersonRelationshipModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonRelationshipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.relatedPersonId, relatedPersonId) || other.relatedPersonId == relatedPersonId)&&(identical(other.type, type) || other.type == type)&&(identical(other.isPrimaryGuardian, isPrimaryGuardian) || other.isPrimaryGuardian == isPrimaryGuardian)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,relatedPersonId,type,isPrimaryGuardian,effectiveFrom,effectiveTo);

@override
String toString() {
  return 'PersonRelationshipModel(id: $id, personId: $personId, relatedPersonId: $relatedPersonId, type: $type, isPrimaryGuardian: $isPrimaryGuardian, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
}


}

/// @nodoc
abstract mixin class $PersonRelationshipModelCopyWith<$Res>  {
  factory $PersonRelationshipModelCopyWith(PersonRelationshipModel value, $Res Function(PersonRelationshipModel) _then) = _$PersonRelationshipModelCopyWithImpl;
@useResult
$Res call({
 String id, String personId, String relatedPersonId, PersonRelationshipType type, bool isPrimaryGuardian, DateTime effectiveFrom, DateTime? effectiveTo
});




}
/// @nodoc
class _$PersonRelationshipModelCopyWithImpl<$Res>
    implements $PersonRelationshipModelCopyWith<$Res> {
  _$PersonRelationshipModelCopyWithImpl(this._self, this._then);

  final PersonRelationshipModel _self;
  final $Res Function(PersonRelationshipModel) _then;

/// Create a copy of PersonRelationshipModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? personId = null,Object? relatedPersonId = null,Object? type = null,Object? isPrimaryGuardian = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,relatedPersonId: null == relatedPersonId ? _self.relatedPersonId : relatedPersonId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PersonRelationshipType,isPrimaryGuardian: null == isPrimaryGuardian ? _self.isPrimaryGuardian : isPrimaryGuardian // ignore: cast_nullable_to_non_nullable
as bool,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonRelationshipModel].
extension PersonRelationshipModelPatterns on PersonRelationshipModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonRelationshipModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonRelationshipModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonRelationshipModel value)  $default,){
final _that = this;
switch (_that) {
case _PersonRelationshipModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonRelationshipModel value)?  $default,){
final _that = this;
switch (_that) {
case _PersonRelationshipModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String personId,  String relatedPersonId,  PersonRelationshipType type,  bool isPrimaryGuardian,  DateTime effectiveFrom,  DateTime? effectiveTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonRelationshipModel() when $default != null:
return $default(_that.id,_that.personId,_that.relatedPersonId,_that.type,_that.isPrimaryGuardian,_that.effectiveFrom,_that.effectiveTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String personId,  String relatedPersonId,  PersonRelationshipType type,  bool isPrimaryGuardian,  DateTime effectiveFrom,  DateTime? effectiveTo)  $default,) {final _that = this;
switch (_that) {
case _PersonRelationshipModel():
return $default(_that.id,_that.personId,_that.relatedPersonId,_that.type,_that.isPrimaryGuardian,_that.effectiveFrom,_that.effectiveTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String personId,  String relatedPersonId,  PersonRelationshipType type,  bool isPrimaryGuardian,  DateTime effectiveFrom,  DateTime? effectiveTo)?  $default,) {final _that = this;
switch (_that) {
case _PersonRelationshipModel() when $default != null:
return $default(_that.id,_that.personId,_that.relatedPersonId,_that.type,_that.isPrimaryGuardian,_that.effectiveFrom,_that.effectiveTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonRelationshipModel extends PersonRelationshipModel {
  const _PersonRelationshipModel({required this.id, required this.personId, required this.relatedPersonId, required this.type, required this.isPrimaryGuardian, required this.effectiveFrom, required this.effectiveTo}): super._();
  factory _PersonRelationshipModel.fromJson(Map<String, dynamic> json) => _$PersonRelationshipModelFromJson(json);

@override final  String id;
@override final  String personId;
@override final  String relatedPersonId;
@override final  PersonRelationshipType type;
@override final  bool isPrimaryGuardian;
@override final  DateTime effectiveFrom;
@override final  DateTime? effectiveTo;

/// Create a copy of PersonRelationshipModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonRelationshipModelCopyWith<_PersonRelationshipModel> get copyWith => __$PersonRelationshipModelCopyWithImpl<_PersonRelationshipModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonRelationshipModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonRelationshipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.relatedPersonId, relatedPersonId) || other.relatedPersonId == relatedPersonId)&&(identical(other.type, type) || other.type == type)&&(identical(other.isPrimaryGuardian, isPrimaryGuardian) || other.isPrimaryGuardian == isPrimaryGuardian)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,relatedPersonId,type,isPrimaryGuardian,effectiveFrom,effectiveTo);

@override
String toString() {
  return 'PersonRelationshipModel(id: $id, personId: $personId, relatedPersonId: $relatedPersonId, type: $type, isPrimaryGuardian: $isPrimaryGuardian, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
}


}

/// @nodoc
abstract mixin class _$PersonRelationshipModelCopyWith<$Res> implements $PersonRelationshipModelCopyWith<$Res> {
  factory _$PersonRelationshipModelCopyWith(_PersonRelationshipModel value, $Res Function(_PersonRelationshipModel) _then) = __$PersonRelationshipModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String personId, String relatedPersonId, PersonRelationshipType type, bool isPrimaryGuardian, DateTime effectiveFrom, DateTime? effectiveTo
});




}
/// @nodoc
class __$PersonRelationshipModelCopyWithImpl<$Res>
    implements _$PersonRelationshipModelCopyWith<$Res> {
  __$PersonRelationshipModelCopyWithImpl(this._self, this._then);

  final _PersonRelationshipModel _self;
  final $Res Function(_PersonRelationshipModel) _then;

/// Create a copy of PersonRelationshipModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? personId = null,Object? relatedPersonId = null,Object? type = null,Object? isPrimaryGuardian = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,}) {
  return _then(_PersonRelationshipModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,relatedPersonId: null == relatedPersonId ? _self.relatedPersonId : relatedPersonId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PersonRelationshipType,isPrimaryGuardian: null == isPrimaryGuardian ? _self.isPrimaryGuardian : isPrimaryGuardian // ignore: cast_nullable_to_non_nullable
as bool,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

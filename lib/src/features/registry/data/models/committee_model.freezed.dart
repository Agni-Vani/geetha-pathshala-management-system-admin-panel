// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'committee_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommitteeModel {

 String get id; String get organizationId; String? get pathshalaId; String get name; CommitteeType get type; CommitteeStatus get status;
/// Create a copy of CommitteeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommitteeModelCopyWith<CommitteeModel> get copyWith => _$CommitteeModelCopyWithImpl<CommitteeModel>(this as CommitteeModel, _$identity);

  /// Serializes this CommitteeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommitteeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,pathshalaId,name,type,status);

@override
String toString() {
  return 'CommitteeModel(id: $id, organizationId: $organizationId, pathshalaId: $pathshalaId, name: $name, type: $type, status: $status)';
}


}

/// @nodoc
abstract mixin class $CommitteeModelCopyWith<$Res>  {
  factory $CommitteeModelCopyWith(CommitteeModel value, $Res Function(CommitteeModel) _then) = _$CommitteeModelCopyWithImpl;
@useResult
$Res call({
 String id, String organizationId, String? pathshalaId, String name, CommitteeType type, CommitteeStatus status
});




}
/// @nodoc
class _$CommitteeModelCopyWithImpl<$Res>
    implements $CommitteeModelCopyWith<$Res> {
  _$CommitteeModelCopyWithImpl(this._self, this._then);

  final CommitteeModel _self;
  final $Res Function(CommitteeModel) _then;

/// Create a copy of CommitteeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationId = null,Object? pathshalaId = freezed,Object? name = null,Object? type = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: freezed == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CommitteeType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommitteeStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CommitteeModel].
extension CommitteeModelPatterns on CommitteeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommitteeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommitteeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommitteeModel value)  $default,){
final _that = this;
switch (_that) {
case _CommitteeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommitteeModel value)?  $default,){
final _that = this;
switch (_that) {
case _CommitteeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String organizationId,  String? pathshalaId,  String name,  CommitteeType type,  CommitteeStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommitteeModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.pathshalaId,_that.name,_that.type,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String organizationId,  String? pathshalaId,  String name,  CommitteeType type,  CommitteeStatus status)  $default,) {final _that = this;
switch (_that) {
case _CommitteeModel():
return $default(_that.id,_that.organizationId,_that.pathshalaId,_that.name,_that.type,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String organizationId,  String? pathshalaId,  String name,  CommitteeType type,  CommitteeStatus status)?  $default,) {final _that = this;
switch (_that) {
case _CommitteeModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.pathshalaId,_that.name,_that.type,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommitteeModel extends CommitteeModel {
  const _CommitteeModel({required this.id, required this.organizationId, required this.pathshalaId, required this.name, required this.type, required this.status}): super._();
  factory _CommitteeModel.fromJson(Map<String, dynamic> json) => _$CommitteeModelFromJson(json);

@override final  String id;
@override final  String organizationId;
@override final  String? pathshalaId;
@override final  String name;
@override final  CommitteeType type;
@override final  CommitteeStatus status;

/// Create a copy of CommitteeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommitteeModelCopyWith<_CommitteeModel> get copyWith => __$CommitteeModelCopyWithImpl<_CommitteeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommitteeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommitteeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,pathshalaId,name,type,status);

@override
String toString() {
  return 'CommitteeModel(id: $id, organizationId: $organizationId, pathshalaId: $pathshalaId, name: $name, type: $type, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CommitteeModelCopyWith<$Res> implements $CommitteeModelCopyWith<$Res> {
  factory _$CommitteeModelCopyWith(_CommitteeModel value, $Res Function(_CommitteeModel) _then) = __$CommitteeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String organizationId, String? pathshalaId, String name, CommitteeType type, CommitteeStatus status
});




}
/// @nodoc
class __$CommitteeModelCopyWithImpl<$Res>
    implements _$CommitteeModelCopyWith<$Res> {
  __$CommitteeModelCopyWithImpl(this._self, this._then);

  final _CommitteeModel _self;
  final $Res Function(_CommitteeModel) _then;

/// Create a copy of CommitteeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationId = null,Object? pathshalaId = freezed,Object? name = null,Object? type = null,Object? status = null,}) {
  return _then(_CommitteeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: freezed == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CommitteeType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommitteeStatus,
  ));
}


}


/// @nodoc
mixin _$CommitteeMembershipModel {

 String get id; String get committeeId; String get personId; String get title; DateTime get effectiveFrom; DateTime? get effectiveTo; CommitteeMembershipStatus get status;
/// Create a copy of CommitteeMembershipModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommitteeMembershipModelCopyWith<CommitteeMembershipModel> get copyWith => _$CommitteeMembershipModelCopyWithImpl<CommitteeMembershipModel>(this as CommitteeMembershipModel, _$identity);

  /// Serializes this CommitteeMembershipModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommitteeMembershipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.committeeId, committeeId) || other.committeeId == committeeId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.title, title) || other.title == title)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,committeeId,personId,title,effectiveFrom,effectiveTo,status);

@override
String toString() {
  return 'CommitteeMembershipModel(id: $id, committeeId: $committeeId, personId: $personId, title: $title, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, status: $status)';
}


}

/// @nodoc
abstract mixin class $CommitteeMembershipModelCopyWith<$Res>  {
  factory $CommitteeMembershipModelCopyWith(CommitteeMembershipModel value, $Res Function(CommitteeMembershipModel) _then) = _$CommitteeMembershipModelCopyWithImpl;
@useResult
$Res call({
 String id, String committeeId, String personId, String title, DateTime effectiveFrom, DateTime? effectiveTo, CommitteeMembershipStatus status
});




}
/// @nodoc
class _$CommitteeMembershipModelCopyWithImpl<$Res>
    implements $CommitteeMembershipModelCopyWith<$Res> {
  _$CommitteeMembershipModelCopyWithImpl(this._self, this._then);

  final CommitteeMembershipModel _self;
  final $Res Function(CommitteeMembershipModel) _then;

/// Create a copy of CommitteeMembershipModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? committeeId = null,Object? personId = null,Object? title = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,committeeId: null == committeeId ? _self.committeeId : committeeId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommitteeMembershipStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CommitteeMembershipModel].
extension CommitteeMembershipModelPatterns on CommitteeMembershipModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommitteeMembershipModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommitteeMembershipModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommitteeMembershipModel value)  $default,){
final _that = this;
switch (_that) {
case _CommitteeMembershipModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommitteeMembershipModel value)?  $default,){
final _that = this;
switch (_that) {
case _CommitteeMembershipModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String committeeId,  String personId,  String title,  DateTime effectiveFrom,  DateTime? effectiveTo,  CommitteeMembershipStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommitteeMembershipModel() when $default != null:
return $default(_that.id,_that.committeeId,_that.personId,_that.title,_that.effectiveFrom,_that.effectiveTo,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String committeeId,  String personId,  String title,  DateTime effectiveFrom,  DateTime? effectiveTo,  CommitteeMembershipStatus status)  $default,) {final _that = this;
switch (_that) {
case _CommitteeMembershipModel():
return $default(_that.id,_that.committeeId,_that.personId,_that.title,_that.effectiveFrom,_that.effectiveTo,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String committeeId,  String personId,  String title,  DateTime effectiveFrom,  DateTime? effectiveTo,  CommitteeMembershipStatus status)?  $default,) {final _that = this;
switch (_that) {
case _CommitteeMembershipModel() when $default != null:
return $default(_that.id,_that.committeeId,_that.personId,_that.title,_that.effectiveFrom,_that.effectiveTo,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommitteeMembershipModel extends CommitteeMembershipModel {
  const _CommitteeMembershipModel({required this.id, required this.committeeId, required this.personId, required this.title, required this.effectiveFrom, required this.effectiveTo, required this.status}): super._();
  factory _CommitteeMembershipModel.fromJson(Map<String, dynamic> json) => _$CommitteeMembershipModelFromJson(json);

@override final  String id;
@override final  String committeeId;
@override final  String personId;
@override final  String title;
@override final  DateTime effectiveFrom;
@override final  DateTime? effectiveTo;
@override final  CommitteeMembershipStatus status;

/// Create a copy of CommitteeMembershipModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommitteeMembershipModelCopyWith<_CommitteeMembershipModel> get copyWith => __$CommitteeMembershipModelCopyWithImpl<_CommitteeMembershipModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommitteeMembershipModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommitteeMembershipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.committeeId, committeeId) || other.committeeId == committeeId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.title, title) || other.title == title)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,committeeId,personId,title,effectiveFrom,effectiveTo,status);

@override
String toString() {
  return 'CommitteeMembershipModel(id: $id, committeeId: $committeeId, personId: $personId, title: $title, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CommitteeMembershipModelCopyWith<$Res> implements $CommitteeMembershipModelCopyWith<$Res> {
  factory _$CommitteeMembershipModelCopyWith(_CommitteeMembershipModel value, $Res Function(_CommitteeMembershipModel) _then) = __$CommitteeMembershipModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String committeeId, String personId, String title, DateTime effectiveFrom, DateTime? effectiveTo, CommitteeMembershipStatus status
});




}
/// @nodoc
class __$CommitteeMembershipModelCopyWithImpl<$Res>
    implements _$CommitteeMembershipModelCopyWith<$Res> {
  __$CommitteeMembershipModelCopyWithImpl(this._self, this._then);

  final _CommitteeMembershipModel _self;
  final $Res Function(_CommitteeMembershipModel) _then;

/// Create a copy of CommitteeMembershipModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? committeeId = null,Object? personId = null,Object? title = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? status = null,}) {
  return _then(_CommitteeMembershipModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,committeeId: null == committeeId ? _self.committeeId : committeeId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommitteeMembershipStatus,
  ));
}


}

// dart format on

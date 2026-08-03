// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoticeModel {

 String get id; String get organizationId; String? get pathshalaId; String get title; String get content; NoticeStatus get status; DateTime? get publishedAt; String get createdByUserId; DateTime get createdAt;
/// Create a copy of NoticeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeModelCopyWith<NoticeModel> get copyWith => _$NoticeModelCopyWithImpl<NoticeModel>(this as NoticeModel, _$identity);

  /// Serializes this NoticeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.status, status) || other.status == status)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,pathshalaId,title,content,status,publishedAt,createdByUserId,createdAt);

@override
String toString() {
  return 'NoticeModel(id: $id, organizationId: $organizationId, pathshalaId: $pathshalaId, title: $title, content: $content, status: $status, publishedAt: $publishedAt, createdByUserId: $createdByUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NoticeModelCopyWith<$Res>  {
  factory $NoticeModelCopyWith(NoticeModel value, $Res Function(NoticeModel) _then) = _$NoticeModelCopyWithImpl;
@useResult
$Res call({
 String id, String organizationId, String? pathshalaId, String title, String content, NoticeStatus status, DateTime? publishedAt, String createdByUserId, DateTime createdAt
});




}
/// @nodoc
class _$NoticeModelCopyWithImpl<$Res>
    implements $NoticeModelCopyWith<$Res> {
  _$NoticeModelCopyWithImpl(this._self, this._then);

  final NoticeModel _self;
  final $Res Function(NoticeModel) _then;

/// Create a copy of NoticeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationId = null,Object? pathshalaId = freezed,Object? title = null,Object? content = null,Object? status = null,Object? publishedAt = freezed,Object? createdByUserId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: freezed == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoticeStatus,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NoticeModel].
extension NoticeModelPatterns on NoticeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeModel value)  $default,){
final _that = this;
switch (_that) {
case _NoticeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeModel value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String organizationId,  String? pathshalaId,  String title,  String content,  NoticeStatus status,  DateTime? publishedAt,  String createdByUserId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.pathshalaId,_that.title,_that.content,_that.status,_that.publishedAt,_that.createdByUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String organizationId,  String? pathshalaId,  String title,  String content,  NoticeStatus status,  DateTime? publishedAt,  String createdByUserId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _NoticeModel():
return $default(_that.id,_that.organizationId,_that.pathshalaId,_that.title,_that.content,_that.status,_that.publishedAt,_that.createdByUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String organizationId,  String? pathshalaId,  String title,  String content,  NoticeStatus status,  DateTime? publishedAt,  String createdByUserId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NoticeModel() when $default != null:
return $default(_that.id,_that.organizationId,_that.pathshalaId,_that.title,_that.content,_that.status,_that.publishedAt,_that.createdByUserId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeModel extends NoticeModel {
  const _NoticeModel({required this.id, required this.organizationId, required this.pathshalaId, required this.title, required this.content, required this.status, required this.publishedAt, required this.createdByUserId, required this.createdAt}): super._();
  factory _NoticeModel.fromJson(Map<String, dynamic> json) => _$NoticeModelFromJson(json);

@override final  String id;
@override final  String organizationId;
@override final  String? pathshalaId;
@override final  String title;
@override final  String content;
@override final  NoticeStatus status;
@override final  DateTime? publishedAt;
@override final  String createdByUserId;
@override final  DateTime createdAt;

/// Create a copy of NoticeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeModelCopyWith<_NoticeModel> get copyWith => __$NoticeModelCopyWithImpl<_NoticeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.pathshalaId, pathshalaId) || other.pathshalaId == pathshalaId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.status, status) || other.status == status)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,pathshalaId,title,content,status,publishedAt,createdByUserId,createdAt);

@override
String toString() {
  return 'NoticeModel(id: $id, organizationId: $organizationId, pathshalaId: $pathshalaId, title: $title, content: $content, status: $status, publishedAt: $publishedAt, createdByUserId: $createdByUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NoticeModelCopyWith<$Res> implements $NoticeModelCopyWith<$Res> {
  factory _$NoticeModelCopyWith(_NoticeModel value, $Res Function(_NoticeModel) _then) = __$NoticeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String organizationId, String? pathshalaId, String title, String content, NoticeStatus status, DateTime? publishedAt, String createdByUserId, DateTime createdAt
});




}
/// @nodoc
class __$NoticeModelCopyWithImpl<$Res>
    implements _$NoticeModelCopyWith<$Res> {
  __$NoticeModelCopyWithImpl(this._self, this._then);

  final _NoticeModel _self;
  final $Res Function(_NoticeModel) _then;

/// Create a copy of NoticeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationId = null,Object? pathshalaId = freezed,Object? title = null,Object? content = null,Object? status = null,Object? publishedAt = freezed,Object? createdByUserId = null,Object? createdAt = null,}) {
  return _then(_NoticeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,pathshalaId: freezed == pathshalaId ? _self.pathshalaId : pathshalaId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoticeStatus,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

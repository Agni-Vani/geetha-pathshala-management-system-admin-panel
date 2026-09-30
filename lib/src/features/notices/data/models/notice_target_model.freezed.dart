// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_target_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoticeTargetModel {

 String get id; String get noticeId; NoticeTargetType get targetType; String? get targetId;
/// Create a copy of NoticeTargetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeTargetModelCopyWith<NoticeTargetModel> get copyWith => _$NoticeTargetModelCopyWithImpl<NoticeTargetModel>(this as NoticeTargetModel, _$identity);

  /// Serializes this NoticeTargetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeTargetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.noticeId, noticeId) || other.noticeId == noticeId)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noticeId,targetType,targetId);

@override
String toString() {
  return 'NoticeTargetModel(id: $id, noticeId: $noticeId, targetType: $targetType, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class $NoticeTargetModelCopyWith<$Res>  {
  factory $NoticeTargetModelCopyWith(NoticeTargetModel value, $Res Function(NoticeTargetModel) _then) = _$NoticeTargetModelCopyWithImpl;
@useResult
$Res call({
 String id, String noticeId, NoticeTargetType targetType, String? targetId
});




}
/// @nodoc
class _$NoticeTargetModelCopyWithImpl<$Res>
    implements $NoticeTargetModelCopyWith<$Res> {
  _$NoticeTargetModelCopyWithImpl(this._self, this._then);

  final NoticeTargetModel _self;
  final $Res Function(NoticeTargetModel) _then;

/// Create a copy of NoticeTargetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? noticeId = null,Object? targetType = null,Object? targetId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as NoticeTargetType,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NoticeTargetModel].
extension NoticeTargetModelPatterns on NoticeTargetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeTargetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeTargetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeTargetModel value)  $default,){
final _that = this;
switch (_that) {
case _NoticeTargetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeTargetModel value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeTargetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String noticeId,  NoticeTargetType targetType,  String? targetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeTargetModel() when $default != null:
return $default(_that.id,_that.noticeId,_that.targetType,_that.targetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String noticeId,  NoticeTargetType targetType,  String? targetId)  $default,) {final _that = this;
switch (_that) {
case _NoticeTargetModel():
return $default(_that.id,_that.noticeId,_that.targetType,_that.targetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String noticeId,  NoticeTargetType targetType,  String? targetId)?  $default,) {final _that = this;
switch (_that) {
case _NoticeTargetModel() when $default != null:
return $default(_that.id,_that.noticeId,_that.targetType,_that.targetId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeTargetModel extends NoticeTargetModel {
  const _NoticeTargetModel({required this.id, required this.noticeId, required this.targetType, required this.targetId}): super._();
  factory _NoticeTargetModel.fromJson(Map<String, dynamic> json) => _$NoticeTargetModelFromJson(json);

@override final  String id;
@override final  String noticeId;
@override final  NoticeTargetType targetType;
@override final  String? targetId;

/// Create a copy of NoticeTargetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeTargetModelCopyWith<_NoticeTargetModel> get copyWith => __$NoticeTargetModelCopyWithImpl<_NoticeTargetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeTargetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeTargetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.noticeId, noticeId) || other.noticeId == noticeId)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noticeId,targetType,targetId);

@override
String toString() {
  return 'NoticeTargetModel(id: $id, noticeId: $noticeId, targetType: $targetType, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class _$NoticeTargetModelCopyWith<$Res> implements $NoticeTargetModelCopyWith<$Res> {
  factory _$NoticeTargetModelCopyWith(_NoticeTargetModel value, $Res Function(_NoticeTargetModel) _then) = __$NoticeTargetModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String noticeId, NoticeTargetType targetType, String? targetId
});




}
/// @nodoc
class __$NoticeTargetModelCopyWithImpl<$Res>
    implements _$NoticeTargetModelCopyWith<$Res> {
  __$NoticeTargetModelCopyWithImpl(this._self, this._then);

  final _NoticeTargetModel _self;
  final $Res Function(_NoticeTargetModel) _then;

/// Create a copy of NoticeTargetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? noticeId = null,Object? targetType = null,Object? targetId = freezed,}) {
  return _then(_NoticeTargetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as NoticeTargetType,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

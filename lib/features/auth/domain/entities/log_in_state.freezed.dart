// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_in_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LogInState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Object? get data => throw _privateConstructorUsedError;

  /// Create a copy of LogInState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogInStateCopyWith<LogInState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogInStateCopyWith<$Res> {
  factory $LogInStateCopyWith(
          LogInState value, $Res Function(LogInState) then) =
      _$LogInStateCopyWithImpl<$Res, LogInState>;
  @useResult
  $Res call({bool isLoading, String? error, Object? data});
}

/// @nodoc
class _$LogInStateCopyWithImpl<$Res, $Val extends LogInState>
    implements $LogInStateCopyWith<$Res> {
  _$LogInStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogInState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data ? _value.data : data,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogInStateImplCopyWith<$Res>
    implements $LogInStateCopyWith<$Res> {
  factory _$$LogInStateImplCopyWith(
          _$LogInStateImpl value, $Res Function(_$LogInStateImpl) then) =
      __$$LogInStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String? error, Object? data});
}

/// @nodoc
class __$$LogInStateImplCopyWithImpl<$Res>
    extends _$LogInStateCopyWithImpl<$Res, _$LogInStateImpl>
    implements _$$LogInStateImplCopyWith<$Res> {
  __$$LogInStateImplCopyWithImpl(
      _$LogInStateImpl _value, $Res Function(_$LogInStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LogInState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? data = freezed,
  }) {
    return _then(_$LogInStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data ? _value.data : data,
    ));
  }
}

/// @nodoc

class _$LogInStateImpl implements _LogInState {
  const _$LogInStateImpl({this.isLoading = false, this.error, this.data});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final Object? data;

  @override
  String toString() {
    return 'LogInState(isLoading: $isLoading, error: $error, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogInStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isLoading, error, const DeepCollectionEquality().hash(data));

  /// Create a copy of LogInState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogInStateImplCopyWith<_$LogInStateImpl> get copyWith =>
      __$$LogInStateImplCopyWithImpl<_$LogInStateImpl>(this, _$identity);
}

abstract class _LogInState implements LogInState {
  const factory _LogInState(
      {final bool isLoading,
      final String? error,
      final Object? data}) = _$LogInStateImpl;

  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  Object? get data;

  /// Create a copy of LogInState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogInStateImplCopyWith<_$LogInStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LikeStateCWProxy {
  LikeState likedIds(Set<int> likedIds);

  LikeState error(AppFailure? error);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LikeState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LikeState(...).copyWith(id: 12, name: "My name")
  /// ```
  LikeState call({Set<int> likedIds, AppFailure? error});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLikeState.copyWith(...)` or call `instanceOfLikeState.copyWith.fieldName(value)` for a single field.
class _$LikeStateCWProxyImpl implements _$LikeStateCWProxy {
  const _$LikeStateCWProxyImpl(this._value);

  final LikeState _value;

  @override
  LikeState likedIds(Set<int> likedIds) => call(likedIds: likedIds);

  @override
  LikeState error(AppFailure? error) => call(error: error);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `LikeState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LikeState(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  LikeState call({
    Object? likedIds = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return LikeState(
      likedIds: likedIds == const $CopyWithPlaceholder() || likedIds == null
          ? _value.likedIds
          // ignore: cast_nullable_to_non_nullable
          : likedIds as Set<int>,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as AppFailure?,
    );
  }
}

extension $LikeStateCopyWith on LikeState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLikeState.copyWith(...)` or `instanceOfLikeState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LikeStateCWProxy get copyWith => _$LikeStateCWProxyImpl(this);
}

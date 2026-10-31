import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test_app/core/models/app_failure.dart';

part 'like_state.g.dart';

@CopyWith()
class LikeState extends Equatable {
  /// Set, а не List, как в лекции: проверка contains — O(1)
  /// и не бывает дубликатов.
  final Set<int> likedIds;

  final AppFailure? error;

  const LikeState({this.likedIds = const {}, this.error});

  bool isLiked(int recipeId) => likedIds.contains(recipeId);

  @override
  List<Object?> get props => [likedIds, error];
}

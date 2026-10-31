import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/models/app_failure.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_likes_repository.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/like_event.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc(this._repository) : super(const LikeState()) {
    on<LikesSubscriptionRequested>(
      _onSubscriptionRequested,
      transformer: restartable(),
    );
    // sequential: быстрые нажатия записываются в БД строго по очереди.
    on<RecipeLikeChanged>(_onLikeChanged, transformer: sequential());
  }

  final RecipeLikesRepository _repository;

  /// emit.forEach держит подписку на поток, пока BLoC не закрыт:
  /// каждое изменение таблицы liked_recipes превращается в новое состояние.
  Future<void> _onSubscriptionRequested(
    LikesSubscriptionRequested event,
    Emitter<LikeState> emit,
  ) {
    return emit.forEach(
      _repository.watchLikedIds(),
      onData: (likedIds) => state.copyWith(likedIds: likedIds, error: null),
      onError: (_, _) => state.copyWith(error: AppFailure.storage),
    );
  }

  Future<void> _onLikeChanged(
    RecipeLikeChanged event,
    Emitter<LikeState> emit,
  ) async {
    final previousIds = state.likedIds;

    // Сразу показываем результат, не дожидаясь записи в БД.
    emit(
      state.copyWith(
        likedIds: event.isLiked
            ? {...previousIds, event.recipeId}
            : ({...previousIds}..remove(event.recipeId)),
        error: null,
      ),
    );

    final result = await _repository.setLiked(
      event.recipeId,
      isLiked: event.isLiked,
    );

    // Не сохранилось — откатываем.
    if (result.isFailure) {
      emit(state.copyWith(likedIds: previousIds, error: result.error));
    }
  }
}

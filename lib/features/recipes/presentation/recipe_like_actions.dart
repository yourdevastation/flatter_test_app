import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/extensions/snack_bar_extension.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/like_bloc.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/like_event.dart';

/// Лайк рецепта со списка и с экрана деталей: событие в LikeBloc
/// и снекбар с «Отменить» (аналог _onLike из лекции).
void setRecipeLiked(
  BuildContext context,
  Recipe recipe, {
  required bool isLiked,
}) {
  final bloc = context.read<LikeBloc>();
  final l10n = context.l10n;

  bloc.add(RecipeLikeChanged(recipe.id, isLiked: isLiked));

  context.showAppSnackBar(
    message: isLiked
        ? l10n.recipeLiked(recipe.name)
        : l10n.recipeUnliked(recipe.name),
    icon: isLiked ? Icons.favorite : Icons.heart_broken_outlined,
    action: SnackBarAction(
      label: l10n.undo,
      onPressed: () =>
          bloc.add(RecipeLikeChanged(recipe.id, isLiked: !isLiked)),
    ),
  );
}

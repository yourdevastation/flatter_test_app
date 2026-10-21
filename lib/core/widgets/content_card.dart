import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/widgets/content_card_data.dart';
import 'package:flutter_test_app/core/widgets/like_icon.dart';
import 'package:flutter_test_app/core/widgets/card_image.dart';

typedef OnLikeCallback = void Function(String id, String title, bool isLiked);

class ContentCard extends StatefulWidget {
  const ContentCard.fromData(
    this.data, {
    super.key,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLike,
  });

  final ContentCardData data;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final OnLikeCallback? onLike;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  static const double _radius = 16;
  static const double _imageHeight = 160;
  static const double _minHeight = 272;
  static const Duration _burstDuration = Duration(milliseconds: 700);

  late bool _isLiked = widget.data.isLiked;
  bool _isPressed = false;
  bool _showLikeBurst = false;

  @override
  void didUpdateWidget(covariant ContentCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Лайк могли поменять снаружи: отменой из снекбара или на экране деталей.
    if (oldWidget.data.isLiked != widget.data.isLiked) {
      _isLiked = widget.data.isLiked;
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    widget.onLike?.call(widget.data.id, widget.data.title, _isLiked);
  }

  Future<void> _likeByDoubleTap() async {
    if (!_isLiked) {
      _toggleLike();
    }

    setState(() {
      _showLikeBurst = true;
    });

    await Future<void>.delayed(_burstDuration);

    if (mounted) {
      setState(() {
        _showLikeBurst = false;
      });
    }
  }

  void _setPressed(bool isPressed) {
    if (_isPressed != isPressed) {
      setState(() {
        _isPressed = isPressed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final data = widget.data;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          // Минимальная высота выравнивает карточки с описанием и без него.
          constraints: const BoxConstraints(minHeight: _minHeight),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // IntrinsicHeight растягивает содержимое на всю высоту карточки,
          // чтобы лайк всегда оказывался в правом нижнем углу.
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImage(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.leading case final leading?)
                          Center(child: leading),
                        Expanded(child: _CardContent(data: data)),
                        _buildActions(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final data = widget.data;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(_radius)),
      child: SizedBox(
        height: _imageHeight,
        child: GestureDetector(
          onDoubleTap: widget.onLike == null ? null : _likeByDoubleTap,
          // Placeholder (если картинка не загрузилась) не ловит касания,
          // поэтому двойной тап принимаем по всей области картинки.
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              CardImage(
                url: data.imageUrl,
                heroTag: cardImageHeroTag(data.id),
                isDimmed: data.isCompleted,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _CategoryBadge(icon: data.icon, label: data.caption),
                ),
              ),
              Align(child: _LikeBurst(isVisible: _showLikeBurst)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ?widget.trailing,
          if (widget.onLike != null)
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: _toggleLike,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: LikeIcon(isLiked: _isLiked),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.icon, this.label});

  final IconData icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final label = this.label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          if (label != null) ...[
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LikeBurst extends StatelessWidget {
  const _LikeBurst({required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedScale(
          scale: isVisible ? 1 : 0.4,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutBack,
          child: const Icon(
            Icons.favorite,
            size: 80,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black38, blurRadius: 16)],
          ),
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.data});

  final ContentCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final description = data.description;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: data.isCompleted ? TextDecoration.lineThrough : null,
              color: data.isCompleted ? colorScheme.outline : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;

class LikeAnimationWidget extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;
  final Color? likedColor;
  final Color? unlikedColor;
  final double size;
  final Duration duration;

  const LikeAnimationWidget({
    super.key,
    required this.isLiked,
    required this.onTap,
    this.likedColor,
    this.unlikedColor,
    this.size = 24.0,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<LikeAnimationWidget> createState() => _LikeAnimationWidgetState();
}

class _LikeAnimationWidgetState extends State<LikeAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.unlikedColor ?? Colors.grey[400],
      end: widget.likedColor ?? const Color(0xFFE91E63),
    ).animate(_controller);

    if (widget.isLiked) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(LikeAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isLiked != widget.isLiked) {
      if (widget.isLiked) {
        _animateLike();
      } else {
        _animateUnlike();
      }
    }
  }

  void _animateLike() {
    _controller.forward();
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
  }

  void _animateUnlike() {
    _controller.reverse();
  }

  void _handleTap() {
    // Quick bounce feedback
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });

    widget.onTap();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _bounceController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value * _bounceAnimation.value,
            child: Icon(
              widget.isLiked ? Icons.favorite : Icons.favorite_border,
              color: _colorAnimation.value,
              size: widget.size,
            ),
          );
        },
      ),
    );
  }
}

class HeartExplosionWidget extends StatefulWidget {
  final bool show;
  final VoidCallback? onAnimationComplete;

  const HeartExplosionWidget({
    super.key,
    required this.show,
    this.onAnimationComplete,
  });

  @override
  State<HeartExplosionWidget> createState() => _HeartExplosionWidgetState();
}

class _HeartExplosionWidgetState extends State<HeartExplosionWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _heartAnimations;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create multiple heart animations for explosion effect
    _heartAnimations = List.generate(6, (index) {
      final angle = (index * 60) * (3.14159 / 180); // Convert to radians
      return Tween<Offset>(
        begin: Offset.zero,
        end: Offset(
          1.5 * math.cos(angle),
          1.5 * math.sin(angle),
        ),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ));
    });

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(HeartExplosionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.show && !oldWidget.show) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 0; i < _heartAnimations.length; i++)
                Transform.translate(
                  offset: _heartAnimations[i].value * 20, // Scale the movement
                  child: Transform.scale(
                    scale: 1.0 - (_controller.value * 0.3),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.pink.withValues(alpha: 0.8),
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class DoubleTapLikeOverlay extends StatefulWidget {
  final Widget child;
  final String photoId;
  final bool isLiked;
  final VoidCallback onDoubleTap;

  const DoubleTapLikeOverlay({
    super.key,
    required this.child,
    required this.photoId,
    required this.isLiked,
    required this.onDoubleTap,
  });

  @override
  State<DoubleTapLikeOverlay> createState() => _DoubleTapLikeOverlayState();
}

class _DoubleTapLikeOverlayState extends State<DoubleTapLikeOverlay>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScaleAnimation;
  late Animation<double> _heartFadeAnimation;

  bool _showHeart = false;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heartScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));

    _heartFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showHeart = false;
        });
        _heartController.reset();
      }
    });
  }

  void _handleDoubleTap() {
    if (!widget.isLiked) {
      setState(() {
        _showHeart = true;
      });
      _heartController.forward();
    }
    widget.onDoubleTap();
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        children: [
          widget.child,
          if (_showHeart)
            Positioned.fill(
              child: Center(
                child: AnimatedBuilder(
                  animation: _heartController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _heartFadeAnimation.value,
                      child: Transform.scale(
                        scale: _heartScaleAnimation.value,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 80,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  final String photoId;
  final bool isLiked;
  final int likesCount;
  final VoidCallback onPressed;
  final double size;
  final TextStyle? textStyle;

  const LikeButton({
    super.key,
    required this.photoId,
    required this.isLiked,
    required this.likesCount,
    required this.onPressed,
    this.size = 24.0,
    this.textStyle,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with TickerProviderStateMixin {
  bool _showExplosion = false;

  void _handleTap() {
    if (!widget.isLiked) {
      setState(() {
        _showExplosion = true;
      });
    }
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LikeAnimationWidget(
              isLiked: widget.isLiked,
              onTap: _handleTap,
              size: widget.size,
              likedColor: const Color(0xFFE91E63),
              unlikedColor: Colors.grey[600],
            ),
            if (widget.likesCount > 0) ...[
              const SizedBox(width: 4),
              Text(
                widget.likesCount.toString(),
                style: widget.textStyle ??
                    TextStyle(
                      color: widget.isLiked ? const Color(0xFFE91E63) : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ],
        ),
        if (_showExplosion)
          Positioned(
            left: -10,
            right: -10,
            top: -10,
            bottom: -10,
            child: HeartExplosionWidget(
              show: _showExplosion,
              onAnimationComplete: () {
                setState(() {
                  _showExplosion = false;
                });
              },
            ),
          ),
      ],
    );
  }
}
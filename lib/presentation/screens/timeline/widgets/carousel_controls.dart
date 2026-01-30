import 'dart:async';
import 'package:flutter/material.dart';

class CarouselControls extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onClose;
  final bool canGoPrevious;
  final bool canGoNext;

  const CarouselControls({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.onClose,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  @override
  State<CarouselControls> createState() => _CarouselControlsState();
}

class _CarouselControlsState extends State<CarouselControls> {
  bool _isVisible = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  void _handleUserInteraction() {
    if (!_isVisible) {
      setState(() {
        _isVisible = true;
      });
    }
    _startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => _handleUserInteraction(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Close button
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: _isVisible ? 50 : 30,
            right: 20,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _handleUserInteraction();
                    widget.onClose();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Previous button
          if (widget.canGoPrevious)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: _isVisible ? 20 : 0,
              top: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _handleUserInteraction();
                        widget.onPrevious();
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Next button
          if (widget.canGoNext)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              right: _isVisible ? 20 : 0,
              top: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _handleUserInteraction();
                        widget.onNext();
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
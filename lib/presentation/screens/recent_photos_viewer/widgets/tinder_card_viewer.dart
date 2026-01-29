import 'package:flutter/material.dart';
import 'dart:math';
import '../recent_photos_viewer_screen.dart';

class TinderCardViewer extends StatefulWidget {
  final List<PhotoItem> photos;
  final int initialIndex;
  final ValueChanged<int> onIndexChanged;

  const TinderCardViewer({
    super.key,
    required this.photos,
    required this.initialIndex,
    required this.onIndexChanged,
  });

  @override
  State<TinderCardViewer> createState() => _TinderCardViewerState();
}

class _TinderCardViewerState extends State<TinderCardViewer>
    with TickerProviderStateMixin {
  late int _currentIndex;
  int? _swipingIndex; // Track card đang bay đi
  Offset _cardOffset = Offset.zero;
  double _rotationAngle = 0.0;
  bool _isDragging = false;
  late AnimationController _animationController;
  late AnimationController _scaleAnimationController;
  double _nextCardScale = 0.9;
  double _nextCardOpacity = 0.5;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _cardOffset += details.delta;
      // Tính góc nghiêng dựa trên khoảng cách kéo (max 15 degrees)
      _rotationAngle = _cardOffset.dx / 1000;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3;

    if (_cardOffset.dx.abs() > threshold) {
      // Swipe đủ xa, bay card ra ngoài
      _swipeCard(_cardOffset.dx > 0 ? 1 : -1);
    } else {
      // Không đủ xa, reset về vị trí ban đầu
      _resetCard();
    }
  }

  void _swipeCard(int direction) {
    setState(() {
      _swipingIndex = _currentIndex;
      _isDragging = false; // Tắt dragging state
    });

    // Reset controller nếu đang chạy
    if (_animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final endOffset = Offset(screenWidth * 2.0 * direction, _cardOffset.dy);

    final animation = Tween<Offset>(begin: _cardOffset, end: endOffset).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    void listener() {
      if (mounted) {
        setState(() {
          _cardOffset = animation.value;
        });
      }
    }

    animation.addListener(listener);

    _animationController.forward().then((_) {
      animation.removeListener(listener);

      if (mounted) {
        setState(() {
          // Chuyển sang ảnh tiếp theo hoặc quay lại
          // Swipe Left (direction < 0) = Next photo
          // Swipe Right (direction > 0) = Previous photo
          if (direction < 0 && _currentIndex < widget.photos.length - 1) {
            _currentIndex++;
          } else if (direction > 0 && _currentIndex > 0) {
            _currentIndex--;
          }

          widget.onIndexChanged(_currentIndex);

          // Reset card
          _cardOffset = Offset.zero;
          _rotationAngle = 0.0;
          _swipingIndex = null;
          _animationController.reset();

          // Animate preview card scale up
          _nextCardScale = 0.9;
          _nextCardOpacity = 0.5;
        });

        // Animate scale và opacity lên mượt mà từ từ
        final scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(
            parent: _scaleAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

        final opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(
            parent: _scaleAnimationController,
            curve: Curves.easeOut,
          ),
        );

        void scaleListener() {
          if (mounted) {
            setState(() {
              _nextCardScale = scaleAnimation.value;
              _nextCardOpacity = opacityAnimation.value;
            });
          }
        }

        scaleAnimation.addListener(scaleListener);
        _scaleAnimationController.reset();
        _scaleAnimationController.forward().then((_) {
          scaleAnimation.removeListener(scaleListener);
          if (mounted) {
            setState(() {
              _nextCardScale = 1.0;
              _nextCardOpacity = 1.0;
              _scaleAnimationController.reset();
            });
          }
        });
      }
    });
  }

  void _resetCard() {
    // Reset controller nếu đang chạy
    if (_animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }

    final animation = Tween<Offset>(begin: _cardOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    final rotationAnimation = Tween<double>(begin: _rotationAngle, end: 0.0)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    void listener() {
      if (mounted) {
        setState(() {
          _cardOffset = animation.value;
          _rotationAngle = rotationAnimation.value;
        });
      }
    }

    animation.addListener(listener);

    _animationController.forward().then((_) {
      animation.removeListener(listener);

      if (mounted) {
        setState(() {
          _cardOffset = Offset.zero;
          _rotationAngle = 0.0;
          _isDragging = false;
          _animationController.reset();
        });
      }
    });
  }

  Widget _buildCard(PhotoItem photo, {bool isTop = true}) {
    return Transform.translate(
      offset: isTop ? _cardOffset : Offset.zero,
      child: Transform.rotate(
        angle: isTop ? _rotationAngle : 0.0,
        child: Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24.0, top: 55.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              photo.imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 64,
                        color: Colors.white38,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Failed to load image',
                        style: TextStyle(
                          fontFamily: 'Inika',
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.photos.length) {
      return const Center(
        child: Text(
          'No more photos',
          style: TextStyle(color: Colors.white, fontFamily: 'Inika'),
        ),
      );
    }

    // Tính toán preview card index dựa trên state
    int? previewIndex;
    if (_swipingIndex != null) {
      // Đang swipe: preview là card tiếp theo sẽ xuất hiện
      if (_cardOffset.dx < 0 && _currentIndex < widget.photos.length - 1) {
        previewIndex = _currentIndex + 1;
      } else if (_cardOffset.dx > 0 && _currentIndex > 0) {
        previewIndex = _currentIndex - 1;
      }
    } else {
      // Không swipe
      if (_isDragging) {
        // Đang kéo: hiện preview theo hướng kéo
        if (_cardOffset.dx <= 0 && _currentIndex < widget.photos.length - 1) {
          previewIndex = _currentIndex + 1;
        } else if (_cardOffset.dx > 0 && _currentIndex > 0) {
          previewIndex = _currentIndex - 1;
        }
      } else {
        // Idle: mặc định hiện card tiếp theo
        if (_currentIndex < widget.photos.length - 1) {
          previewIndex = _currentIndex + 1;
        }
      }
    }

    // Index của top card (card đang tương tác)
    final topCardIndex = _swipingIndex ?? _currentIndex;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Preview card phía sau - LUÔN render nếu có previewIndex
        if (previewIndex != null)
          Opacity(
            opacity: _isDragging || _swipingIndex != null
                ? 0.5
                : _nextCardOpacity,
            child: Transform.scale(
              scale: _isDragging || _swipingIndex != null
                  ? 0.9
                  : _nextCardScale,
              child: _buildCard(widget.photos[previewIndex], isTop: false),
            ),
          ),

        // Top card (current hoặc swiping)
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: _buildCard(widget.photos[topCardIndex]),
        ),

        // Swipe indicators
        if (_isDragging)
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  // Left swipe indicator
                  if (_cardOffset.dx < -50)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Opacity(
                          opacity: min(1.0, -_cardOffset.dx / 200),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 200),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Right swipe indicator
                  if (_cardOffset.dx > 50)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Opacity(
                          opacity: min(1.0, _cardOffset.dx / 200),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 200),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

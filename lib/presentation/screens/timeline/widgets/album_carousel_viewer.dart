import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class AlbumCarouselViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final VoidCallback onClose;

  const AlbumCarouselViewer({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.onClose,
  });

  @override
  State<AlbumCarouselViewer> createState() => _AlbumCarouselViewerState();
}

class _AlbumCarouselViewerState extends State<AlbumCarouselViewer>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _fadeController.forward();
    _startHideTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _onUserTap() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  void _handleClose() {
    _fadeController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleClose();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Blurred background
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  key: ValueKey(widget.images[_currentIndex]),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.images[_currentIndex],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.black);
                        },
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(color: Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
              ),

              // Main content with gesture detector
              GestureDetector(
                onTap: _onUserTap,
                child: Stack(
                  children: [
                    // Photo Gallery with PageView
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 80,
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: widget.images.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Center(
                              child: InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    widget.images[index],
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                                strokeWidth: 3,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Đang tải...',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.white54,
                                            size: 64,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Top gradient overlay
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Back button
                    Positioned(
                      top: 40,
                      left: 16,
                      child: SafeArea(
                        child: AnimatedOpacity(
                          opacity: _showControls ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _handleClose,
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Page counter
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${_currentIndex + 1} / ${widget.images.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Dots indicator
                    if (widget.images.length > 1)
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: _showControls ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                widget.images.length > 10
                                    ? 10
                                    : widget.images.length,
                                (index) {
                                  if (widget.images.length > 10 && index == 9) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: Text(
                                        '...',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }

                                  bool isActive = index == _currentIndex;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    width: isActive ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

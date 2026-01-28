import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'story_stack_card.dart';
import 'story_progress_bar.dart';

class StoryCarousel extends StatefulWidget {
  final List<String> images;
  final VoidCallback onClose;
  final String userName;

  const StoryCarousel({
    super.key,
    required this.images,
    required this.onClose,
    required this.userName,
  });

  @override
  State<StoryCarousel> createState() => _StoryCarouselState();
}

class _StoryCarouselState extends State<StoryCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToPreviousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextImage() {
    if (_currentIndex < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SafeArea(
          child: Column(
            children: [
              StoryProgressBar(
                currentIndex: _currentIndex,
                totalCount: widget.images.length,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Stack(
              children: [
                SizedBox(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.6,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                          }

                          final isCurrentPage = index == _currentIndex;
                          final scale = math.max(0.85, 1 - value.abs() * 0.15);

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              if (index < widget.images.length - 1 &&
                                  value > -0.5)
                                Positioned(
                                  right: -50,
                                  child: Transform.scale(
                                    scale: 0.85,
                                    child: SizedBox(
                                      width: screenWidth * 0.7,
                                      height: screenHeight * 0.6,
                                      child: StoryStackCard(
                                        imageUrl: widget.images[index + 1],
                                        isMain: false,
                                        rotation: 0,
                                        scale: 0.85,
                                        placeholderText:
                                            'Ảnh ${index + 2}\n${widget.userName}',
                                      ),
                                    ),
                                  ),
                                ),
                              if (index > 0 && value < 0.5)
                                Positioned(
                                  left: -50,
                                  child: Transform.scale(
                                    scale: 0.85,
                                    child: SizedBox(
                                      width: screenWidth * 0.7,
                                      height: screenHeight * 0.6,
                                      child: StoryStackCard(
                                        imageUrl: widget.images[index - 1],
                                        isMain: false,
                                        rotation: 0,
                                        scale: 0.85,
                                        placeholderText:
                                            'Ảnh $index\n${widget.userName}',
                                      ),
                                    ),
                                  ),
                                ),
                              Transform.scale(
                                scale: scale,
                                child: StoryStackCard(
                                  imageUrl: widget.images[index],
                                  isMain: isCurrentPage,
                                  rotation: 0,
                                  scale: scale,
                                  placeholderText:
                                      'Ảnh ${index + 1}\n${widget.userName}',
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                if (_currentIndex > 0)
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _goToPreviousImage,
                      child: Container(
                        width: 50,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_currentIndex < widget.images.length - 1)
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _goToNextImage,
                      child: Container(
                        width: 50,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 30,
                            ),
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

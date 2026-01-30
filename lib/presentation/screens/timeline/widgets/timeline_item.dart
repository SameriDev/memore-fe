import 'package:flutter/material.dart';
import '../models/timeline_models.dart';
import '../config/timeline_config.dart';

class TimelineItem extends StatelessWidget {
  final TimelineAlignment alignment;
  final List<String> images;
  final String title;
  final String subtitle;
  final String time;
  final String day;
  final String month;
  final ResponsiveConfig config;
  final VoidCallback? onAlbumTap;

  const TimelineItem({
    super.key,
    required this.alignment,
    required this.images,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.day,
    required this.month,
    required this.config,
    this.onAlbumTap,
  });

  @override
  Widget build(BuildContext context) {
    if (config.useVerticalLayout) {
      return _buildVerticalLayout();
    }

    final isLeft = alignment == TimelineAlignment.left;
    return _buildHorizontalLayout(isLeft);
  }

  Widget _buildVerticalLayout() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: config.itemMargin),
      child: Column(
        children: [
          Container(
            width: config.circleSize,
            height: config.circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFF8C42).withOpacity(0.5),
                  const Color(0xFFFFB380).withOpacity(0.35),
                  const Color(0xFFFFB380).withOpacity(0.2),
                  const Color(0xFFFFB380).withOpacity(0.1),
                  const Color(0xFFFFB380).withOpacity(0.0),
                ],
                stops: const [0.0, 0.2, 0.4, 0.7, 1.0],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: config.circleDaySize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Inika',
                    ),
                  ),
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: config.circleMonthSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Inika',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildImageCluster(),
          const SizedBox(height: 16),
          Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: config.titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '"$subtitle"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: config.subtitleSize,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: config.timeSize,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout(bool isLeft) {
    return Container(
      margin: EdgeInsets.only(
        left: isLeft ? 0 : config.itemMargin,
        right: isLeft ? config.itemMargin : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [if (isLeft) ...buildLeftLayout() else ...buildRightLayout()],
      ),
    );
  }

  List<Widget> buildLeftLayout() {
    return [
      SizedBox(
        width: config.circleSize,
        height: config.itemHeight,
        child: Align(alignment: Alignment.topCenter, child: _buildCircle()),
      ),
      Expanded(flex: config.imageFlex, child: _buildImageCluster()),
      const SizedBox(width: 20),
      Expanded(
        flex: config.textFlex,
        child: SizedBox(
          height: config.itemHeight,
          child: Center(child: _buildTextInfo()),
        ),
      ),
    ];
  }

  List<Widget> buildRightLayout() {
    return [
      Expanded(
        flex: config.textFlex,
        child: SizedBox(
          height: config.itemHeight,
          child: Center(child: _buildTextInfo()),
        ),
      ),
      const SizedBox(width: 20),
      Expanded(flex: config.imageFlex, child: _buildImageCluster()),
      SizedBox(
        width: config.circleSize,
        height: config.itemHeight,
        child: Align(alignment: Alignment.topCenter, child: _buildCircle()),
      ),
    ];
  }

  Widget _buildCircle() {
    return Container(
      width: config.circleSize,
      height: config.circleSize,
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFFF8C42).withOpacity(0.5),
            const Color(0xFFFFB380).withOpacity(0.35),
            const Color(0xFFFFB380).withOpacity(0.2),
            const Color(0xFFFFB380).withOpacity(0.1),
            const Color(0xFFFFB380).withOpacity(0.0),
          ],
          stops: const [0.0, 0.2, 0.4, 0.7, 1.0],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: config.circleDaySize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Inika',
              ),
            ),
            Text(
              month,
              style: TextStyle(
                fontSize: config.circleMonthSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'Inika',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: config.titleSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '"$subtitle"',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: config.subtitleSize,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: config.timeSize,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _wrapWithGestureDetector(Widget child) {
    if (onAlbumTap == null) return child;

    return GestureDetector(onTap: onAlbumTap, child: child);
  }

  Widget _buildImageCluster() {
    if (images.isEmpty) {
      return Container(
        height: config.itemHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
      );
    }

    if (images.length == 1) {
      return _wrapWithGestureDetector(
        Container(
          height: config.itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              images[0],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    if (images.length == 2) {
      return _wrapWithGestureDetector(
        Container(
          height: config.itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Expanded(
                  child: Image.network(
                    images[0],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 30),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Image.network(
                    images[1],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 30),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (images.length == 3) {
      return _wrapWithGestureDetector(
        Container(
          height: config.itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(
                    images[0],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 30),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          images[1],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        child: Image.network(
                          images[2],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 20,
                                ),
                              ),
                            );
                          },
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

    return _wrapWithGestureDetector(
      Container(
        height: config.itemHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        images[0],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 20),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Image.network(
                        images[1],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 20),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        images[2],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 20),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            images[3],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                          if (images.length > 4)
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Center(
                                child: Text(
                                  '+${images.length - 4}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }
}

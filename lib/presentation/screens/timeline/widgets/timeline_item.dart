import 'package:flutter/material.dart';
import '../models/timeline_models.dart';
import '../config/timeline_config.dart';
import 'dart:io';

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
  final VoidCallback? onEditNote;

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
    this.onEditNote,
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
          _buildEditButton(),
          const SizedBox(height: 8),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [if (isLeft) ...buildLeftLayout() else ...buildRightLayout()],
      ),
    );
  }

  List<Widget> buildLeftLayout() {
    // Date on LEFT → text aligns RIGHT
    return [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCircle(),
          _buildEditButton(),
        ],
      ),
      const SizedBox(width: 8),
      Expanded(flex: config.imageFlex, child: _buildImageCluster()),
      const SizedBox(width: 12),
      Expanded(
        flex: config.textFlex,
        child: _buildTextInfo(CrossAxisAlignment.end, TextAlign.right),
      ),
    ];
  }

  List<Widget> buildRightLayout() {
    // Date on RIGHT → text aligns LEFT
    return [
      Expanded(
        flex: config.textFlex,
        child: _buildTextInfo(CrossAxisAlignment.start, TextAlign.left),
      ),
      const SizedBox(width: 12),
      Expanded(flex: config.imageFlex, child: _buildImageCluster()),
      const SizedBox(width: 8),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCircle(),
          _buildEditButton(),
        ],
      ),
    ];
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: onEditNote,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.edit,
            size: 20,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
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

  Widget _buildTextInfo([
    CrossAxisAlignment crossAlign = CrossAxisAlignment.center,
    TextAlign textAlign = TextAlign.center,
  ]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAlign,
      children: [
        Text(
          title,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: config.titleSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '"$subtitle"',
          textAlign: textAlign,
          style: TextStyle(
            fontSize: config.subtitleSize,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          textAlign: textAlign,
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

  Widget _buildImage(String imageUrl, {BoxFit fit = BoxFit.cover, double? width, double? height}) {
    Widget errorWidget = Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 30),
      ),
    );

    if (imageUrl.startsWith('file://')) {
      // Local file
      final filePath = imageUrl.substring(7); // Remove 'file://' prefix
      return Image.file(
        File(filePath),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    } else {
      // Network image
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    }
  }

  Widget _buildImageCluster() {
    if (images.isEmpty) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
        ),
      );
    }

    if (images.length == 1) {
      return _wrapWithGestureDetector(
        AspectRatio(
          aspectRatio: 1,
          child: Container(
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
              child: _buildImage(images[0], fit: BoxFit.cover),
            ),
          ),
        ),
      );
    }

    if (images.length == 2) {
      return _wrapWithGestureDetector(
        AspectRatio(
          aspectRatio: 1,
          child: Container(
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
                    child: _buildImage(images[0], fit: BoxFit.cover, height: double.infinity),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: _buildImage(images[1], fit: BoxFit.cover, height: double.infinity),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (images.length == 3) {
      return _wrapWithGestureDetector(
        AspectRatio(
          aspectRatio: 1,
          child: Container(
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
                    child: _buildImage(images[0], fit: BoxFit.cover, height: double.infinity),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildImage(images[1], fit: BoxFit.cover, width: double.infinity),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: _buildImage(images[2], fit: BoxFit.cover, width: double.infinity),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return _wrapWithGestureDetector(
      AspectRatio(
        aspectRatio: 1,
        child: Container(
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
                        child: _buildImage(images[0], fit: BoxFit.cover, width: double.infinity),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        child: _buildImage(images[1], fit: BoxFit.cover, width: double.infinity),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildImage(images[2], fit: BoxFit.cover, width: double.infinity),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildImage(images[3], fit: BoxFit.cover),
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
      ),
    );
  }
}

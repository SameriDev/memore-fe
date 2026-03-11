import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Universal Avatar Widget để handle tất cả cases hiển thị avatar
/// - Hỗ trợ local files và network URLs
/// - Online status indicator
/// - Customizable styling
/// - Graceful error handling
class UniversalAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;
  final Color? borderColor;
  final double borderWidth;
  final bool showOnlineStatus;
  final bool isOnline;
  final Color onlineIndicatorColor;
  final String? fallbackText;
  final IconData fallbackIcon;
  final Color fallbackBackgroundColor;
  final VoidCallback? onTap;

  const UniversalAvatar({
    super.key,
    this.avatarUrl,
    this.radius = 25.0,
    this.borderColor,
    this.borderWidth = 0.0,
    this.showOnlineStatus = false,
    this.isOnline = false,
    this.onlineIndicatorColor = Colors.green,
    this.fallbackText,
    this.fallbackIcon = Icons.person,
    this.fallbackBackgroundColor = const Color(0xFFE0E0E0),
    this.onTap,
  });

  /// Factory constructor cho avatar nhỏ (friend list items, etc)
  factory UniversalAvatar.small({
    String? avatarUrl,
    bool showOnlineStatus = false,
    bool isOnline = false,
    Color? borderColor,
    String? fallbackText,
    VoidCallback? onTap,
  }) {
    return UniversalAvatar(
      avatarUrl: avatarUrl,
      radius: 20.0,
      borderColor: borderColor,
      borderWidth: borderColor != null ? 2.0 : 0.0,
      showOnlineStatus: showOnlineStatus,
      isOnline: isOnline,
      fallbackText: fallbackText,
      onTap: onTap,
    );
  }

  /// Factory constructor cho avatar trung (story, timeline header)
  factory UniversalAvatar.medium({
    String? avatarUrl,
    bool showOnlineStatus = false,
    bool isOnline = false,
    Color? borderColor,
    String? fallbackText,
    VoidCallback? onTap,
  }) {
    return UniversalAvatar(
      avatarUrl: avatarUrl,
      radius: 30.0,
      borderColor: borderColor,
      borderWidth: borderColor != null ? 3.0 : 0.0,
      showOnlineStatus: showOnlineStatus,
      isOnline: isOnline,
      fallbackText: fallbackText,
      onTap: onTap,
    );
  }

  /// Factory constructor cho avatar lớn (profile header)
  factory UniversalAvatar.large({
    String? avatarUrl,
    Color? borderColor,
    String? fallbackText,
    VoidCallback? onTap,
  }) {
    return UniversalAvatar(
      avatarUrl: avatarUrl,
      radius: 60.0,
      borderColor: borderColor ?? const Color(0xFFFCBA03),
      borderWidth: 6.0,
      fallbackText: fallbackText,
      onTap: onTap,
    );
  }

  bool _isLocalPath(String? path) {
    if (path == null || path.isEmpty) return false;
    return path.startsWith('/') ||
           path.startsWith('file:') ||
           path.contains('\\') || // Windows paths
           File(path).existsSync();
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') ||
           url.startsWith('https://') ||
           url.startsWith('www.');
  }

  Widget _buildFallbackAvatar() {
    if (fallbackText != null && fallbackText!.isNotEmpty) {
      // Hiển thị chữ cái đầu
      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: fallbackBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            fallbackText!.substring(0, 1).toUpperCase(),
            style: TextStyle(
              fontSize: radius * 0.6,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Hiển thị icon mặc định
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: fallbackBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        fallbackIcon,
        size: radius * 0.8,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildAvatarImage() {
    // No avatar URL provided
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return _buildFallbackAvatar();
    }

    // Local file
    if (_isLocalPath(avatarUrl)) {
      return ClipOval(
        child: Image.file(
          File(avatarUrl!),
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(),
        ),
      );
    }

    // Network URL
    if (_isValidUrl(avatarUrl)) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              color: fallbackBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => _buildFallbackAvatar(),
        ),
      );
    }

    // Invalid URL format
    return _buildFallbackAvatar();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: borderWidth > 0 && borderColor != null
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor!, width: borderWidth),
            )
          : null,
      child: borderWidth > 0
          ? Padding(
              padding: EdgeInsets.all(borderWidth),
              child: _buildAvatarImage(),
            )
          : _buildAvatarImage(),
    );

    // Add online status indicator
    if (showOnlineStatus) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: radius * 0.3,
              height: radius * 0.3,
              decoration: BoxDecoration(
                color: isOnline ? onlineIndicatorColor : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
        ],
      );
    }

    // Add tap handler if provided
    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIntegrationSection extends StatelessWidget {
  final VoidCallback? onMessengerTap;
  final VoidCallback? onInstagramTap;
  final VoidCallback? onFacebookTap;
  final VoidCallback? onLinkTap;

  const SocialIntegrationSection({
    super.key,
    this.onMessengerTap,
    this.onInstagramTap,
    this.onFacebookTap,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Text - Outside container
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ri_search-ai-line.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Find friend from other way',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Inika',
                ),
              ),
            ],
          ),
        ),

        // Icons Container - Floating Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.08),
            //     blurRadius: 16,
            //     offset: const Offset(0, 4),
            //   ),
            // ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Messenger
              _SocialIconButton(
                onTap: onMessengerTap,
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B2FF), Color(0xFF006AFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                child: Image.asset(
                  'assets/icons/messenger.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              // Instagram
              _SocialIconButton(
                onTap: onInstagramTap,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFCAF45),
                    Color(0xFFE1306C),
                    Color(0xFFC13584),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                child: SvgPicture.asset(
                  'assets/icons/memore_instagram.svg',
                  width: 50,
                  height: 50,
                ),
              ),
              // Facebook
              _SocialIconButton(
                onTap: onFacebookTap,
                borderColor: const Color(0xFF1877F2),
                child: Image.asset(
                  'assets/icons/facebook.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              // Link/Chain
              _SocialIconButton(
                onTap: onLinkTap,
                borderColor: Colors.black, // Or Color(0xFF1E1E1E)
                child: Image.asset(
                  'assets/icons/link.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Gradient? gradient;
  final Color? borderColor;

  const _SocialIconButton({
    this.onTap,
    required this.child,
    this.gradient,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
          color: gradient == null
              ? (borderColor ?? const Color(0xFFE0E0E0))
              : null,
        ),
        // This Padding simulates the border width
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          // This padding simulates the whitespace between border and icon
          padding: const EdgeInsets.all(3),
          child: Center(child: child),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareLinkSection extends StatelessWidget {
  final String memoreLink;
  final VoidCallback? onCopyTap;

  const ShareLinkSection({super.key, required this.memoreLink, this.onCopyTap});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: memoreLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
    onCopyTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Transform.rotate(
                angle: -0.785, // -45 degrees
                child: const Icon(Icons.link, size: 26, color: Colors.black),
              ),
              const SizedBox(width: 8),
              const Text(
                'Share your Memore link',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Link Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F2F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    memoreLink,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 12),
                // Copy Button
                GestureDetector(
                  onTap: () => _copyToClipboard(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.content_copy,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

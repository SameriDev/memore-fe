import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final bool isFlashOn;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapture;
  final VoidCallback onFlipCamera;

  const CameraControls({
    super.key,
    required this.isFlashOn,
    required this.onFlashToggle,
    required this.onCapture,
    required this.onFlipCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Flash toggle button
          _ControlButton(
            icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
            onTap: onFlashToggle,
          ),

          // Capture/Confirm button
          Hero(
            tag: 'camera_button',
            child: GestureDetector(
              onTap: onCapture,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFA500),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
            ),
          ),

          // Flip camera button
          _ControlButton(icon: Icons.flip_camera_ios, onTap: onFlipCamera),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        child: Icon(icon, color: Colors.black, size: 28),
      ),
    );
  }
}

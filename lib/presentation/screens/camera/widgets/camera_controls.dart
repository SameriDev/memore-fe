import 'package:flutter/material.dart';
import '../models/camera_state.dart';

class CameraControls extends StatelessWidget {
  final bool isFlashOn;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapture;
  final VoidCallback? onFlipCamera;
  final CameraMode mode;
  final bool isProcessing;

  const CameraControls({
    super.key,
    required this.isFlashOn,
    required this.onFlashToggle,
    required this.onCapture,
    required this.onFlipCamera,
    required this.mode,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left button: flash
          _ControlButton(
            icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
            onTap: onFlashToggle,
          ),

          // Capture button
          Hero(
            tag: 'camera_button',
            child: GestureDetector(
              onTap: isProcessing ? null : onCapture,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isProcessing
                    ? const Color(0xFFFFA500).withValues(alpha: 0.5)
                    : const Color(0xFFFFA500),
                ),
                child: isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        mode == CameraMode.capture
                            ? Icons.radio_button_unchecked
                            : Icons.check,
                        key: ValueKey('$mode'),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
              ),
            ),
          ),

          // Right button: flip camera or cancel
          _ControlButton(
            icon: mode == CameraMode.capture
              ? Icons.flip_camera_ios
              : Icons.close,
            onTap: isProcessing ? () {} : (onFlipCamera ?? () {}),
            isDisabled: isProcessing || onFlipCamera == null,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDisabled;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: SizedBox(
        width: 48,
        height: 48,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            icon,
            key: ValueKey(icon),
            color: isDisabled ? Colors.black.withValues(alpha: 0.5) : Colors.black,
            size: 28,
          ),
        ),
      ),
    );
  }
}

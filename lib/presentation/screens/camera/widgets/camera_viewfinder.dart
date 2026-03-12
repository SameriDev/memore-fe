import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraViewfinder extends StatelessWidget {
  final CameraController? controller;
  final String? capturedImagePath;

  const CameraViewfinder({
    super.key,
    this.controller,
    this.capturedImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    // Show captured image if available
    if (capturedImagePath != null) {
      return SizedBox(
        key: ValueKey('captured_image_$capturedImagePath'),
        width: double.infinity,
        height: double.infinity,
        child: Image.file(
          File(capturedImagePath!),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.grey,
                  size: 48,
                ),
              ),
            );
          },
        ),
      );
    }

    // Show camera preview if controller is initialized
    if (controller != null && controller!.value.isInitialized) {
      return SizedBox(
        key: const ValueKey('camera_preview'),
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller!.value.previewSize!.height,
            height: controller!.value.previewSize!.width,
            child: CameraPreview(controller!),
          ),
        ),
      );
    }

    // Show loading indicator
    return SizedBox(
      key: const ValueKey('loading'),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

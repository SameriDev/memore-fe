import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:figma_squircle/figma_squircle.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    // Tính toán kích thước dựa trên tỷ lệ 351:371 từ Figma (gần vuông)
    final viewfinderWidth = screenWidth * 0.9;
    final viewfinderHeight = viewfinderWidth * (371 / 351);

    return ClipSmoothRect(
      radius: SmoothBorderRadius(cornerRadius: 125, cornerSmoothing: 1),
      child: Container(
        width: viewfinderWidth,
        height: viewfinderHeight,
        color: Colors.grey[300],
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _buildContent(),
        ),
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

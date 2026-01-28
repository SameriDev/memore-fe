import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraViewfinder extends StatelessWidget {
  final CameraController? controller;
  final String? capturedImagePath;

  const CameraViewfinder({super.key, this.controller, this.capturedImagePath});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.85,
      height: screenHeight * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.grey[300],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    // Show captured image if available
    if (capturedImagePath != null) {
      return Image.network(capturedImagePath!, fit: BoxFit.cover);
    }

    // Show camera preview if controller is initialized
    if (controller != null && controller!.value.isInitialized) {
      return CameraPreview(controller!);
    }

    // Show loading indicator
    return const Center(child: CircularProgressIndicator());
  }
}

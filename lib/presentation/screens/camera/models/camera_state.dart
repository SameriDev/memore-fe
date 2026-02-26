enum CameraMode {
  capture,  // Ready to capture photo
  preview,  // Photo captured, showing preview
  panorama, // Panorama capture mode
}

class CameraState {
  final CameraMode mode;
  final String? capturedImagePath;
  final bool isProcessing;

  const CameraState({
    required this.mode,
    this.capturedImagePath,
    this.isProcessing = false,
  });

  CameraState copyWith({
    CameraMode? mode,
    String? capturedImagePath,
    bool? isProcessing,
  }) {
    return CameraState(
      mode: mode ?? this.mode,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CameraState &&
        other.mode == mode &&
        other.capturedImagePath == capturedImagePath &&
        other.isProcessing == isProcessing;
  }

  @override
  int get hashCode => mode.hashCode ^ capturedImagePath.hashCode ^ isProcessing.hashCode;

  @override
  String toString() => 'CameraState(mode: $mode, capturedImagePath: $capturedImagePath, isProcessing: $isProcessing)';
}

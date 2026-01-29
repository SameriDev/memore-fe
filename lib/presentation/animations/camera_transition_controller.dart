import 'package:flutter/material.dart';

class CameraTransitionController extends ChangeNotifier {
  late AnimationController _navIconsController;
  late AnimationController _mainController;

  late Animation<double> navIconsAnimation;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  void initialize(TickerProvider vsync) {
    if (_isInitialized) return;

    _navIconsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    navIconsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _navIconsController, curve: Curves.easeInOut),
    );

    _isInitialized = true;
  }

  Future<void> startCameraTransition() async {
    if (!_isInitialized) return;

    // Phase 1: Hide nav icons (200ms)
    await _navIconsController.forward();

    // Phase 2 & 3 handled by Hero animation and PageRoute
  }

  Future<void> reverseCameraTransition() async {
    if (!_isInitialized) return;

    // Reverse: Show nav icons back
    await _navIconsController.reverse();
  }

  void reset() {
    if (!_isInitialized) return;
    _navIconsController.reset();
    _mainController.reset();
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _navIconsController.dispose();
      _mainController.dispose();
    }
    super.dispose();
  }
}

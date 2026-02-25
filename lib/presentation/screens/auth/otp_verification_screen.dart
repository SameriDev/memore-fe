import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/utils/snackbar_helper.dart';
import 'package:memore/core/utils/show_app_popup.dart';
import '../../widgets/app_popup.dart';
import '../../widgets/decorated_background.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, this.email = ''});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false;
  bool _canResend = false;
  Timer? _resendTimer;
  int _countdown = 60;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    // Initialize shake animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Auto focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _countdown = 60;
    _canResend = false;
    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String _getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  bool _isOtpComplete() {
    return _getOtp().length == 4;
  }

  Future<void> _showErrorDialog() async {
    return showAppPopup(
      context: context,
      builder: (ctx) => AppPopup(
        size: AppPopupSize.small,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Color(0xFFD32F2F),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'OTP không đúng',
              style: GoogleFonts.inika(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mã OTP bạn nhập không đúng.\nVui lòng thử lại.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inika(
                fontSize: 14,
                color: const Color(0xFF6D4C41),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Thử lại',
                  style: GoogleFonts.inika(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playShakeAnimation() async {
    await _shakeController.forward();
    await _shakeController.reverse();
  }

  Future<void> _handleVerify() async {
    if (!_isOtpComplete()) return;

    final otp = _getOtp();
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (otp == "1234") {
      // Success - navigate to main/my albums
      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
    } else {
      // Error - shake animation and show dialog
      await _playShakeAnimation();
      await _showErrorDialog();

      // Clear OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  void _handleResend() {
    if (!_canResend) return;

    // TODO: Implement resend OTP logic
    SnackBarHelper.showInfo(context, 'Mã OTP đã được gửi lại');
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Logo
                  Center(
                    child: Container(
                      width: 120,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B4513).withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/icons/memore_logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.verified,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  Text(
                    'Xác thực tài khoản',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inika(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'Nhập mã OTP đã được gửi đến',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inika(
                      fontSize: 16,
                      color: const Color(0xFF6D4C41),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email/Phone display
                  if (widget.email.isNotEmpty)
                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inika(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                  const SizedBox(height: 48),
                  // OTP Input Fields with Shake Animation
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _shakeAnimation.value *
                              ((_shakeController.value * 4).floor() % 2 == 0
                                  ? 1
                                  : -1),
                          0,
                        ),
                        child: child,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: index == 0 || index == 3 ? 0 : 8,
                          ),
                          child: _OtpInputField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            previousFocusNode: index > 0
                                ? _focusNodes[index - 1]
                                : null,
                            nextFocusNode: index < 3
                                ? _focusNodes[index + 1]
                                : null,
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                _focusNodes[index + 1].requestFocus();
                              }
                              setState(() {});
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Verify Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isOtpComplete() && !_isLoading
                          ? _handleVerify
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(
                          0xFF8B4513,
                        ).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Xác nhận',
                              style: GoogleFonts.inika(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Resend Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Không nhận được mã? ',
                        style: GoogleFonts.inika(
                          fontSize: 14,
                          color: const Color(0xFF6D4C41),
                        ),
                      ),
                      if (_canResend)
                        GestureDetector(
                          onTap: _handleResend,
                          child: Text(
                            'Gửi lại',
                            style: GoogleFonts.inika(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF8B4513),
                            ),
                          ),
                        )
                      else
                        Text(
                          'Gửi lại ($_countdown giây)',
                          style: GoogleFonts.inika(
                            fontSize: 14,
                            color: const Color(0xFF6D4C41),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom OTP Input Widget
class _OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? previousFocusNode;
  final FocusNode? nextFocusNode;
  final Function(String) onChanged;

  const _OtpInputField({
    required this.controller,
    required this.focusNode,
    this.previousFocusNode,
    this.nextFocusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3E2723),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8B4513), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8B4513), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8B4513), width: 2.5),
          ),
        ),
        onChanged: (value) {
          onChanged(value);
        },
        onTap: () {
          // Select all text when tapped
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        },
        onEditingComplete: () {
          if (controller.text.isEmpty && previousFocusNode != null) {
            previousFocusNode!.requestFocus();
          }
        },
      ),
    );
  }
}

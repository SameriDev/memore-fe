import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/local/user_manager.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isGoogleLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    final result = await UserManager.instance.loginWithGoogle();

    if (!mounted) return;
    setState(() => _isGoogleLoading = false);

    if (result.success) {
      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
    } else {
      SnackBarHelper.showError(
        context,
        result.errorMessage ?? 'Đăng nhập Google thất bại',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo
              Container(
                width: 150,
                height: 120,
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
                          color: const Color.fromARGB(255, 235, 19, 19),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // App Name
              Text(
                'Memore',
                style: GoogleFonts.inika(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3E2723),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              // Tagline
              Text(
                'Lưu giữ kỷ niệm của bạn',
                textAlign: TextAlign.center,
                style: GoogleFonts.inika(
                  fontSize: 18,
                  color: const Color(0xFF6D4C41),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 3),
              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: const Color(0xFF8B4513).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Tạo tài khoản',
                    style: GoogleFonts.inika(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF8B4513),
                    side: const BorderSide(color: Color(0xFF8B4513), width: 2),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Đăng nhập',
                    style: GoogleFonts.inika(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Divider with "hoặc"
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: Color(0xFFE0E0E0), thickness: 1.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'hoặc',
                      style: GoogleFonts.inika(
                        color: const Color(0xFF6D4C41),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: Color(0xFFE0E0E0), thickness: 1.5),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Google Sign In Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF3E2723),
                    side: const BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1.5,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isGoogleLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Image.asset(
                          'assets/icons/google_logo.png',
                          height: 28,
                          width: 28,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.g_mobiledata, size: 32);
                          },
                        ),
                  label: Text(
                    'Tiếp tục với Google',
                    style: GoogleFonts.inika(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

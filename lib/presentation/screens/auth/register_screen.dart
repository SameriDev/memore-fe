import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/decorated_background.dart';
import '../../../data/local/user_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vui lòng đồng ý với điều khoản sử dụng',
            style: GoogleFonts.inika(),
          ),
          backgroundColor: const Color(0xFFD32F2F),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await UserManager.instance.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (mounted) {
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đăng ký thành công! Chào mừng bạn đến với Memore.',
                style: GoogleFonts.inika(),
              ),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
          Navigator.of(context).pushReplacementNamed('/main');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.errorMessage ?? 'Đăng ký thất bại',
                style: GoogleFonts.inika(),
              ),
              backgroundColor: const Color(0xFFD32F2F),
            ),
          );
        }
      }
    }
  }

  Future<void> _handleGoogleSignUp() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vui lòng đồng ý với điều khoản sử dụng',
            style: GoogleFonts.inika(),
          ),
          backgroundColor: const Color(0xFFD32F2F),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Implement real Google Sign Up
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Google Sign Up chưa được hỗ trợ',
            style: GoogleFonts.inika(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
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
                          // Title
                          Text(
                            'Tạo tài khoản',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inika(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3E2723),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Đăng ký để bắt đầu lưu giữ kỷ niệm',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inika(
                              fontSize: 16,
                              color: const Color(0xFF6D4C41),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            style: GoogleFonts.inika(),
                            decoration: InputDecoration(
                              labelText: 'Họ và tên',
                              labelStyle: GoogleFonts.inika(
                                color: const Color(0xFF6D4C41),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Color(0xFF8B4513),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập họ và tên';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.inika(),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: GoogleFonts.inika(
                                color: const Color(0xFF6D4C41),
                              ),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color(0xFF8B4513),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email';
                              }
                              if (!value.contains('@')) {
                                return 'Email không hợp lệ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            style: GoogleFonts.inika(),
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              labelStyle: GoogleFonts.inika(
                                color: const Color(0xFF6D4C41),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF8B4513),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF8B4513),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              if (value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 ký tự';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Confirm Password Field
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            style: GoogleFonts.inika(),
                            decoration: InputDecoration(
                              labelText: 'Xác nhận mật khẩu',
                              labelStyle: GoogleFonts.inika(
                                color: const Color(0xFF6D4C41),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF8B4513),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF8B4513),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng xác nhận mật khẩu';
                              }
                              if (value != _passwordController.text) {
                                return 'Mật khẩu không khớp';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Terms and Conditions
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTerms = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFF8B4513),
                              ),
                              Expanded(
                                child: Wrap(
                                  children: [
                                    Text(
                                      'Tôi đồng ý với ',
                                      style: GoogleFonts.inika(
                                        color: const Color(0xFF6D4C41),
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Navigate to terms
                                      },
                                      child: Text(
                                        'Điều khoản sử dụng',
                                        style: GoogleFonts.inika(
                                          color: const Color(0xFF8B4513),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Register Button
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B4513),
                                foregroundColor: Colors.white,
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Đăng ký',
                                      style: GoogleFonts.inika(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Divider with "Or"
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFE0E0E0),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Hoặc',
                                  style: GoogleFonts.inika(
                                    color: const Color(0xFF6D4C41),
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFE0E0E0),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Google Sign Up Button
                          SizedBox(
                            height: 56,
                            child: OutlinedButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : _handleGoogleSignUp,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF3E2723),
                                side: const BorderSide(
                                  color: Color(0xFFE0E0E0),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              icon: Image.asset(
                                'assets/icons/google_logo.png',
                                height: 28,
                                width: 28,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.g_mobiledata,
                                    size: 28,
                                  );
                                },
                              ),
                              label: Text(
                                'Đăng ký với Google',
                                style: GoogleFonts.inika(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(), // Đẩy phần login link xuống dưới
                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Đã có tài khoản? ',
                                style: GoogleFonts.inika(
                                  color: const Color(0xFF6D4C41),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Đăng nhập',
                                  style: GoogleFonts.inika(
                                    color: const Color(0xFF8B4513),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

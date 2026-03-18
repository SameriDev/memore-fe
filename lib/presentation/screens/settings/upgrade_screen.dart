import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/local/user_manager.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserManager.instance.toUserProfile();
    final currentPlan = user?.subscriptionPlan ?? 'FREE';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(
          'Nâng cấp tài khoản',
          style: GoogleFonts.inika(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3E2723),
          ),
        ),
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current plan badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: Color(0xFF8B4513)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan hiện tại',
                        style: GoogleFonts.inika(
                          fontSize: 12,
                          color: const Color(0xFF6D4C41),
                        ),
                      ),
                      Text(
                        currentPlan,
                        style: GoogleFonts.inika(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _planColor(currentPlan),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Comparison table
            Text(
              'So sánh các gói',
              style: GoogleFonts.inika(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              plan: 'FREE',
              price: 'Miễn phí',
              aiLimit: '3 lần/ngày',
              color: const Color(0xFF9E9E9E),
              isCurrent: currentPlan == 'FREE',
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              plan: 'SILVER',
              price: '70.000₫ / tháng',
              aiLimit: '20 lần/ngày',
              color: const Color(0xFF90A4AE),
              isCurrent: currentPlan == 'SILVER',
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              plan: 'GOLD',
              price: '150.000₫ / tháng',
              aiLimit: 'Không giới hạn',
              color: const Color(0xFFFCBA03),
              isCurrent: currentPlan == 'GOLD',
              isGold: true,
            ),

            const SizedBox(height: 32),

            // Payment instructions
            Text(
              'Hướng dẫn thanh toán',
              style: GoogleFonts.inika(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR Code
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/icons/QR.png',
                        width: 220,
                        height: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildBankInfoRow('Ngân hàng', 'MB Bank'),
                  const SizedBox(height: 8),
                  _buildBankInfoRow('Số tài khoản', '42739397979'),
                  const SizedBox(height: 8),
                  _buildBankInfoRow('Chủ tài khoản', 'VU TUAN HIEP'),
                  const SizedBox(height: 8),
                  _buildBankInfoRow('Nội dung CK', 'MEMORE [tên gói] [username]'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sau khi chuyển khoản:',
                    style: GoogleFonts.inika(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStep('1', 'Chụp màn hình xác nhận giao dịch'),
                  _buildStep('2', 'Gửi screenshot qua Zalo hoặc Facebook Memore'),
                  _buildStep('3', 'Admin sẽ kích hoạt gói trong vòng 24h'),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String plan,
    required String price,
    required String aiLimit,
    required Color color,
    required bool isCurrent,
    bool isGold = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrent
            ? Border.all(color: color, width: 2)
            : Border.all(color: Colors.black.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          if (isGold)
            const Icon(Icons.star, color: Color(0xFFFCBA03), size: 28)
          else
            Icon(Icons.circle, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      plan,
                      style: GoogleFonts.inika(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          'Hiện tại',
                          style: GoogleFonts.inika(fontSize: 10, color: color),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  price,
                  style: GoogleFonts.inika(
                    fontSize: 14,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'AI edit',
                style: GoogleFonts.inika(fontSize: 11, color: const Color(0xFF9E9E9E)),
              ),
              Text(
                aiLimit,
                style: GoogleFonts.inika(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3E2723),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: GoogleFonts.inika(
              fontSize: 13,
              color: const Color(0xFF6D4C41),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inika(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3E2723),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF8B4513),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inika(fontSize: 13, color: const Color(0xFF3E2723)),
            ),
          ),
        ],
      ),
    );
  }

  Color _planColor(String plan) {
    switch (plan) {
      case 'GOLD':
        return const Color(0xFFFCBA03);
      case 'SILVER':
        return const Color(0xFF90A4AE);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}

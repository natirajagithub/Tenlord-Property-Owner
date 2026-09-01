import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/launcher_utils.dart';
import '../../../core/widgets/whatsapp_icon.dart';

class PendingRentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const PendingRentDetailsScreen({super.key, this.data});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'A';
  }

  @override
  Widget build(BuildContext context) {
    final tenantName = data?['tenantName'] as String? ?? 'Amit Verma';
    final property = data?['property'] as String? ?? 'Shanti Residency • 1st Floor';
    final roomNo = data?['roomNo'] as String? ?? '101';
    final totalDue = data?['totalDue'] as String? ?? '₹11,200';
    final initials = _getInitials(tenantName);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              // 1. Sleek Seamless Native App Header Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.dashboard);
                        }
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF0F172A)),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Pending Rent Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),

              // 2. Main Body Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    // Top Hero Overdue Alert Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFFECDD3)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFFDA4AF)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFE11D48)),
                                    SizedBox(width: 4),
                                    Text('Overdue by 5 Days', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFE11D48))),
                                  ],
                                ),
                              ),
                              Text(
                                totalDue,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFE11D48), letterSpacing: -0.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFFECDD3)),
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFFE11D48)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tenantName,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Room $roomNo • $property',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick Fee Breakdown Metric Bar
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFeeCol('Rent', '₹9,000'),
                          Container(width: 1, height: 26, color: const Color(0xFFF1F5F9)),
                          _buildFeeCol('Maintenance', '₹1,000'),
                          Container(width: 1, height: 26, color: const Color(0xFFF1F5F9)),
                          _buildFeeCol('Electricity', '₹1,200'),
                          Container(width: 1, height: 26, color: const Color(0xFFF1F5F9)),
                          _buildFeeCol('Total Due', totalDue, isHighlight: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 1: Breakup Details Box (Zero Overflow)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.receipt_long_outlined, size: 18, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text('Breakup Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildBreakupRow('Monthly Rent (August)', '₹9,000', 'Overdue', const Color(0xFFEF4444)),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildBreakupRow('Maintenance (August)', '₹1,000', 'Overdue', const Color(0xFFEF4444)),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildBreakupRow('Electricity Bill (July)', '₹1,200', 'Overdue', const Color(0xFFEF4444)),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildBreakupRow('Water Charges', '₹0', 'Paid ✓', const Color(0xFF10B981)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Payment Summary Box (Zero Overflow)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.account_balance_wallet_outlined, size: 18, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text('Payment Summary', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildSummaryRow('Due Date', '15 August 2026'),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildSummaryRow('Total Due Amount', totalDue, isBold: true),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildSummaryRow('Amount Received', '₹0'),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildSummaryRow('Net Balance Due', totalDue, isRed: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Bottom Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    // Remind Tenant via WhatsApp Primary Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          LauncherUtils.launchWhatsApp(
                            tenantName: tenantName,
                            roomNo: roomNo,
                            monthlyRent: 11200,
                            phone: '7489128297',
                          );
                        },
                        icon: const WhatsAppIcon(size: 18),
                        label: const Text(
                          'Remind Tenant via WhatsApp',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Record Payment Green Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.push(AppRoutes.recordPayment, extra: {
                            'tenantName': tenantName,
                            'roomNo': roomNo,
                            'property': property,
                            'pendingAmount': 11200,
                          });
                        },
                        icon: const Icon(Icons.receipt_long_rounded, size: 18, color: Color(0xFF10B981)),
                        label: const Text(
                          'Record Payment',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFECFDF5),
                          side: const BorderSide(color: Color(0xFF10B981), width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // View Tenant Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.push(AppRoutes.tenantDetails, extra: {
                            'name': tenantName,
                            'roomNo': roomNo,
                            'property': property,
                          });
                        },
                        icon: const Icon(Icons.person_outline_rounded, size: 18, color: Color(0xFF0F172A)),
                        label: const Text(
                          'View Tenant Profile',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeeCol(String title, String val, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: isHighlight ? const Color(0xFFE11D48) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakupRow(String label, String amount, String status, Color statusColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: statusColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String val, {bool isBold = false, bool isRed = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            val,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isBold || isRed ? FontWeight.w900 : FontWeight.w700,
              color: isRed ? const Color(0xFFE11D48) : const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/launcher_utils.dart';
import '../../../core/widgets/whatsapp_icon.dart';

class TenantDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const TenantDetailsScreen({super.key, this.data});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'T';
  }

  @override
  Widget build(BuildContext context) {
    final name = data?['name'] as String? ?? 'Vikramaditya Roy';
    final roomNo = data?['roomNo'] as String? ?? '101';
    final property = data?['property'] as String? ?? 'Sunrise Apartments';
    final phone = data?['phone'] as String? ?? '7489128297';
    final initials = _getInitials(name);

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
                        'Tenant Profile Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.addTenant, extra: {
                          'isEdit': true,
                          'name': name,
                          'roomNo': roomNo,
                          'phone': phone,
                        });
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
                          child: Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F172A)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Main Body Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    // Modern Hero Profile Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Soft Decorative Top Header Banner
                          Container(
                            height: 64,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                          ),

                          // Avatar + Overlapping Profile Header
                          Transform.translate(
                            offset: const Offset(0, -32),
                            child: Column(
                              children: [
                                // Avatar Container with Clean Border
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.25),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      initials,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  name,
                                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.4),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Room $roomNo • $property',
                                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),

                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECFDF5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFA7F3D0)),
                                  ),
                                  child: const Text(
                                    'Active Tenant',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Quick Stat Badges Strip
                          Transform.translate(
                            offset: const Offset(0, -16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFF1F5F9)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildQuickStatItem('Unit', 'Room $roomNo'),
                                    Container(width: 1, height: 24, color: const Color(0xFFE2E8F0)),
                                    _buildQuickStatItem('Rent', '₹8,500/mo'),
                                    Container(width: 1, height: 24, color: const Color(0xFFE2E8F0)),
                                    _buildQuickStatItem('Joined', 'Jan 2024'),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Action Buttons Bar
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => LauncherUtils.makePhoneCall(phone),
                                    icon: const Icon(Icons.phone_rounded, size: 16, color: Colors.white),
                                    label: const Text('Call Tenant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => LauncherUtils.launchWhatsApp(
                                      tenantName: name,
                                      roomNo: roomNo,
                                      monthlyRent: 8500,
                                      phone: phone,
                                    ),
                                    icon: const WhatsAppIcon(size: 17),
                                    label: const Text('WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25D366),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Room & Billing Summary Box
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.king_bed_outlined, size: 16, color: AppColors.primary),
                              ),
                              const SizedBox(width: 10),
                              const Text('Room & Billing Details', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow('Assigned Unit', 'Room $roomNo (Bed 1)'),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildDetailRow('Monthly Rent', '₹8,500 / month'),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildDetailRow('Security Deposit', '₹10,000 (Paid)'),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildDetailRow('Move-in Date', '10 Jan 2024'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Identity & Documents Box (No Overflow!)
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF10B981)),
                              ),
                              const SizedBox(width: 10),
                              const Text('Documents & ID Proof', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow('Aadhaar Card', 'XXXX XXXX 4829 (Verified ✓)'),
                          const Divider(color: Color(0xFFF1F5F9), height: 18),
                          _buildDetailRow('Emergency Contact', '+91 98765 00000 (Father)'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatItem(String label, String val) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
      ],
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            val,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }
}

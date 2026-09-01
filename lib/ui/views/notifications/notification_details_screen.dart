import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/launcher_utils.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/whatsapp_icon.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const NotificationDetailsScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final categoryTitle = data?['category'] as String? ?? 'New Tenant Request';
    final tenantName = data?['tenantName'] as String? ?? 'Rahul Verma';
    final propertyName = data?['property'] as String? ?? 'Sunrise Apartments';
    final address = data?['address'] as String? ?? 'A-101, Sunrise Apartments, Sector 45, Noida';
    final phone = data?['phone'] as String? ?? '+91 98765 43210';
    final timeAgo = data?['time'] as String? ?? '2 min ago';
    final type = data?['type'] as String? ?? 'new_tenant';
    final avatarUrl = data?['avatarUrl'] as String? ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';

    Color themeColor;
    Color bgThemeColor;
    IconData heroIcon;

    if (type == 'request') {
      themeColor = const Color(0xFFD97706);
      bgThemeColor = const Color(0xFFFFFBEB);
      heroIcon = Icons.search_rounded;
    } else if (type == 'leaving') {
      themeColor = const Color(0xFF16A34A);
      bgThemeColor = const Color(0xFFECFDF5);
      heroIcon = Icons.output_rounded;
    } else {
      themeColor = const Color(0xFF7C3AED);
      bgThemeColor = const Color(0xFFF5F3FF);
      heroIcon = Icons.person_add_alt_1_rounded;
    }

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
              // 1. Sleek Native Header Bar
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
                        'Notification Details',
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

              // 2. Main Scrollable Content Body
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Hero Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: bgThemeColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: themeColor.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: themeColor.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              categoryTitle,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: themeColor),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeColor.withValues(alpha: 0.15),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                avatarUrl,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  final initial = tenantName.isNotEmpty ? tenantName[0].toUpperCase() : 'T';
                                  return Container(
                                    color: themeColor.withValues(alpha: 0.15),
                                    alignment: Alignment.center,
                                    child: Text(
                                      initial,
                                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: themeColor),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tenantName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            type == 'request'
                                ? 'Requested a room in $propertyName'
                                : type == 'leaving'
                                    ? 'Submitted move-out notice for $propertyName'
                                    : 'Successfully added to $propertyName',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(heroIcon, size: 14, color: themeColor),
                              const SizedBox(width: 4),
                              Text(
                                timeAgo,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tenant Details Card
                    _buildSectionContainer(
                      icon: Icons.person_outline_rounded,
                      iconBg: const Color(0xFFF3E8FF),
                      iconColor: const Color(0xFF7C3AED),
                      title: 'Tenant Details',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Full Name', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 2),
                                  Text(tenantName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Contact Phone', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 2),
                                  Text(phone, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Action Buttons Row (Call & WhatsApp)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => LauncherUtils.makePhoneCall(phone.replaceAll(' ', '')),
                                  icon: const Icon(Icons.phone_rounded, size: 16, color: AppColors.primary),
                                  label: const Text('Call Tenant', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.primary, width: 1.2),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => LauncherUtils.launchWhatsApp(
                                    tenantName: tenantName,
                                    roomNo: 'A-101',
                                    monthlyRent: 8500,
                                    phone: phone.replaceAll(' ', ''),
                                  ),
                                  icon: const WhatsAppIcon(size: 16),
                                  label: const Text('WhatsApp', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF25D366))),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF25D366), width: 1.2),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Property & Room Info Card
                    _buildSectionContainer(
                      icon: Icons.apartment_rounded,
                      iconBg: const Color(0xFFEFF6FF),
                      iconColor: AppColors.primary,
                      title: 'Property & Location',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Property Name', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(propertyName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                          const SizedBox(height: 10),
                          const Text('Full Address', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(
                            address.replaceAll('\n', ' '),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155), height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Status & Notes Card
                    _buildSectionContainer(
                      icon: Icons.info_outline_rounded,
                      iconBg: const Color(0xFFFFEDD5),
                      iconColor: const Color(0xFFF97316),
                      title: 'Notification Details & Notes',
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Text(
                          type == 'request'
                              ? 'Tenant submitted a new room application for $propertyName. Contact number verified. Ready for onboarding review.'
                              : type == 'leaving'
                                  ? 'Tenant submitted 30-day notice to vacate room. Rent dues clear. Deposit refund verification in progress.'
                                  : 'New tenant onboarding completed successfully. Welcome SMS & Rent Agreement sent via WhatsApp.',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500, height: 1.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Bottom Action Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ToastUtils.showSuccess(context, 'Marked notification as resolved');
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Mark as Resolved',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

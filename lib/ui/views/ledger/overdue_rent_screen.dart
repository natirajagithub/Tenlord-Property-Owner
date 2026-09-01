import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/launcher_utils.dart';
import '../../../core/widgets/whatsapp_icon.dart';

class OverdueRentScreen extends StatelessWidget {
  const OverdueRentScreen({super.key});

  static const List<Map<String, dynamic>> _overdueTenants = [
    {
      'roomNo': '101',
      'name': 'Amit Verma',
      'property': 'Shanti Residency • 1st Floor',
      'rent': 9000,
      'maintenance': 1000,
      'electricity': 1200,
      'totalDue': 11200,
      'dueDate': '5 May 2024',
      'phone': '7489128297',
    },
    {
      'roomNo': 'G2',
      'name': 'Rohit Sharma',
      'property': 'Shanti Residency • Ground Floor',
      'rent': 8000,
      'maintenance': 1000,
      'electricity': 800,
      'totalDue': 9800,
      'dueDate': '5 May 2024',
      'phone': '9876543210',
    },
    {
      'roomNo': '201',
      'name': 'Neha Patel',
      'property': 'Shanti Residency • 2nd Floor',
      'rent': 9000,
      'maintenance': 1000,
      'electricity': 900,
      'totalDue': 10900,
      'dueDate': '5 May 2024',
      'phone': '9876543211',
    },
    {
      'roomNo': '102',
      'name': 'Pooja Singh',
      'property': 'Shanti Residency • 1st Floor',
      'rent': 8500,
      'maintenance': 800,
      'electricity': 800,
      'totalDue': 10100,
      'dueDate': '6 May 2024',
      'phone': '9876543212',
    },
    {
      'roomNo': '202',
      'name': 'Vikram Joshi',
      'property': 'Shanti Residency • 2nd Floor',
      'rent': 6800,
      'maintenance': 700,
      'electricity': 500,
      'totalDue': 8000,
      'dueDate': '6 May 2024',
      'phone': '9876543213',
    },
    {
      'roomNo': '301',
      'name': 'Karan Mehta',
      'property': 'Shanti Residency • 3rd Floor',
      'rent': 10000,
      'maintenance': 1200,
      'electricity': 800,
      'totalDue': 12000,
      'dueDate': '7 May 2024',
      'phone': '9876543214',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
              // 1. Sleek Header Bar
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const Text(
                      'Overdue Rent',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Center(
                        child: Icon(Icons.tune_rounded, size: 18, color: Color(0xFF0F172A)),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Main Body Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Pink/Red Overdue Banner Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFE4E6)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '6 Tenants',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFE11D48),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '₹62,000',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFEF4444),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Total Overdue Amount',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(Icons.access_time_filled_rounded, color: Color(0xFFEF4444), size: 28),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sort Selector Row
                      const Row(
                        children: [
                          Text(
                            'Sort by: ',
                            style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Due Date (Earliest)',
                            style: TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_downward_rounded, size: 14, color: Color(0xFF0F172A)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 1:1 Reference Overdue Tenant List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _overdueTenants.length,
                        itemBuilder: (ctx, idx) {
                          final t = _overdueTenants[idx];
                          final String roomNo = t['roomNo'] as String;
                          final String name = t['name'] as String;
                          final String property = t['property'] as String;
                          final String phone = t['phone'] as String;
                          final String dueDate = t['dueDate'] as String;
                          final num rent = t['rent'] as num;
                          final num maintenance = t['maintenance'] as num;
                          final num electricity = t['electricity'] as num;
                          final num totalDue = t['totalDue'] as num;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                context.push(AppRoutes.pendingRentDetails, extra: {
                                  'tenantName': name,
                                  'roomNo': roomNo,
                                  'property': property,
                                  'pendingAmount': totalDue,
                                  'phone': phone,
                                  'rent': rent,
                                  'maintenance': maintenance,
                                  'electricity': electricity,
                                  'dueDate': dueDate,
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    // 1. Top Row: Room Badge | Name & Subtitle | WhatsApp & Call Actions
                                    Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF3E8FF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              roomNo,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFF7C3AED),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color(0xFF0F172A),
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                property,
                                                style: const TextStyle(
                                                  fontSize: 11.5,
                                                  color: Color(0xFF64748B),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // WhatsApp Action Button
                                        GestureDetector(
                                          onTap: () {
                                            LauncherUtils.launchWhatsApp(
                                              tenantName: name,
                                              roomNo: roomNo,
                                              monthlyRent: totalDue,
                                              phone: phone,
                                            );
                                          },
                                          child: Container(
                                            width: 38,
                                            height: 38,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFFE2E8F0)),
                                            ),
                                            child: const Center(child: WhatsAppIcon(size: 20)),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Phone Call Action Button
                                        GestureDetector(
                                          onTap: () => LauncherUtils.makePhoneCall(phone),
                                          child: Container(
                                            width: 38,
                                            height: 38,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFFE2E8F0)),
                                            ),
                                            child: const Center(
                                              child: Icon(Icons.phone_rounded, size: 18, color: Color(0xFF2563EB)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),

                                    // 2. Middle Row: Rent | Maintenance | Electricity | Overdue Badge
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Rent', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                                              const SizedBox(height: 3),
                                              Text(Formatters.currency(rent), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                                            ],
                                          ),
                                        ),
                                        Container(width: 1, height: 24, color: const Color(0xFFF1F5F9)),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Maintenance', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                                              const SizedBox(height: 3),
                                              Text(Formatters.currency(maintenance), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                                            ],
                                          ),
                                        ),
                                        Container(width: 1, height: 24, color: const Color(0xFFF1F5F9)),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Electricity', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                                              const SizedBox(height: 3),
                                              Text(Formatters.currency(electricity), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF1F2),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'Overdue',
                                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFFEF4444)),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),
                                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                    const SizedBox(height: 12),

                                    // 3. Bottom Row: Due Date & Total Due
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Due Date', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 2),
                                            Text(
                                              dueDate,
                                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            const Text('Total Due', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 2),
                                            Text(
                                              Formatters.currency(totalDue),
                                              style: const TextStyle(
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFFEF4444),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Bottom "View All Overdue (6) →" Link
                      Center(
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.tenants),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View All Overdue (6)',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
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
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Header Bar (Home Title + Bell Icon)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: const Center(
                                child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF0F172A)),
                              ),
                            ),
                          ),
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.notifications_none_rounded, size: 20, color: Color(0xFF0F172A)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 2. Notifications Summary Header Card (Lavender Background)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEBE5FF)),
                    ),
                    child: Column(
                      children: [
                        // Bell Icon + Title Row
                        Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE9FE),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.notifications_rounded, color: Color(0xFF7C3AED), size: 24),
                                  ),
                                ),
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEF4444),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '3',
                                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Notifications',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                RichText(
                                  text: const TextSpan(
                                    text: 'You have ',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                    children: [
                                      TextSpan(
                                        text: '3 new updates',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF6D28D9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Inner White Metrics Bar (Zero Overflow Guard)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
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
                              _buildMetricItem(
                                icon: Icons.person_outline_rounded,
                                iconBg: const Color(0xFFF3E8FF),
                                iconColor: const Color(0xFF7C3AED),
                                count: '1',
                                label: 'New Tenant',
                              ),
                              Container(width: 1, height: 30, color: const Color(0xFFF1F5F9)),
                              _buildMetricItem(
                                icon: Icons.description_outlined,
                                iconBg: const Color(0xFFFFEDD5),
                                iconColor: const Color(0xFFF97316),
                                count: '1',
                                label: 'Tenant Request',
                              ),
                              Container(width: 1, height: 30, color: const Color(0xFFF1F5F9)),
                              _buildMetricItem(
                                icon: Icons.logout_rounded,
                                iconBg: const Color(0xFFDCFCE7),
                                iconColor: const Color(0xFF16A34A),
                                count: '1',
                                label: 'Tenant Leaving',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Notification List Cards (3 Item Cards)
                  _buildNotificationCard(
                    categoryTitle: 'New Tenant Added',
                    categoryColor: const Color(0xFF6D28D9),
                    categoryBg: const Color(0xFFF3E8FF),
                    categoryIcon: Icons.person_add_alt_1_rounded,
                    timeAgo: '2 min ago',
                    dotColor: const Color(0xFF6D28D9),
                    tenantName: 'Rahul Verma',
                    phone: '+91 98765 43210',
                    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                    propertyName: 'Sunrise Apartments',
                    address: 'A-101, Sunrise Apartments,\nSector 45, Noida',
                    type: 'new_tenant',
                    onTap: () {
                      context.push(AppRoutes.notificationDetails, extra: {
                        'category': 'New Tenant Added',
                        'tenantName': 'Rahul Verma',
                        'phone': '+91 98765 43210',
                        'property': 'Sunrise Apartments',
                        'address': 'A-101, Sunrise Apartments, Sector 45, Noida',
                        'time': '2 min ago',
                        'type': 'new_tenant',
                        'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildNotificationCard(
                    categoryTitle: 'Tenant Request',
                    categoryColor: const Color(0xFFD97706),
                    categoryBg: const Color(0xFFFFEDD5),
                    categoryIcon: Icons.search_rounded,
                    timeAgo: '15 min ago',
                    dotColor: const Color(0xFFD97706),
                    tenantName: 'Priya Sharma',
                    phone: '+91 87654 32109',
                    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                    propertyName: 'Green Villa',
                    address: 'Villa 7, Green Villa Society,\nWhitefield, Bangalore',
                    type: 'request',
                    onTap: () {
                      context.push(AppRoutes.notificationDetails, extra: {
                        'category': 'Tenant Request',
                        'tenantName': 'Priya Sharma',
                        'phone': '+91 87654 32109',
                        'property': 'Green Villa',
                        'address': 'Villa 7, Green Villa Society, Whitefield, Bangalore',
                        'time': '15 min ago',
                        'type': 'request',
                        'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildNotificationCard(
                    categoryTitle: 'Tenant Leaving',
                    categoryColor: const Color(0xFF16A34A),
                    categoryBg: const Color(0xFFDCFCE7),
                    categoryIcon: Icons.output_rounded,
                    timeAgo: '1 hr ago',
                    dotColor: const Color(0xFF16A34A),
                    tenantName: 'Amit Patel',
                    phone: '+91 76543 21098',
                    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                    propertyName: 'Maple Heights',
                    address: 'B-203, Maple Heights,\nMira Road, Mumbai',
                    type: 'leaving',
                    onTap: () {
                      context.push(AppRoutes.notificationDetails, extra: {
                        'category': 'Tenant Vacating',
                        'tenantName': 'Amit Patel',
                        'phone': '+91 76543 21098',
                        'property': 'Maple Heights',
                        'address': 'B-203, Maple Heights, Mira Road, Mumbai',
                        'time': '1 hr ago',
                        'type': 'leaving',
                        'avatarUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // 4. View All Notifications Button Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3E8FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.format_list_bulleted_rounded, size: 16, color: Color(0xFF6D28D9)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'View All Notifications',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF6D28D9),
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: Color(0xFF6D28D9), size: 22),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 5. Overview Section Header & Stat Cards Grid
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _buildOverviewTile(
                          bg: const Color(0xFFF3E8FF),
                          icon: Icons.domain_rounded,
                          iconColor: const Color(0xFF7C3AED),
                          count: '12',
                          label: 'Total Properties',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildOverviewTile(
                          bg: const Color(0xFFEFF6FF),
                          icon: Icons.person_outline_rounded,
                          iconColor: const Color(0xFF2563EB),
                          count: '24',
                          label: 'Total Tenants',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildOverviewTile(
                          bg: const Color(0xFFECFDF5),
                          icon: Icons.description_outlined,
                          iconColor: const Color(0xFF10B981),
                          count: '5',
                          label: 'Pending Requests',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildOverviewTile(
                          bg: const Color(0xFFFFF7ED),
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: const Color(0xFFEA580C),
                          count: '₹2.45L',
                          label: 'Rent Collected',
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
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String count,
    required String label,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(child: Icon(icon, size: 14, color: iconColor)),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  count,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String categoryTitle,
    required Color categoryColor,
    required Color categoryBg,
    required IconData categoryIcon,
    required String timeAgo,
    required Color dotColor,
    required String tenantName,
    required String phone,
    required String avatarUrl,
    required String propertyName,
    required String address,
    required String type,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row: Category Badge + Title + Time + Dot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: categoryBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Icon(categoryIcon, size: 15, color: categoryColor)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    categoryTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: categoryColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    timeAgo,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Split Body Content: Tenant Details | Property Details
          Row(
            children: [
              // Left Column: Tenant Avatar, Name, Phone
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEFF6FF),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          avatarUrl,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            final initial = tenantName.isNotEmpty ? tenantName[0].toUpperCase() : 'T';
                            return Container(
                              color: const Color(0xFFEFF6FF),
                              alignment: Alignment.center,
                              child: Text(
                                initial,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tenantName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              phone,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Vertical Line Divider
              Container(
                width: 1,
                height: 36,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: const Color(0xFFF1F5F9),
              ),

              // Right Column: Property Name & Address
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      propertyName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      maxLines: 2,
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
  );
}

  Widget _buildOverviewTile({
    required Color bg,
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              count,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

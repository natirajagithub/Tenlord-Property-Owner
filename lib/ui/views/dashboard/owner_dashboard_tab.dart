import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/launcher_utils.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../data/services/storage_service.dart';
import '../../view_models/owner_auth_view_model.dart';
import '../../view_models/owner_dashboard_view_model.dart';
import '../../view_models/tenants_view_model.dart';
import '../../view_models/rent_ledger_view_model.dart';
import '../../view_models/complaints_manage_view_model.dart';

class OwnerDashboardTab extends StatelessWidget {
  final OwnerDashboardViewModel viewModel;
  final TenantsViewModel tenantsViewModel;
  final RentLedgerViewModel ledgerViewModel;
  final ComplaintsManageViewModel complaintsViewModel;
  final OwnerAuthViewModel authViewModel;
  final ValueChanged<int>? onNavigateTab;

  const OwnerDashboardTab({
    super.key,
    required this.viewModel,
    required this.tenantsViewModel,
    required this.ledgerViewModel,
    required this.complaintsViewModel,
    required this.authViewModel,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final profile = StorageService.getOwnerProfile();
    final name = profile['name'] ?? 'Rahul';
    final firstName = name.split(' ')[0];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            // 1. Clean Top Header Bar (No Drawer, Bell + Profile Avatar)
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: topPadding + 10,
                left: 18,
                right: 18,
                bottom: 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Welcome, $firstName! 👋',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Here\'s what\'s happening with your properties today.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Notification Bell with Red Badge
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.notifications),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: Color(0xFF0F172A),
                                  size: 20,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '5',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 6 Group Summary Metric Cards Grid (Matching Reference Image 1:1)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF0F172A,
                            ).withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildMetricItem(
                                icon: Icons.domain_rounded,
                                iconBg: const Color(0xFFEFF6FF),
                                iconColor: AppColors.primary,
                                title: 'Total Properties',
                                value: '3',
                                subtitle: 'All Types',
                                onTap: () => onNavigateTab?.call(1),
                              ),
                              _buildMetricItem(
                                icon: Icons.groups_rounded,
                                iconBg: const Color(0xFFF3E8FF),
                                iconColor: const Color(0xFF7C3AED),
                                title: 'Total Tenants',
                                value: '32',
                                subtitle: 'Across Properties',
                                onTap: () => onNavigateTab?.call(2),
                              ),
                              _buildMetricItem(
                                icon: Icons.currency_rupee_rounded,
                                iconBg: const Color(0xFFDCFCE7),
                                iconColor: const Color(0xFF16A34A),
                                title: 'Collected Rent',
                                value: '₹2,48,500',
                                subtitle: 'This Month',
                                valColor: const Color(0xFF16A34A),
                                onTap: () => onNavigateTab?.call(3),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                          ),
                          Row(
                            children: [
                              _buildMetricItem(
                                icon: Icons.business_center_rounded,
                                iconBg: const Color(0xFFFFF1F2),
                                iconColor: const Color(0xFFE11D48),
                                title: 'Due Rent',
                                value: '₹68,500',
                                subtitle: 'From 9 Tenants',
                                valColor: const Color(0xFFEF4444),
                                onTap: () =>
                                    context.push(AppRoutes.pendingRentOverview),
                              ),
                              _buildMetricItem(
                                icon: Icons.bed_rounded,
                                iconBg: const Color(0xFFFEF3C7),
                                iconColor: const Color(0xFFD97706),
                                title: 'Total Rooms & Beds',
                                value: '64 / 96',
                                subtitle: 'Rooms / Beds',
                                onTap: () => onNavigateTab?.call(1),
                              ),
                              _buildMetricItem(
                                icon: Icons.pie_chart_rounded,
                                iconBg: const Color(0xFFEFF6FF),
                                iconColor: AppColors.primary,
                                title: 'Occupancy',
                                value: '66%',
                                subtitle: '64 / 96 Occupied',
                                onTap: () => onNavigateTab?.call(1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick Actions Section
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildQuickActionButton(
                            icon: Icons.add_business_rounded,
                            iconColor: AppColors.primary,
                            iconBg: const Color(0xFFEFF6FF),
                            label: 'Add\nProperty',
                            onTap: () => context.push(AppRoutes.addProperty),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.person_add_alt_1_rounded,
                            iconColor: const Color(0xFF7C3AED),
                            iconBg: const Color(0xFFF3E8FF),
                            label: 'Add\nTenant',
                            onTap: () => context.push(AppRoutes.addTenant),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.construction_rounded,
                            iconColor: const Color(0xFFD97706),
                            iconBg: const Color(0xFFFEF3C7),
                            label: 'Maintenance',
                            onTap: () => onNavigateTab?.call(5),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.restaurant_rounded,
                            iconColor: const Color(0xFF16A34A),
                            iconBg: const Color(0xFFDCFCE7),
                            label: 'Menu',
                            onTap: () => ToastUtils.showInfo(
                              context,
                              'Food menu module',
                            ),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.badge_outlined,
                            iconColor: const Color(0xFFEF4444),
                            iconBg: const Color(0xFFFFF1F2),
                            label: 'Add\nEmployee',
                            onTap: () => ToastUtils.showInfo(
                              context,
                              'Add Employee module',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // "Your Properties" Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Properties',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onNavigateTab?.call(1),
                          child: const Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Property Card 1: Shanti Residency (Hostel)
                    _buildPropertyCard(
                      context: context,
                      propertyName: 'Shanti Residency (Hostel)',
                      address: 'MG Road, Indore, MP',
                      imageUrl: 'assets/property1.png',
                      status: 'Active',
                      floorsCount: '3 Floors',
                      roomsCount: '24 Rooms',
                      bedsCount: '52 Beds',
                      dueRent: '₹35,000',
                      dueTenants: '5 Tenants',
                      collectedRent: '₹1,28,500',
                      totalTenants: '18',
                      totalBeds: '52',
                      occupiedBeds: '38',
                      occupancyPercent: '73%',
                    ),

                    const SizedBox(height: 14),

                    // Property Card 2: Green View Apartments (Apartment)
                    _buildPropertyCard(
                      context: context,
                      propertyName: 'Green View Apartments (Apartment)',
                      address: 'Palasia, Indore, MP',
                      imageUrl: 'assets/property2.png',
                      status: 'Active',
                      floorsCount: '4 Floors',
                      roomsCount: '20 Units',
                      bedsCount: '16 Flats',
                      dueRent: '₹33,500',
                      dueTenants: '4 Tenants',
                      collectedRent: '₹1,20,000',
                      totalTenants: '14',
                      totalBeds: '20',
                      occupiedBeds: '16',
                      occupancyPercent: '80%',
                      isApartment: true,
                    ),

                    const SizedBox(height: 20),

                    // Share Tenant App Link Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.share_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Share your tenant app link with tenants and let them send request to join.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF1E3A8A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              LauncherUtils.launchWhatsApp(
                                tenantName: 'Tenant',
                                roomNo: 'Link',
                                monthlyRent: 0,
                                phone: '',
                              );
                            },
                            icon: const Icon(
                              Icons.share_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Share Link',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
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
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    Color? valColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Center(child: Icon(icon, color: iconColor, size: 20)),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w900,
                color: valColor ?? const Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 9.5,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    Color? iconColor,
    Color? iconBg,
    required String label,
    required VoidCallback onTap,
  }) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveIconBg = iconBg ?? const Color(0xFFEFF6FF);

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: effectiveIconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(icon, color: effectiveIconColor, size: 22),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 26,
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    height: 1.15,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard({
    required BuildContext context,
    required String propertyName,
    required String address,
    required String imageUrl,
    required String status,
    required String floorsCount,
    required String roomsCount,
    required String bedsCount,
    required String dueRent,
    required String dueTenants,
    required String collectedRent,
    required String totalTenants,
    required String totalBeds,
    required String occupiedBeds,
    required String occupancyPercent,
    bool isApartment = false,
  }) {
    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.propertyUnits,
          extra: {
            'propertyName': propertyName,
            'viewModel': AppRouter.propertiesViewModel,
            'imageUrl': imageUrl,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row Image + Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          width: 90,
                          height: 68,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            width: 90,
                            height: 68,
                            color: const Color(0xFFEFF6FF),
                            child: const Icon(Icons.domain_rounded, color: AppColors.primary),
                          ),
                        )
                      : Image.asset(
                          imageUrl,
                          width: 90,
                          height: 68,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            width: 90,
                            height: 68,
                            color: const Color(0xFFEFF6FF),
                            child: const Icon(Icons.domain_rounded, color: AppColors.primary),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              propertyName,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            floorsCount,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const Text(
                            ' • ',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          Text(
                            roomsCount,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const Text(
                            ' • ',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          Text(
                            bedsCount,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Middle 5 Metrics Row (Horizontal Scroll to prevent overflow)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildCardSubMetric(
                    'Due Rent',
                    dueRent,
                    dueTenants,
                    valColor: const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 16),
                  _buildCardSubMetric(
                    'Collected Rent',
                    collectedRent,
                    'This Month',
                    valColor: const Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 16),
                  _buildCardSubMetric('Total Tenants', totalTenants, 'Active'),
                  const SizedBox(width: 16),
                  _buildCardSubMetric(
                    isApartment ? 'Total Units' : 'Total Beds',
                    totalBeds,
                    'Rooms / Beds',
                  ),
                  const SizedBox(width: 16),
                  _buildCardSubMetric(
                    isApartment ? 'Occupied Units' : 'Occupied Beds',
                    occupiedBeds,
                    occupancyPercent,
                    valColor: const Color(0xFF16A34A),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Bottom Action Bar (View Details -> Property Specific Dashboard)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                TextButton.icon(
                  onPressed: () => onNavigateTab?.call(2),
                  icon: const Icon(
                    Icons.people_outline_rounded,
                    size: 16,
                    color: Color(0xFF475569),
                  ),
                  label: const Text(
                    'Tenants',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.push(
                        AppRoutes.addProperty,
                        extra: {
                          'propertyName': propertyName,
                          'address': address,
                          // Add other fields if necessary
                        },
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18, color: Color(0xFF0F172A)),
                          SizedBox(width: 8),
                          Text(
                            'Edit Property',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildCardSubMetric(
    String label,
    String value,
    String sub, {
    Color? valColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            color: valColor ?? const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          sub,
          style: const TextStyle(
            fontSize: 8.5,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/widgets/header_wave_painter.dart';
import '../view_models/owner_auth_view_model.dart';

class OwnerNavigationDrawer extends StatelessWidget {
  final String currentRoute;
  final OwnerAuthViewModel authViewModel;

  const OwnerNavigationDrawer({
    super.key,
    required this.currentRoute,
    required this.authViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Column(
        children: [
          // 1. Luxury Midnight Navy Header with Wave Painter & Glowing Avatar
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.midnightNavy, Color(0xFF132C5D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CustomPaint(
              painter: HeaderWavePainter(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: topPadding + 16,
                  left: 18,
                  right: 18,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Glowing 3D Avatar Ring
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.coralOrange, Color(0xFFFF7A50)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.coralOrange.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'N',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Natiraja Prajapati',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: -0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.coralOrange,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'PRO',
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'natirajaprajapati5@gmail.com',
                                style: TextStyle(fontSize: 11, color: Colors.white70),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Property & System Status Badge Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.workspace_premium_rounded, size: 14, color: AppColors.amber),
                          SizedBox(width: 6),
                          Text(
                            'Enterprise Plan • 2 PGs • 46 Beds',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Drawer Navigation Items List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                // 3D Upgrade Banner Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFDBA74)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFDBA74).withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text('👑', style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upgrade to Pro Plus',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.midnightNavy),
                              ),
                              Text(
                                'Unlock automated rent & WhatsApp reminders.',
                                style: TextStyle(fontSize: 10.5, color: AppColors.textSubLight),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ToastUtils.showInfo(context, 'Pro Plus features unlocked! 🎉');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.coralOrange,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('UPGRADE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildSectionHeader('MANAGEMENT'),
                _buildDrawerItem(
                  context: context,
                  emoji: '📊',
                  title: 'Reports & Revenue Analytics',
                  route: AppRoutes.ledger,
                  badgeBg: AppColors.primarySubtle,
                ),
                _buildDrawerItem(
                  context: context,
                  emoji: '💸',
                  title: 'Expenses & Rent Dues',
                  route: AppRoutes.ledger,
                  badgeBg: AppColors.purpleSubtle,
                ),
                _buildDrawerItem(
                  context: context,
                  emoji: '🔧',
                  title: 'Maintenance & Tickets',
                  route: AppRoutes.complaints,
                  badgeBg: AppColors.roseSubtle,
                ),
                const SizedBox(height: 14),

                _buildSectionHeader('SETTINGS'),
                _buildDrawerItem(
                  context: context,
                  emoji: '🏢',
                  title: 'Managed PG Properties',
                  route: AppRoutes.rooms,
                  badgeBg: AppColors.primarySubtle,
                ),
                _buildDrawerItem(
                  context: context,
                  emoji: '👥',
                  title: 'Tenant Directory & KYC',
                  route: AppRoutes.tenants,
                  badgeBg: AppColors.skySubtle,
                ),
                _buildDrawerItem(
                  context: context,
                  emoji: '🧾',
                  title: 'Rent Ledger & Receipts',
                  route: AppRoutes.ledger,
                  badgeBg: AppColors.greenSubtle,
                ),
                _buildDrawerItem(
                  context: context,
                  emoji: '👤',
                  title: 'My Profile & Business',
                  route: AppRoutes.profile,
                  badgeBg: AppColors.amberSubtle,
                ),
                const SizedBox(height: 14),

                _buildSectionHeader('ACCOUNT'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.roseSubtle.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.roseSubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('🚪', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    title: const Text(
                      'Logout Owner Portal',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.rose),
                    ),
                    trailing: const Icon(Icons.logout_rounded, size: 16, color: AppColors.rose),
                    onTap: () {
                      Navigator.pop(context);
                      authViewModel.logout();
                      context.go(AppRoutes.login);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Version Footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: AppColors.bgLight,
            child: const Center(
              child: Text(
                'Tenlord Property v1.0.0 • Enterprise Edition',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textMutedLight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          color: AppColors.textMutedLight,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String emoji,
    required String title,
    required String route,
    required Color badgeBg,
  }) {
    final isSelected = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primarySubtle : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
      ),
      child: ListTile(
        horizontalTitleGap: 12,
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            color: isSelected ? AppColors.midnightNavy : AppColors.textMainLight,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
          color: isSelected ? AppColors.midnightNavy : AppColors.textMutedLight,
        ),
        onTap: () {
          Navigator.pop(context);
          if (!isSelected) {
            context.push(route);
          }
        },
      ),
    );
  }
}

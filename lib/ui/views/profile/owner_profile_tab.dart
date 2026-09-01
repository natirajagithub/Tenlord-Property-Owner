import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/launcher_utils.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/services/storage_service.dart';
import '../../view_models/owner_auth_view_model.dart';

class OwnerProfileScreen extends StatefulWidget {
  final OwnerAuthViewModel authViewModel;
  final bool showBackButton;

  const OwnerProfileScreen({
    super.key,
    required this.authViewModel,
    this.showBackButton = false,
  });

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  Future<void> _navigateToEditProfile() async {
    final updated = await context.push(AppRoutes.editProfile);
    if (updated == true || mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final profile = StorageService.getOwnerProfile();

    final name = profile['name'] ?? 'Natiraja Prajapati';
    final email = profile['email'] ?? 'natirajaprajapati5@gmail.com';
    final phone = profile['phone'] ?? '7489128297';
    final business = profile['business'] ?? 'Shanti Residency PG Group';
    final bank = profile['bank'] ?? 'HDFC Bank';
    final accountNo = profile['accountNo'] ?? '918273644891';
    final upi = profile['upi'] ?? 'dormly@hdfcbank';
    final avatarPath = profile['avatarPath'];

    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'N';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            // Clean Flat Royal Blue Header Bar
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: EdgeInsets.only(
                top: topPadding + 6,
                left: 16,
                right: 16,
                bottom: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.showBackButton)
                        Material(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go(AppRoutes.dashboard);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 4),
                      const Text(
                        'Owner Account Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Material(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: _navigateToEditProfile,
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.edit_note_rounded, size: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Avatar & User Info (Tappable to Edit Profile)
                  GestureDetector(
                    onTap: _navigateToEditProfile,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 74,
                              height: 74,
                              decoration: BoxDecoration(
                                color: AppColors.coralOrange,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: avatarPath != null && avatarPath.isNotEmpty && File(avatarPath).existsSync()
                                    ? Image.file(
                                        File(avatarPath),
                                        fit: BoxFit.cover,
                                        width: 74,
                                        height: 74,
                                      )
                                    : Center(
                                        child: Text(
                                          initial,
                                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primary, width: 1.5),
                                ),
                                child: const Center(
                                  child: Icon(Icons.edit_rounded, size: 12, color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.coralOrange,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'PRO OWNER',
                                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$email • +91 $phone',
                          style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Body Content
            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.bgLight,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enterprise Plan Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFBEB),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(Icons.workspace_premium_outlined, color: Color(0xFFD97706), size: 24),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enterprise Pro Plan Active',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: AppColors.textMainLight,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Auto WhatsApp Reminders & Multi-PG active.',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textSubLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Business & PG Management Section
                      const Text(
                        'BUSINESS & PROPERTY SETTINGS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMutedLight,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _buildProfileTile(
                              icon: Icons.person_outline_rounded,
                              badgeBg: const Color(0xFFEFF6FF),
                              iconColor: AppColors.primary,
                              title: 'Edit Owner Profile Details',
                              subtitle: '$name • $phone',
                              onTap: _navigateToEditProfile,
                            ),
                            const Divider(height: 1, color: AppColors.divider),
                            _buildProfileTile(
                              icon: Icons.apartment_outlined,
                              badgeBg: AppColors.primarySubtle,
                              iconColor: AppColors.primary,
                              title: 'Managed Business Group',
                              subtitle: business,
                              onTap: _navigateToEditProfile,
                            ),
                            const Divider(height: 1, color: AppColors.divider),
                            _buildProfileTile(
                              icon: Icons.account_balance_outlined,
                              badgeBg: AppColors.greenSubtle,
                              iconColor: AppColors.greenDark,
                              title: 'Bank & UPI Settlement Account',
                              subtitle: '$bank (${accountNo.length > 4 ? "****${accountNo.substring(accountNo.length - 4)}" : accountNo}) • $upi',
                              onTap: _navigateToEditProfile,
                            ),
                            const Divider(height: 1, color: AppColors.divider),
                            _buildProfileTile(
                              icon: Icons.engineering_outlined,
                              badgeBg: AppColors.purpleSubtle,
                              iconColor: const Color(0xFF7C3AED),
                              title: 'Maintenance Staff & Wardens (4)',
                              subtitle: 'Warden, Electrician, Plumber, Housekeeping',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Account & Preferences
                      const Text(
                        'PREFERENCES & SECURITY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMutedLight,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _buildProfileTile(
                              icon: Icons.chat_bubble_rounded,
                              badgeBg: const Color(0xFFE8F8F0),
                              iconColor: const Color(0xFF25D366),
                              title: 'WhatsApp Rent Reminders',
                              subtitle: 'Automated 1st & 5th rent reminders ON',
                              onTap: () {
                                ToastUtils.showInfo(context, 'WhatsApp automated reminders active');
                              },
                            ),
                            const Divider(height: 1, color: AppColors.divider),
                            _buildProfileTile(
                              icon: Icons.lock_outline_rounded,
                              badgeBg: AppColors.roseSubtle,
                              iconColor: AppColors.rose,
                              title: 'App Security & Biometric Lock',
                              subtitle: 'Fingerprint & PIN security enabled',
                              onTap: () {
                                ToastUtils.showInfo(context, 'Biometric lock enabled');
                              },
                            ),
                            const Divider(height: 1, color: AppColors.divider),
                            _buildProfileTile(
                              icon: Icons.support_agent_rounded,
                              badgeBg: AppColors.primarySubtle,
                              iconColor: AppColors.primary,
                              title: 'Tenlord Property VIP Support (24x7)',
                              subtitle: 'Dedicated relationship manager active',
                              onTap: () => LauncherUtils.makePhoneCall('7489128297'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Logout Account Tile
                      CustomCard(
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.roseSubtle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(Icons.logout_rounded, color: AppColors.rose, size: 18),
                            ),
                          ),
                          title: const Text(
                            'Logout Owner Portal',
                            style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.rose, fontSize: 13.5),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.rose),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.w800)),
                                content: const Text('Are you sure you want to log out of Tenlord Property Portal?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      widget.authViewModel.logout();
                                      context.go(AppRoutes.login);
                                      ToastUtils.showInfo(context, 'Logged out safely.');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.rose,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required Color badgeBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: badgeBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: 18),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.textMainLight),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11.5, color: AppColors.textMutedLight, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textMutedLight),
    );
  }
}

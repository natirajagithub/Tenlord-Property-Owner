import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? emojiIcon;
  final IconData? icon;
  final Color cardBgColor;
  final Color textColor;
  final Color? accentColor;
  final VoidCallback? onTap;

  const StatSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.emojiIcon,
    this.icon,
    this.cardBgColor = AppColors.primarySubtle,
    this.textColor = AppColors.textMainLight,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final numColor = accentColor ?? AppColors.textMainLight;

    // Standardize badge background to soft pastel light blue (#EEF5FF) matching Quick Actions
    final Color badgeBg = accentColor == AppColors.coralOrange
        ? const Color(0xFFFFF8E7)
        : accentColor == AppColors.green
            ? const Color(0xFFE8F8F0)
            : const Color(0xFFEEF5FF);

    final Color iconColor = accentColor ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Soft Light-Blue Badge matching Quick Actions
            Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: emojiIcon != null
                    ? Text(emojiIcon!, style: const TextStyle(fontSize: 18))
                    : Icon(
                        icon ?? Icons.analytics_rounded,
                        color: iconColor,
                        size: 20,
                      ),
              ),
            ),
            // Centered Bold Numeric Value
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: numColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 1),
            // Centered Label Title
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSubLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

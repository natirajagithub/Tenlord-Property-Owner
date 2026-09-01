import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum BadgeType { success, warning, error, info, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.neutral,
    this.icon,
  });

  factory StatusBadge.fromStatus(String? status) {
    final s = (status ?? '').toLowerCase().trim();
    if (s.contains('resolve') || s.contains('paid') || s.contains('occupied') || s.contains('active') || s.contains('approved') || s.contains('verified')) {
      return StatusBadge(label: status ?? 'Active', type: BadgeType.success, icon: Icons.check_circle_outline);
    }
    if (s.contains('progress') || s.contains('due') || s.contains('pending') || s.contains('vacant') || s.contains('available')) {
      return StatusBadge(label: status ?? 'Pending', type: BadgeType.warning, icon: Icons.access_time);
    }
    if (s.contains('overdue') || s.contains('reject') || s.contains('unpaid') || s.contains('maintenance')) {
      return StatusBadge(label: status ?? 'Overdue', type: BadgeType.error, icon: Icons.error_outline);
    }
    return StatusBadge(label: status ?? 'General', type: BadgeType.neutral);
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case BadgeType.success:
        bg = AppColors.greenSubtle;
        fg = AppColors.green;
        break;
      case BadgeType.warning:
        bg = AppColors.amberSubtle;
        fg = AppColors.amber;
        break;
      case BadgeType.error:
        bg = AppColors.roseSubtle;
        fg = AppColors.rose;
        break;
      case BadgeType.info:
        bg = AppColors.skySubtle;
        fg = AppColors.sky;
        break;
      case BadgeType.neutral:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

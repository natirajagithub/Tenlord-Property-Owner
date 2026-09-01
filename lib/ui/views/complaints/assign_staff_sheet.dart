import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/models/complaint_manage_model.dart';
import '../../../data/models/staff_model.dart';
import '../../view_models/complaints_manage_view_model.dart';

class AssignStaffSheet extends StatefulWidget {
  final ComplaintManageModel complaint;
  final ComplaintsManageViewModel viewModel;

  const AssignStaffSheet({
    super.key,
    required this.complaint,
    required this.viewModel,
  });

  @override
  State<AssignStaffSheet> createState() => _AssignStaffSheetState();
}

class _AssignStaffSheetState extends State<AssignStaffSheet> {
  StaffModel? _selectedStaff;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel.staffList.isNotEmpty) {
      _selectedStaff = widget.viewModel.staffList.first;
    }
  }

  Future<void> _handleAssign() async {
    if (_selectedStaff == null) return;

    final success = await widget.viewModel.assignStaff(
      widget.complaint.id,
      _selectedStaff!.id,
      _selectedStaff!.name,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      ToastUtils.showSuccess(
        context,
        'Assigned ${_selectedStaff!.name} to Ticket #${widget.complaint.id}',
      );
    } else {
      ToastUtils.showError(context, 'Failed to assign staff.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assign Maintenance Staff',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMainLight,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 10),

          // Complaint summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${widget.complaint.id} • Room ${widget.complaint.roomNo} (${widget.complaint.tenantName})',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSubLight),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.complaint.title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Select Available Staff Member',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),

          ...widget.viewModel.staffList.map((staff) {
            final isSelected = _selectedStaff?.id == staff.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedStaff = staff),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primarySubtle : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.borderLight,
                    width: isSelected ? 1.8 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? AppColors.primary : AppColors.textMutedLight,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              staff.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: isSelected ? AppColors.primaryDark : AppColors.textMainLight,
                              ),
                            ),
                            Text(
                              '${staff.role} • ${staff.phone}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSubLight),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),
          CustomButton(
            text: 'Confirm & Assign Staff',
            icon: Icons.person_add_rounded,
            backgroundColor: AppColors.primary,
            onPressed: _handleAssign,
          ),
        ],
      ),
    );
  }
}

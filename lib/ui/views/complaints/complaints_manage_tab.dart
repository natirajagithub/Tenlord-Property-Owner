import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/complaint_manage_model.dart';
import '../../view_models/complaints_manage_view_model.dart';
import 'assign_staff_sheet.dart';

class ComplaintsManageScreen extends StatefulWidget {
  final ComplaintsManageViewModel viewModel;
  final bool showBackButton;

  const ComplaintsManageScreen({
    super.key,
    required this.viewModel,
    this.showBackButton = false,
  });

  @override
  State<ComplaintsManageScreen> createState() => _ComplaintsManageScreenState();
}

class _ComplaintsManageScreenState extends State<ComplaintsManageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAssignModal(ComplaintManageModel complaint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AssignStaffSheet(complaint: complaint, viewModel: widget.viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            if (widget.viewModel.isLoading && widget.viewModel.complaints.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final pending = widget.viewModel.pendingComplaints;
            final resolved = widget.viewModel.resolvedComplaints;

            return Column(
              children: [
                // Clean Flat Royal Blue Header (Safe Status Bar Spacing)
                Container(
                  width: double.infinity,
                  color: AppColors.primary,
                  padding: EdgeInsets.only(
                    top: topPadding + 6,
                    left: 16,
                    right: 16,
                    bottom: 0,
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
                            'Maintenance & Complaints',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          Material(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: widget.viewModel.loadComplaintsAndStaff,
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.refresh_rounded, size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // TabBar Navigation
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        indicatorColor: Colors.white,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        tabs: [
                          Tab(text: 'Pending Action (${pending.length})'),
                          Tab(text: 'Resolved History (${resolved.length})'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable White Body Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: AppColors.bgLight,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        pending.isEmpty
                            ? const Center(child: Text('No pending complaints 🎉'))
                            : ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.only(top: 14, left: 16, right: 16, bottom: 24),
                                itemCount: pending.length,
                                itemBuilder: (ctx, idx) => _buildTicketCard(pending[idx]),
                              ),
                        resolved.isEmpty
                            ? const Center(child: Text('No resolved history.'))
                            : ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.only(top: 14, left: 16, right: 16, bottom: 24),
                                itemCount: resolved.length,
                                itemBuilder: (ctx, idx) => _buildTicketCard(resolved[idx]),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTicketCard(ComplaintManageModel complaint) {
    return CustomCard(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${complaint.id} • Room ${complaint.roomNo} (${complaint.tenantName})',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textSubLight),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              StatusBadge.fromStatus(complaint.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            complaint.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textMainLight),
          ),
          const SizedBox(height: 4),
          Text(
            complaint.description,
            style: const TextStyle(fontSize: 12, color: AppColors.textSubLight, height: 1.4),
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: complaint.assignedStaffName != null
                    ? Row(
                        children: [
                          const Icon(Icons.person_pin_rounded, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              complaint.assignedStaffName!,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Unassigned Staff',
                        style: TextStyle(fontSize: 11.5, color: AppColors.textMutedLight, fontWeight: FontWeight.w600),
                      ),
              ),
              if (complaint.status != 'Resolved')
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _openAssignModal(complaint),
                      icon: const Icon(Icons.person_add, size: 12),
                      label: Text(complaint.assignedStaffName == null ? 'Assign' : 'Reassign'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: () async {
                        final res = await widget.viewModel.resolveTicket(complaint.id);
                        if (mounted && res) {
                          ToastUtils.showSuccess(context, 'Ticket #${complaint.id} marked Resolved!');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenDark,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                      child: const Text('Resolve', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/launcher_utils.dart';
import '../../../core/widgets/whatsapp_icon.dart';
import '../../../data/models/tenant_manage_model.dart';
import '../../view_models/tenants_view_model.dart';

class TenantsScreen extends StatefulWidget {
  final TenantsViewModel viewModel;
  final bool showBackButton;

  const TenantsScreen({
    super.key,
    required this.viewModel,
    this.showBackButton = false,
  });

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  String _selectedFilter = 'All';
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openOnboardWizard(BuildContext context) {
    context.push(AppRoutes.addTenant);
  }

  List<TenantManageModel> _getFilteredTenants(List<TenantManageModel> allTenants) {
    if (_selectedFilter == 'All') return allTenants;
    if (_selectedFilter == 'Active') {
      return allTenants.where((t) {
        final st = t.paymentStatus.toLowerCase();
        return st == 'paid' || st == 'active';
      }).toList();
    }
    if (_selectedFilter == 'Due') {
      return allTenants.where((t) {
        final st = t.paymentStatus.toLowerCase();
        return st == 'due' || st == 'overdue';
      }).toList();
    }
    if (_selectedFilter == 'Notice') {
      return allTenants.where((t) => t.paymentStatus.toLowerCase() == 'notice').toList();
    }
    if (_selectedFilter == 'Moved Out') {
      return allTenants.where((t) => t.paymentStatus.toLowerCase() == 'moved out').toList();
    }
    return allTenants;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'T';
  }

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

        // Icon-Only Circular Floating Action Button
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab_tenants',
          onPressed: () => _openOnboardWizard(context),
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.person_add_alt_1_rounded, size: 24, color: Colors.white),
        ),
        body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            if (widget.viewModel.isLoading && widget.viewModel.tenants.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            final allTenants = widget.viewModel.filteredTenants;
            final displayedTenants = _getFilteredTenants(allTenants);

            final allCount = allTenants.length;
            final activeCount = allTenants.where((t) {
              final st = t.paymentStatus.toLowerCase();
              return st == 'paid' || st == 'active';
            }).length;
            final dueCount = allTenants.where((t) {
              final st = t.paymentStatus.toLowerCase();
              return st == 'due' || st == 'overdue';
            }).length;
            final noticeCount = allTenants.where((t) => t.paymentStatus.toLowerCase() == 'notice').length;
            final movedOutCount = allTenants.where((t) => t.paymentStatus.toLowerCase() == 'moved out').length;

            return SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 1. Sleek Seamless Native App Header Bar
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
                        Row(
                          children: [
                            if (widget.showBackButton)
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
                                  margin: const EdgeInsets.only(right: 12),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Tenants Directory',
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF0F172A),
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$allCount Total Tenants Registered',
                                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Search Button Tile
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSearchOpen = !_isSearchOpen;
                                  if (!_isSearchOpen) {
                                    _searchController.clear();
                                    widget.viewModel.setSearchQuery('');
                                  }
                                });
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Center(
                                  child: Icon(
                                    _isSearchOpen ? Icons.close_rounded : Icons.search_rounded,
                                    size: 18,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Notification Bell Tile
                            GestureDetector(
                              onTap: () => context.push(AppRoutes.notifications),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFBFDBFE)),
                                ),
                                child: Center(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const Icon(Icons.notifications_none_rounded, size: 18, color: AppColors.primary),
                                      Positioned(
                                        right: -1,
                                        top: -1,
                                        child: Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFEF4444),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Search Field Animation
                  AnimatedCrossFade(
                    firstChild: const SizedBox(width: double.infinity, height: 0),
                    secondChild: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: widget.viewModel.setSearchQuery,
                          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w700),
                          decoration: const InputDecoration(
                            hintText: 'Search tenant name, room # or mobile...',
                            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w400),
                            prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    crossFadeState: _isSearchOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),

                  // 2. Segmented Pill Filter Bar (Ultra Sleek iOS / Material 3 Style)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildSegmentedFilterPill('All', allCount),
                            _buildSegmentedFilterPill('Active', activeCount),
                            _buildSegmentedFilterPill('Due', dueCount),
                            _buildSegmentedFilterPill('Notice', noticeCount),
                            _buildSegmentedFilterPill('Moved Out', movedOutCount),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Clean & Modern Minimal Tenant Cards List
                  Expanded(
                    child: displayedTenants.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 85),
                            itemCount: displayedTenants.length,
                            itemBuilder: (ctx, idx) {
                              final t = displayedTenants[idx];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFF1F5F9)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    onTap: () {
                                      context.push(AppRoutes.tenantDetails, extra: {
                                        'name': t.name,
                                        'roomNo': t.roomNo,
                                        'property': 'Sunrise Apartments',
                                        'phone': '7489128297',
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                           // Clean Soft Blue Avatar with Name Initials
                                           Container(
                                             width: 44,
                                             height: 44,
                                             decoration: BoxDecoration(
                                               color: const Color(0xFFEFF6FF),
                                               borderRadius: BorderRadius.circular(14),
                                               border: Border.all(color: const Color(0xFFBFDBFE)),
                                             ),
                                             child: Center(
                                               child: Text(
                                                 _getInitials(t.name),
                                                 style: const TextStyle(
                                                   color: AppColors.primary,
                                                   fontWeight: FontWeight.w900,
                                                   fontSize: 15,
                                                   letterSpacing: 0.5,
                                                 ),
                                               ),
                                             ),
                                           ),
                                          const SizedBox(width: 12),

                                          // Tenant Main Info Column
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  t.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15,
                                                    color: Color(0xFF0F172A),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  'Room ${t.roomNo} (${t.bedNo}) • Sunrise Apartments',
                                                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                const Text(
                                                  '+91 98765 43210',
                                                  style: TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 6),

                                          // Status Tag + Action Buttons (Call & WhatsApp)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFECFDF5),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Text(
                                                  'Active',
                                                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  // Phone Call Button Tile
                                                  GestureDetector(
                                                    onTap: () => LauncherUtils.makePhoneCall('7489128297'),
                                                    child: Container(
                                                      width: 32,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFEFF6FF),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(Icons.phone_rounded, size: 15, color: AppColors.primary),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),

                                                  // WhatsApp Button Tile with whatsapp.png
                                                  GestureDetector(
                                                    onTap: () => LauncherUtils.launchWhatsApp(
                                                      tenantName: t.name,
                                                      roomNo: t.roomNo,
                                                      monthlyRent: t.monthlyRent,
                                                      phone: '7489128297',
                                                    ),
                                                    child: Container(
                                                      width: 32,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFECFDF5),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: const Center(
                                                        child: WhatsAppIcon(size: 16),
                                                      ),
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
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Segmented Control Style Filter Pill Widget
  Widget _buildSegmentedFilterPill(String filter, int count) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              filter,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.primary : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: isSelected ? AppColors.primary : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF5FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(Icons.people_alt_outlined, color: AppColors.primary, size: 32),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No Tenants Yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textMainLight),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap the + button below to add your first tenant',
            style: TextStyle(fontSize: 12, color: AppColors.textSubLight),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/header_wave_painter.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/room_model.dart';
import '../../view_models/properties_view_model.dart';
import 'add_property_sheet.dart';

class PropertyUnitDetailsScreen extends StatefulWidget {
  final PropertiesViewModel viewModel;
  final String propertyName;
  final String imageUrl;

  const PropertyUnitDetailsScreen({
    super.key,
    required this.viewModel,
    this.propertyName = 'Green View Student Hostel',
    this.imageUrl = 'assets/property1.png',
  });

  @override
  State<PropertyUnitDetailsScreen> createState() => _PropertyUnitDetailsScreenState();
}

class _PropertyUnitDetailsScreenState extends State<PropertyUnitDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bool _isGridView = false; // Always List View per user directive

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddUnitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddPropertySheet(),
    );
  }

  void _showRoomDetailsModal(BuildContext context, RoomModel room) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Room ${room.roomNo} Details',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  StatusBadge(
                    label: room.isAc ? 'AC Room ❄️' : 'Non-AC 🍃',
                    type: room.isAc ? BadgeType.info : BadgeType.neutral,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Floor ${room.floorNo} • ${room.roomType} • ${Formatters.currency(room.monthlyRent)}/mo',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              const Divider(color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),
              const Text(
                'Allocated Beds & Tenants',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),
              ...room.beds.map((bed) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: bed.status == 'Occupied' ? const Color(0xFFEFF6FF) : const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            bed.status == 'Occupied' ? Icons.person_outline_rounded : Icons.single_bed_outlined,
                            color: bed.status == 'Occupied' ? AppColors.primary : const Color(0xFF10B981),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bed.bedNo,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                            ),
                            Text(
                              bed.tenantName ?? 'Vacant Bed Available',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: bed.tenantName != null ? const Color(0xFF0F172A) : const Color(0xFF10B981),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      StatusBadge.fromStatus(bed.status),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 14),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: Text(
          widget.propertyName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.borderLight, width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: 1, // Properties is tab 1
          onTap: (idx) {
            if (idx == 1) return;
            context.pop(); // Go back to dashboard to handle other tabs
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMutedLight,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 22), activeIcon: Icon(Icons.home_rounded, size: 22), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.domain_outlined, size: 22), activeIcon: Icon(Icons.domain_rounded, size: 22), label: 'Properties'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded, size: 22), activeIcon: Icon(Icons.people_rounded, size: 22), label: 'Tenants'),
            BottomNavigationBarItem(icon: Icon(Icons.monetization_on_outlined, size: 22), activeIcon: Icon(Icons.monetization_on_rounded, size: 22), label: 'Rent'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded, size: 22), activeIcon: Icon(Icons.person_rounded, size: 22), label: 'Profile'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final rooms = widget.viewModel.rooms;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Container
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(
                          children: [
                            Container(
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: widget.imageUrl.startsWith('http')
                                      ? NetworkImage(widget.imageUrl) as ImageProvider
                                      : AssetImage(widget.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Active',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title & Address
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '${widget.propertyName} (Hostel)',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'MG Road, Indore, Madhya Pradesh',
                          style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Info Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.business_outlined, size: 16, color: Colors.black54),
                            const SizedBox(width: 6),
                            const Text(
                              '3 Floors • 24 Rooms • 52 Beds',
                              style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildActionButton(Icons.share_outlined, 'Share Link'),
                            _buildActionButton(Icons.people_outline, 'Employees'),
                            _buildActionButton(Icons.restaurant_menu_outlined, 'Mess Menu'),
                            _buildActionButton(Icons.edit_outlined, 'Edit Property'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // TabBar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: Colors.black54,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          indicatorColor: AppColors.primary,
                          indicatorSize: TabBarIndicatorSize.label,
                          dividerColor: const Color(0xFFF1F5F9),
                          tabAlignment: TabAlignment.start,
                          padding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.only(right: 24),
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Rooms & Beds'),
                            Tab(text: 'Tenants'),
                            Tab(text: 'Finance'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // TabBar View content inside ScrollView
                      IndexedStack(
                        index: _tabController.index,
                        children: [
                          _buildNewOverviewTab(),
                          _buildUnitsTab(context, rooms), // Existing Units tab
                          _buildTenantsTab(context, rooms), // Existing Tenants tab
                          const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('Finance Data', style: TextStyle(color: Colors.black54)))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildNewOverviewTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Property Overview',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          // 4-item grid
          Row(
            children: [
              Expanded(child: _buildOverviewMetric('Total Beds', '52')),
              const SizedBox(width: 8),
              Expanded(child: _buildOverviewMetric('Occupied Beds', '38')),
              const SizedBox(width: 8),
              Expanded(child: _buildOverviewMetric('Available Beds', '14')),
              const SizedBox(width: 8),
              Expanded(child: _buildOverviewMetric('Occupancy', '73%')),
            ],
          ),
          const SizedBox(height: 12),
          // 2-item grid
          Row(
            children: [
              Expanded(child: _buildOverviewMetric('Monthly Rent', '₹2,63,500')),
              const SizedBox(width: 12),
              Expanded(child: _buildOverviewMetric('Pending Rent', '₹74,500')),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOverviewMetric(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.black54, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // --- Units Tab Content ---
  Widget _buildUnitsTab(BuildContext context, List<RoomModel> rooms) {
    return rooms.isEmpty
        ? _buildEmptyState(context)
        : _isGridView
            ? _buildUnitsGridView(context, rooms)
            : _buildUnitsListView(context, rooms);
  }

  // --- 2-Column Grid View (Ultra Spacious, Modern Pure White Cards) ---
  Widget _buildUnitsGridView(BuildContext context, List<RoomModel> rooms) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.96, // Taller vertical height for maximum breathing room
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: rooms.length,
      itemBuilder: (ctx, idx) {
        final room = rooms[idx];
        final occupiedBeds = room.beds.where((b) => b.status == 'Occupied').length;
        final totalBeds = room.beds.length;
        final isFull = occupiedBeds == totalBeds;
        final vacantBeds = totalBeds - occupiedBeds;

        return GestureDetector(
          onTap: () => _showRoomDetailsModal(context, room),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFull ? const Color(0xFFF1F5F9) : const Color(0xFF10B981),
                width: isFull ? 1.0 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Unit Tile + Status Pill Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isFull ? const Color(0xFFEFF6FF) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        room.roomNo,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: isFull ? AppColors.primary : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isFull ? const Color(0xFFF1F5F9) : const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isFull ? 'Full' : '$vacantBeds Vacant',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: isFull ? const Color(0xFF64748B) : const Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),

                // Middle Content: Sharing Type + AC Tag
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Floor ${room.floorNo}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      room.roomType,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w800),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: room.isAc ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: room.isAc ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            room.isAc ? '❄️ AC' : '🍃 Non-AC',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: room.isAc ? AppColors.primary : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Bottom Row: Monthly Rent
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${Formatters.currency(room.monthlyRent)}/mo',
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 1-Column List View (Full Width Ultra-Sleek Row Card) ---
  Widget _buildUnitsListView(BuildContext context, List<RoomModel> rooms) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 24),
      itemCount: rooms.length,
      itemBuilder: (ctx, idx) {
        final room = rooms[idx];
        final occupiedBeds = room.beds.where((b) => b.status == 'Occupied').length;
        final totalBeds = room.beds.length;
        final isFull = occupiedBeds == totalBeds;
        return GestureDetector(
          onTap: () => _showRoomDetailsModal(context, room),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isFull ? const Color(0xFFF1F5F9) : const Color(0xFF10B981),
                width: isFull ? 1.0 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isFull ? const Color(0xFFF8FAFC) : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isFull ? const Color(0xFFE2E8F0) : const Color(0xFFBBF7D0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            room.roomNo,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isFull ? const Color(0xFF334155) : const Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: room.isAc ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(room.isAc ? Icons.ac_unit_rounded : Icons.eco_rounded, 
                               size: 10, color: room.isAc ? AppColors.primary : const Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(room.isAc ? 'AC' : 'Non-AC', 
                               style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: room.isAc ? AppColors.primary : const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Floor ${room.floorNo} • ${room.roomType}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '$occupiedBeds/$totalBeds Filled',
                            style: TextStyle(
                              fontSize: 11, 
                              fontWeight: FontWeight.w700,
                              color: isFull ? const Color(0xFF64748B) : const Color(0xFF10B981)
                            )
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: room.beds.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final bed = entry.value;
                            final isBedOccupied = bed.status == 'Occupied';
                            final isLast = idx == room.beds.length - 1;

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: isBedOccupied ? const Color(0xFFEFF6FF) : const Color(0xFFDCFCE7),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            isBedOccupied ? Icons.person_rounded : Icons.single_bed_rounded,
                                            size: 16,
                                            color: isBedOccupied ? AppColors.primary : const Color(0xFF15803D),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Bed ${bed.bedNo}',
                                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              isBedOccupied ? (bed.tenantName ?? 'Occupied') : 'Available',
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w600,
                                                color: isBedOccupied ? const Color(0xFF64748B) : const Color(0xFF10B981),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${Formatters.currency(room.monthlyRent)}/mo',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isLast)
                                  const Divider(height: 1, color: Color(0xFFE2E8F0), indent: 56, endIndent: 12),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTenantsTab(BuildContext context, List<RoomModel> rooms) {
    final occupiedData = rooms.expand((r) {
      return r.beds.where((b) => b.status == 'Occupied').map((b) => {'room': r, 'bed': b});
    }).toList();

    return occupiedData.isEmpty
        ? const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('No active tenants assigned to units.')))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: occupiedData.length,
            itemBuilder: (ctx, idx) {
              final data = occupiedData[idx];
              final room = data['room'] as RoomModel;
              final bed = data['bed'] as dynamic;
              
              return GestureDetector(
                onTap: () {
                  context.push(AppRoutes.tenantDetails, extra: {
                    'name': bed.tenantName,
                    'roomNo': room.roomNo,
                    'property': widget.propertyName,
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
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
                      CircleAvatar(
                        backgroundColor: const Color(0xFFEFF6FF),
                        child: Text(
                          bed.tenantName != null && bed.tenantName!.isNotEmpty ? bed.tenantName![0] : 'T',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bed.tenantName ?? 'Tenant', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
                            const SizedBox(height: 2),
                            Text('Room ${room.roomNo} • Bed ${bed.bedNo}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      const StatusBadge(label: 'Active', type: BadgeType.success),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildOverviewTab(BuildContext context, int totalUnits, int occupied, int vacant, int tenants) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildOverviewCard('Occupancy Ratio', '$occupied / $totalUnits Units Filled', AppColors.primary),
          const SizedBox(height: 10),
          _buildOverviewCard('Total Active Tenants', '$tenants Registered Tenants', const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title, String subtitle, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.meeting_room_outlined, size: 48, color: Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          const Text('No Units Found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Tap + Floating Action Button to create rooms.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}

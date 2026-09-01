import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/launcher_utils.dart';
import '../../../core/widgets/whatsapp_icon.dart';
import '../../view_models/rent_ledger_view_model.dart';
import 'collect_rent_sheet.dart';

class RentLedgerScreen extends StatefulWidget {
  final RentLedgerViewModel viewModel;
  final bool showBackButton;

  const RentLedgerScreen({
    super.key,
    required this.viewModel,
    this.showBackButton = false,
  });

  @override
  State<RentLedgerScreen> createState() => _RentLedgerScreenState();
}

class _RentLedgerScreenState extends State<RentLedgerScreen> {
  int _mainTab = 1; // 0: Monthly, 1: All Invoices
  int _selectedFilterIndex = 0; // 0: All, 1: Pending, 2: Partial, 3: Paid, 4: Overdue

  String _selectedRangeLabel = 'Aug 2026';
  DateTime _fromDate = DateTime(2026, 1, 1);
  DateTime _toDate = DateTime(2026, 8, 23);
  final int _selectedYear = 2026;

  final List<String> _months = [
    'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
    'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
  ];
  int _selectedMonthIdx = 7; // August

  void _openCollectModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CollectRentSheet(viewModel: widget.viewModel),
    );
  }

  void _showDateRangePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        DateTime tempFrom = _fromDate;
        DateTime tempTo = _toDate;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Date Range',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'From Date',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempFrom,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setSheetState(() => tempFrom = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Formatters.date(tempFrom.toIso8601String()),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                          ),
                          const Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'To Date',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempTo,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setSheetState(() => tempTo = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Formatters.date(tempTo.toIso8601String()),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                          ),
                          const Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _fromDate = tempFrom;
                              _toDate = tempTo;
                              _selectedRangeLabel = 'Custom Range';
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
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
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab_ledger',
          onPressed: () => _openCollectModal(context),
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 26, color: Colors.white),
        ),
        body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            if (widget.viewModel.isLoading && widget.viewModel.ledger.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            final receipts = widget.viewModel.ledger;

            return SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 1. Clean Compact App Header & Date Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Top Title Row
                        Row(
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
                                          'Billing',
                                          style: TextStyle(
                                            fontSize: 20,
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
                                      '${receipts.length} Active Records',
                                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Right Quick Action Icons (Date Range Sheet & Sort)
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _showDateRangePickerSheet(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFBFDBFE)),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.calendar_month_rounded, size: 14, color: AppColors.primary),
                                        SizedBox(width: 4),
                                        Text(
                                          'Range',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: const Icon(Icons.swap_vert_rounded, size: 16, color: Color(0xFF0F172A)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Date Filter Pills Bar (Horizontal Scrollable, Fits Perfectly, Zero Overflow!)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildHeaderPill(_selectedRangeLabel, isSelected: true, onTap: () {}),
                              const SizedBox(width: 6),
                              _buildHeaderPill('This Year', isSelected: false, onTap: () {
                                setState(() {
                                  _selectedRangeLabel = 'This Year';
                                });
                              }),
                              const SizedBox(width: 6),
                              _buildHeaderPill('Monthly View', isSelected: false, onTap: () {
                                setState(() {
                                  _mainTab = 0;
                                });
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Compact Billing Summary Bar (Single Card, Sleek Height)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.pendingRentOverview),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFEEF0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.account_balance_wallet_rounded, color: Color(0xFFEF4444), size: 18),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Total Pending Amount',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                                      ),
                                      Text(
                                        '₹54,500',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFEF4444)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '8 Tenants',
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMiniStat('Overdue', '₹42,000', const Color(0xFFF97316)),
                                Container(width: 1, height: 16, color: const Color(0xFFE2E8F0)),
                                _buildMiniStat('Maintenance', '₹8,000', const Color(0xFF10B981)),
                                Container(width: 1, height: 16, color: const Color(0xFFE2E8F0)),
                                _buildMiniStat('Electricity', '₹4,500', const Color(0xFFEAB308)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                  // 3. 2 Main Sub-Tabs Navigation (Monthly | All Invoices)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.0)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _mainTab = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _mainTab == 0 ? AppColors.primary : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Monthly',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: _mainTab == 0 ? FontWeight.w900 : FontWeight.w600,
                                    color: _mainTab == 0 ? AppColors.primary : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _mainTab = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _mainTab == 1 ? AppColors.primary : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'All Invoices',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: _mainTab == 1 ? FontWeight.w900 : FontWeight.w600,
                                    color: _mainTab == 1 ? AppColors.primary : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4. Main Tab Content Area
                  Expanded(
                    child: _mainTab == 0
                        ? _buildMonthlyTabView()
                        : _buildAllInvoicesTabView(receipts),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        const SizedBox(height: 1),
        Text(value, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }

  Widget _buildHeaderPill(String label, {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyTabView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                onPressed: () {
                  setState(() {
                    if (_selectedMonthIdx > 0) _selectedMonthIdx--;
                  });
                },
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    '$_selectedYear',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                  ),
                  Text(
                    _months[_selectedMonthIdx],
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: 0.5),
                  ),
                  const Text(
                    'No bills yet',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
                onPressed: () {
                  setState(() {
                    if (_selectedMonthIdx < 11) _selectedMonthIdx++;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.people_alt_rounded, size: 32, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'No Active Tenants',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Add tenants and generate monthly invoices from dashboard',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllInvoicesTabView(List receipts) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPillItem(0, 'All'),
                _buildFilterPillItem(1, 'Pending'),
                _buildFilterPillItem(2, 'Partial'),
                _buildFilterPillItem(3, 'Paid'),
                _buildFilterPillItem(4, 'Overdue'),
              ],
            ),
          ),
        ),
        Expanded(
          child: receipts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.description_outlined, size: 32, color: Color(0xFF64748B)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'No Bills',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Generate monthly invoices from dashboard',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: receipts.length,
                  itemBuilder: (ctx, idx) {
                    final r = receipts[idx];
                    return GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.pendingRentDetails, extra: {
                          'tenantName': r.tenantName,
                          'roomNo': r.roomNo,
                          'property': 'Shanti Residency • 1st Floor',
                          'totalDue': Formatters.currency(r.amount + 2200),
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0B1E46).withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3E8FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      r.roomNo,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF7C3AED)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.tenantName,
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.2),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Shanti Residency • Floor 1',
                                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // WhatsApp Action Button
                                GestureDetector(
                                  onTap: () {
                                    LauncherUtils.launchWhatsApp(
                                      tenantName: r.tenantName,
                                      roomNo: r.roomNo,
                                      monthlyRent: r.amount + 2200,
                                      phone: '7489128297',
                                    );
                                  },
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: const Center(child: WhatsAppIcon(size: 20)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Phone Call Action Button
                                GestureDetector(
                                  onTap: () => LauncherUtils.makePhoneCall('7489128297'),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.phone_rounded, size: 18, color: Color(0xFF2563EB)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildFeeColumn('Rent', Formatters.currency(r.amount)),
                                  _buildFeeColumn('Maintenance', '₹1,000'),
                                  _buildFeeColumn('Electricity', '₹1,200'),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1F2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Overdue',
                                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFFEF4444)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Due Date: 5 May 2024',
                                  style: TextStyle(fontSize: 11.5, color: AppColors.textSubLight, fontWeight: FontWeight.w600),
                                ),
                                Expanded(
                                  child: Text(
                                    'Total Due: ${Formatters.currency(r.amount + 2200)}',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFEF4444)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterPillItem(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
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
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeeColumn(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textSubLight, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(amount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textMainLight)),
      ],
    );
  }
}

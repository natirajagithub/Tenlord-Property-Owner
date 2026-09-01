import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../view_models/owner_auth_view_model.dart';
import '../view_models/owner_dashboard_view_model.dart';
import '../view_models/properties_view_model.dart';
import '../view_models/tenants_view_model.dart';
import '../view_models/rent_ledger_view_model.dart';
import '../view_models/complaints_manage_view_model.dart';
import 'dashboard/owner_dashboard_tab.dart';
import 'ledger/rent_ledger_tab.dart';
import 'tenants/tenants_tab.dart';
import 'properties/properties_tab.dart';
import 'profile/owner_profile_tab.dart';
import 'complaints/complaints_manage_tab.dart';

class OwnerMainNavigationScreen extends StatefulWidget {
  final OwnerDashboardViewModel dashboardViewModel;
  final TenantsViewModel tenantsViewModel;
  final RentLedgerViewModel ledgerViewModel;
  final ComplaintsManageViewModel complaintsViewModel;
  final PropertiesViewModel propertiesViewModel;
  final OwnerAuthViewModel authViewModel;

  const OwnerMainNavigationScreen({
    super.key,
    required this.dashboardViewModel,
    required this.tenantsViewModel,
    required this.ledgerViewModel,
    required this.complaintsViewModel,
    required this.propertiesViewModel,
    required this.authViewModel,
  });

  @override
  State<OwnerMainNavigationScreen> createState() => _OwnerMainNavigationScreenState();
}

class _OwnerMainNavigationScreenState extends State<OwnerMainNavigationScreen> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 6 Tab Views (Home, Properties, Tenants, Rent, More/Profile, Maintenance)
    final List<Widget> tabViews = [
      OwnerDashboardTab(
        viewModel: widget.dashboardViewModel,
        tenantsViewModel: widget.tenantsViewModel,
        ledgerViewModel: widget.ledgerViewModel,
        complaintsViewModel: widget.complaintsViewModel,
        authViewModel: widget.authViewModel,
        onNavigateTab: _switchTab,
      ),
      PropertiesScreen(viewModel: widget.propertiesViewModel, showBackButton: false),
      TenantsScreen(viewModel: widget.tenantsViewModel, showBackButton: false),
      RentLedgerScreen(viewModel: widget.ledgerViewModel, showBackButton: false),
      OwnerProfileScreen(authViewModel: widget.authViewModel, showBackButton: false),
      ComplaintsManageScreen(viewModel: widget.complaintsViewModel, showBackButton: false),
    ];

    // Determine bottom nav active index
    final int navBarIndex = _currentIndex > 4 ? 4 : _currentIndex;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabViews,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.borderLight, width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: navBarIndex,
          onTap: (idx) {
            setState(() {
              _currentIndex = idx;
            });
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 22),
              activeIcon: Icon(Icons.home_rounded, size: 22),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.domain_outlined, size: 22),
              activeIcon: Icon(Icons.domain_rounded, size: 22),
              label: 'Properties',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded, size: 22),
              activeIcon: Icon(Icons.people_rounded, size: 22),
              label: 'Tenants',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined, size: 22),
              activeIcon: Icon(Icons.monetization_on_rounded, size: 22),
              label: 'Rent',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded, size: 22),
              activeIcon: Icon(Icons.person_rounded, size: 22),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

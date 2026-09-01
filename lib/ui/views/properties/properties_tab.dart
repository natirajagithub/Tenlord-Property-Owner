import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/property_model.dart';
import '../../view_models/properties_view_model.dart';

class PropertiesScreen extends StatelessWidget {
  final PropertiesViewModel viewModel;
  final bool showBackButton;

  const PropertiesScreen({
    super.key,
    required this.viewModel,
    this.showBackButton = false,
  });

  void _openPropertyUnits(BuildContext context, String propertyName) {
    context.push(AppRoutes.propertyUnits, extra: {'propertyName': propertyName});
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

        // Circular Icon-Only FloatingActionButton
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab_properties',
          onPressed: () => context.push(AppRoutes.addProperty),
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 26, color: Colors.white),
        ),
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            if (viewModel.isLoading && viewModel.properties.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            final properties = viewModel.properties.isEmpty
                ? [
                    PropertyModel(
                      id: 1,
                      name: 'Shanti Residency',
                      address: 'MG Road, Indore, Madhya Pradesh',
                      city: 'Indore',
                      totalFloors: 3,
                      totalRooms: 16,
                      totalBeds: 24,
                      occupiedBeds: 20,
                      wardenName: 'Suresh Kumar',
                      wardenPhone: '7489128297',
                    ),
                    PropertyModel(
                      id: 2,
                      name: 'Green View Apartments',
                      address: 'Palasia, Indore, Madhya Pradesh',
                      city: 'Indore',
                      totalFloors: 4,
                      totalRooms: 20,
                      totalBeds: 30,
                      occupiedBeds: 25,
                      wardenName: 'Ramesh Singh',
                      wardenPhone: '9876543210',
                    ),
                  ]
                : viewModel.properties;

            return SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Sleek Seamless Native App Header Bar
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
                            if (showBackButton)
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
                                      'Properties Directory',
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
                                  '${properties.length} Properties Managed',
                                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                  ),

                  // Property Cards List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, left: 18, right: 18, bottom: 85),
                      itemCount: properties.length,
                      itemBuilder: (ctx, idx) {
                        final p = properties[idx];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.apartment_rounded, color: AppColors.primary, size: 30),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                p.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 16,
                                                  color: Color(0xFF0F172A),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFECFDF5),
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: const Color(0xFFA7F3D0)),
                                              ),
                                              child: const Text(
                                                'Active',
                                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          p.address,
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${p.totalFloors} Floors • ${p.totalRooms} Rooms & ${p.totalFloors} Flats',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A), fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Amenities Pills Strip
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _buildAmenityPill('WiFi', Icons.wifi_rounded),
                                  _buildAmenityPill('Borewell Water', Icons.water_drop_rounded),
                                  _buildAmenityPill('Parking', Icons.directions_car_rounded),
                                  _buildAmenityPill('RO Water', Icons.local_drink_rounded),
                                ],
                              ),
                              const SizedBox(height: 14),

                              const Divider(color: Color(0xFFF1F5F9), height: 1),
                              const SizedBox(height: 12),

                              // View Property Link Button
                              Center(
                                child: GestureDetector(
                                  onTap: () => _openPropertyUnits(context, p.name),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'View Property Details',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildAmenityPill(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF64748B)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

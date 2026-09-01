import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class FloorModel {
  String code;
  String name;
  int units;
  Color bg;
  Color fg;

  FloorModel({
    required this.code,
    required this.name,
    required this.units,
    required this.bg,
    required this.fg,
  });
}

class UnitModel {
  String flatNo;
  String type;
  num monthlyRent;
  num securityDeposit;
  num maintenance;
  String furnishing;
  String availableFrom;
  Map<String, bool> specialAmenities;

  UnitModel({
    required this.flatNo,
    required this.type,
    this.monthlyRent = 18000,
    this.securityDeposit = 30000,
    this.maintenance = 1000,
    this.furnishing = 'Fully Furnished',
    this.availableFrom = '20 May 2024',
    Map<String, bool>? specialAmenities,
  }) : specialAmenities = specialAmenities ?? {
          'Modular Kitchen': true,
          'Balcony': true,
          'Lift Access': true,
          'Wardrobe': true,
          'Study Table': false,
          'RO Water': true,
          'Private Parking': true,
        };
}

class HostelRoomModel {
  String roomNo;
  int beds;

  HostelRoomModel({
    required this.roomNo,
    required this.beds,
  });
}

class AddPropertyScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const AddPropertyScreen({
    super.key,
    this.initialData,
  });

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  int _currentStep = 0;
  String _selectedPropertyType = 'Apartment';
  String _selectedFloorName = '1st Floor';
  bool _isEditingFloor = false;

  // Step 1 Controllers (Property Details)
  final _propertyNameController = TextEditingController(text: 'Green View Apartments');
  final _addressController = TextEditingController(text: 'Palasia, Indore, MP');
  final List<String> _propertyPhotos = [
    'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600',
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600',
    'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=600',
  ];

  // Step 2 Controllers (Common Amenities)
  final Set<String> _selectedAmenities = {'WiFi', 'RO Water', 'Geyser', 'Washing Machine', 'Locker', 'Power Backup', 'CCTV', 'Lift'};

  // Hostel/PG Step Controllers
  late Map<String, int> _floorRoomsMap;
  int _bedsPerRoom = 2;
  final _monthlyRentController = TextEditingController(text: '5000');
  final _securityDepositController = TextEditingController(text: '10000');

  final List<HostelRoomModel> _hostelRoomsList = [
    HostelRoomModel(roomNo: '101', beds: 2),
    HostelRoomModel(roomNo: '102', beds: 2),
    HostelRoomModel(roomNo: '103', beds: 3),
    HostelRoomModel(roomNo: '104', beds: 2),
    HostelRoomModel(roomNo: '105', beds: 2),
    HostelRoomModel(roomNo: '106', beds: 2),
  ];

  // ================= REAL APARTMENT FLOW STATE (Screens 8 - 12) =================
  String _aptUnitType = 'Flat';
  String _aptFlatType = '2 BHK';
  String _aptFurnishing = 'Fully Furnished';
  String _aptElectricityType = 'Fixed Cost';
  final _aptFlatNoController = TextEditingController(text: '101');
  final _aptRentController = TextEditingController(text: '18,000');
  final _aptSecurityController = TextEditingController(text: '30,000');
  final _aptMaintenanceController = TextEditingController(text: '1,000');
  final _aptFixedElectricityController = TextEditingController(text: '1500');
  final _aptMeterRateController = TextEditingController(text: '8');
  String _aptAvailableDate = '20 May 2024';

  final List<FloorModel> _aptFloorsList = [
    FloorModel(code: 'G', name: 'Ground Floor', units: 2, bg: const Color(0xFFEFF6FF), fg: const Color(0xFF2563EB)),
    FloorModel(code: '1', name: '1st Floor', units: 3, bg: const Color(0xFFDCFCE7), fg: const Color(0xFF16A34A)),
    FloorModel(code: '2', name: '2nd Floor', units: 3, bg: const Color(0xFFF3E8FF), fg: const Color(0xFF7C3AED)),
    FloorModel(code: '3', name: '3rd Floor', units: 3, bg: const Color(0xFFFEF3C7), fg: const Color(0xFFD97706)),
    FloorModel(code: '4', name: '4th Floor', units: 2, bg: const Color(0xFFFCE7F3), fg: const Color(0xFFDB2777)),
  ];

  final List<UnitModel> _aptUnitsList = [
    UnitModel(flatNo: '101', type: '2 BHK'),
    UnitModel(flatNo: '102', type: '1 BHK'),
    UnitModel(flatNo: '103', type: '3 BHK'),
  ];

  final Map<String, bool> _aptSpecialAmenities = {
    'Modular Kitchen': true,
    'Balcony': true,
    'Lift Access': true,
    'Wardrobe': true,
    'Study Table': false,
    'RO Water': true,
    'Private Parking': true,
  };

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initFloorRoomsMap();
  }

  void _initFloorRoomsMap() {
    _floorRoomsMap = {
      'Ground Floor': 4,
      '1st Floor': 6,
      '2nd Floor': 6,
      '3rd Floor': 4,
    };
  }

  @override
  void dispose() {
    _propertyNameController.dispose();
    _addressController.dispose();
    _monthlyRentController.dispose();
    _securityDepositController.dispose();

    _aptFlatNoController.dispose();
    _aptRentController.dispose();
    _aptSecurityController.dispose();
    _aptMaintenanceController.dispose();
    _aptFixedElectricityController.dispose();
    _aptMeterRateController.dispose();
    super.dispose();
  }

  // ================= REAL INTERACTIVE DIALOGS & HANDLERS =================

  // 1. Photo Picker
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _propertyPhotos.add(image.path);
      });
      if (mounted) ToastUtils.showSuccess(context, 'Photo added successfully!');
    }
  }

  // 2. Real Date Picker
  Future<void> _selectAvailableDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _aptAvailableDate = '${picked.day} ${_getMonthName(picked.month)} ${picked.year}';
      });
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  // 3. Add Hostel Room Dialog
  void _showAddHostelRoomDialog(BuildContext context) {
    final noCtrl = TextEditingController(text: '10${_hostelRoomsList.length + 1}');
    int bedsCount = 2;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add New Room', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.5, color: Color(0xFF0F172A))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noCtrl,
                decoration: const InputDecoration(
                  labelText: 'Room Number',
                  hintText: 'e.g. 107',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Number of Beds', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (bedsCount > 1) setSt(() => bedsCount--);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                          child: const Center(child: Icon(Icons.remove, size: 16)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('$bedsCount', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                      ),
                      GestureDetector(
                        onTap: () => setSt(() => bedsCount++),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: AppColors.primarySubtle, borderRadius: BorderRadius.circular(8)),
                          child: const Center(child: Icon(Icons.add, size: 16, color: AppColors.primary)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final rNo = noCtrl.text.trim();
                if (rNo.isNotEmpty) {
                  setState(() {
                    _hostelRoomsList.add(HostelRoomModel(roomNo: rNo, beds: bedsCount));
                    _floorRoomsMap[_selectedFloorName] = _hostelRoomsList.length;
                  });
                  ToastUtils.showSuccess(context, 'Room $rNo ($bedsCount Beds) added!');
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add Room', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Edit Hostel Room Dialog
  void _showEditHostelRoomDialog(BuildContext context, int index) {
    final room = _hostelRoomsList[index];
    final noCtrl = TextEditingController(text: room.roomNo);
    int bedsCount = room.beds;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Edit Room ${room.roomNo}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16.5, color: Color(0xFF0F172A))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noCtrl,
                decoration: const InputDecoration(
                  labelText: 'Room Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Number of Beds', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (bedsCount > 1) setSt(() => bedsCount--);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                          child: const Center(child: Icon(Icons.remove, size: 16)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('$bedsCount', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                      ),
                      GestureDetector(
                        onTap: () => setSt(() => bedsCount++),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: AppColors.primarySubtle, borderRadius: BorderRadius.circular(8)),
                          child: const Center(child: Icon(Icons.add, size: 16, color: AppColors.primary)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final rNo = noCtrl.text.trim();
                if (rNo.isNotEmpty) {
                  setState(() {
                    room.roomNo = rNo;
                    room.beds = bedsCount;
                  });
                  ToastUtils.showSuccess(context, 'Room updated to $rNo ($bedsCount Beds)!');
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Add Floor Modal (Apartment)
  void _showAddFloorDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: '${_aptFloorsList.length}th Floor');
    final codeCtrl = TextEditingController(text: '${_aptFloorsList.length}');
    final unitsCtrl = TextEditingController(text: '3');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New Floor', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.5, color: Color(0xFF0F172A))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Floor Name',
                hintText: 'e.g. 5th Floor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: codeCtrl,
              decoration: const InputDecoration(
                labelText: 'Floor Badge Code',
                hintText: 'e.g. 5',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: unitsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Units / Rooms',
                hintText: 'e.g. 3',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final name = nameCtrl.text.trim();
              final code = codeCtrl.text.trim();
              final uCount = int.tryParse(unitsCtrl.text.trim()) ?? 2;

              if (name.isNotEmpty) {
                setState(() {
                  _aptFloorsList.add(
                    FloorModel(
                      code: code.isEmpty ? '${_aptFloorsList.length}' : code,
                      name: name,
                      units: uCount,
                      bg: const Color(0xFFEFF6FF),
                      fg: AppColors.primary,
                    ),
                  );
                });
                ToastUtils.showSuccess(context, 'Floor "$name" added with $uCount units!');
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add Floor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  // 7. Add Apartment Unit Modal
  void _showAddUnitDialog(BuildContext context) {
    final noController = TextEditingController(text: '10${_aptUnitsList.length + 1}');
    String selectedType = '2 BHK';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add New Unit / Flat', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.5, color: Color(0xFF0F172A))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noController,
                decoration: const InputDecoration(
                  labelText: 'Unit / Flat Number',
                  hintText: 'e.g. 104',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedType,
                    isExpanded: true,
                    items: ['1 BHK', '2 BHK', '3 BHK', '4 BHK', 'Studio']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setSt(() => selectedType = v);
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final no = noController.text.trim();
                if (no.isNotEmpty) {
                  setState(() {
                    _aptUnitsList.add(UnitModel(flatNo: no, type: selectedType));
                  });
                  ToastUtils.showSuccess(context, 'Unit $no ($selectedType) added!');
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add Unit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }

  // 8. Edit Apartment Unit Modal
  void _showEditUnitDialog(BuildContext context, int index) {
    final unit = _aptUnitsList[index];
    final noController = TextEditingController(text: unit.flatNo);
    String selectedType = unit.type;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Edit Unit ${unit.flatNo}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16.5, color: Color(0xFF0F172A))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noController,
                decoration: const InputDecoration(
                  labelText: 'Unit / Flat Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedType,
                    isExpanded: true,
                    items: ['1 BHK', '2 BHK', '3 BHK', '4 BHK', 'Studio']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setSt(() => selectedType = v);
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final no = noController.text.trim();
                if (no.isNotEmpty) {
                  setState(() {
                    unit.flatNo = no;
                    unit.type = selectedType;
                  });
                  ToastUtils.showSuccess(context, 'Unit updated to $no ($selectedType)!');
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }

  // 9. Add Custom Amenity Modal
  void _showAddCustomAmenityDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Custom Amenity', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g. Swimming Pool, Gym, Garden',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  _aptSpecialAmenities[name] = true;
                  _selectedAmenities.add(name);
                });
                ToastUtils.showSuccess(context, 'Amenity "$name" added!');
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  int get _maxSteps {
    return 7;
  }

  void _nextStep() {
    if (_currentStep == 1 && _propertyNameController.text.trim().isEmpty) {
      ToastUtils.showError(context, 'Please enter property name');
      return;
    }

    // Step 3 (Structure screen) Continue button -> SKIP Step 4, go directly to Step 5!
    if (_currentStep == 3) {
      setState(() => _currentStep = 5);
      return;
    }

    // Step 4 (Floor units/rooms edit screen opened via Edit icon ✏️) -> Save & Return to Step 3!
    if (_currentStep == 4) {
      setState(() {
        _currentStep = 3;
        _isEditingFloor = false;
      });
      ToastUtils.showSuccess(context, '$_selectedFloorName details saved!');
      return;
    }

    if (_currentStep < _maxSteps) {
      setState(() => _currentStep++);
    } else {
      _saveProperty();
    }
  }

  void _previousStep() {
    if (_currentStep == 5) {
      setState(() => _currentStep = 3);
      return;
    }

    if (_currentStep == 4) {
      setState(() {
        _currentStep = 3;
        _isEditingFloor = false;
      });
      return;
    }

    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        Navigator.of(context).maybePop();
      }
    }
  }

  Future<void> _saveProperty() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ToastUtils.showSuccess(
      context,
      'Property "${_propertyNameController.text.trim()}" created successfully!',
    );

    context.go(AppRoutes.dashboard);
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
        body: SafeArea(
          child: Column(
            children: [
              // 1. Header Bar
              _buildHeaderBar(),

              // 2. Dynamic Step Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(18),
                  child: _buildCurrentStepBody(),
                ),
              ),

              // 3. Bottom Action Button
              _buildBottomAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    String headerTitle = '';
    if (_currentStep > 0) {
      if (_currentStep == 3) {
        headerTitle = _selectedPropertyType == 'Apartment' ? 'Apartment Structure' : 'Hostel Structure';
      } else if (_currentStep == 4) {
        headerTitle = _selectedPropertyType == 'Apartment' ? '$_selectedFloorName - Units' : '$_selectedFloorName - Rooms';
      } else if (_currentStep == 7) {
        headerTitle = 'Property Summary';
      } else if (_currentStep != 5) {
        headerTitle = 'Add Property ($_selectedPropertyType)';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _previousStep,
            child: Container(
              width: 36,
              height: 36,
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
          if (headerTitle.isNotEmpty)
            Text(
              headerTitle,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildCurrentStepBody() {
    if (_currentStep == 0) return _buildStep0SelectType();
    if (_currentStep == 1) return _buildStep1PropertyDetails();
    if (_currentStep == 2) return _buildStep2CommonAmenities();

    if (_selectedPropertyType == 'Apartment') {
      switch (_currentStep) {
        case 3:
          return _buildStep8ApartmentStructure(); // Apartment Structure (Floors)
        case 4:
          return _buildStep9AddFlatsUnits(); // FULL SCREEN: [Selected Floor] - Units
        case 5:
          return _buildStep10FlatConfiguration(); // 1:1 Pixel Perfect Matching media_1787752658314.png!
        case 6:
          return _buildStep11SpecialFlatAmenities(); // Special Flat Amenities
        case 7:
          return _buildStep12PropertySummary(); // Property Summary
        default:
          return Container();
      }
    } else {
      // HOSTEL / PG FLOW
      switch (_currentStep) {
        case 3:
          return _buildStep3FloorAndRoomSetupHostel(); // Hostel Structure
        case 4:
          return _buildStep4HostelRoomsListScreen(); // FULL SCREEN: [Selected Floor] - Rooms
        case 5:
          return _buildStep4RoomAndBedSetupHostel();
        case 6:
          return _buildStep5RentAndChargesHostel();
        case 7:
          return _buildStep12PropertySummary();
        default:
          return Container();
      }
    }
  }

  // STEP 0: Select Property Type
  Widget _buildStep0SelectType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Property Type',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Choose the type of property you want to add',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        _buildTypeCard(
          type: 'Hostel',
          desc: 'Manage by bed system with mess, employees & more.',
          icon: Icons.king_bed_rounded,
          color: const Color(0xFF2563EB),
          bg: const Color(0xFFEFF6FF),
        ),
        const SizedBox(height: 14),
        _buildTypeCard(
          type: 'Apartment',
          desc: 'Manage rooms & flats with tenants.',
          icon: Icons.domain_rounded,
          color: const Color(0xFFD97706),
          bg: const Color(0xFFFEF3C7),
        ),
        const SizedBox(height: 14),
        _buildTypeCard(
          type: 'PG / Home',
          desc: 'Manage PG or Independent house.',
          icon: Icons.home_rounded,
          color: const Color(0xFF16A34A),
          bg: const Color(0xFFDCFCE7),
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required String type,
    required String desc,
    required IconData icon,
    required Color color,
    required Color bg,
  }) {
    final bool isSelected = _selectedPropertyType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPropertyType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(icon, color: color, size: 24),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.arrow_forward_ios_rounded,
              size: isSelected ? 20 : 16,
              color: isSelected ? AppColors.primary : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 1: Property Details
  Widget _buildStep1PropertyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Property Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Let\'s start with the basic details.',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),

        CustomTextField(
          controller: _propertyNameController,
          label: 'Property Name *',
          hintText: 'e.g. Shanti Residency',
          prefixIcon: const Icon(Icons.business_rounded, color: AppColors.primary),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _addressController,
          label: 'Address *',
          hintText: 'e.g. MG Road, Indore, MP',
          maxLines: 2,
          prefixIcon: const Icon(Icons.location_on_rounded, color: AppColors.primary),
        ),
        const SizedBox(height: 16),

        const Text(
          'Live Location',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            ToastUtils.showSuccess(context, 'Location pinned: ${_addressController.text}');
          },
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?w=600'),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 24),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.my_location_rounded, color: AppColors.primary, size: 14),
                        SizedBox(width: 4),
                        Text('Pin Location', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Property Photos',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
            Text(
              '${_propertyPhotos.length} Added',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _propertyPhotos.length + 1,
            itemBuilder: (ctx, idx) {
              if (idx == _propertyPhotos.length) {
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 22),
                        SizedBox(height: 4),
                        Text('Add More', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ],
                    ),
                  ),
                );
              }

              final photo = _propertyPhotos[idx];
              final isNetwork = photo.startsWith('http');

              return Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: isNetwork
                          ? Image.network(photo, fit: BoxFit.cover)
                          : Image.file(File(photo), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 14,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _propertyPhotos.removeAt(idx);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // STEP 2: Common Amenities
  Widget _buildStep2CommonAmenities() {
    final List<Map<String, dynamic>> allAmenities = [
      {'name': 'WiFi', 'icon': Icons.wifi_rounded},
      {'name': 'RO Water', 'icon': Icons.water_drop_rounded},
      {'name': 'Geyser', 'icon': Icons.hot_tub_rounded},
      {'name': 'Washing Machine', 'icon': Icons.local_laundry_service_rounded},
      {'name': 'Locker', 'icon': Icons.lock_rounded},
      {'name': 'Power Backup', 'icon': Icons.electric_bolt_rounded},
      {'name': 'CCTV', 'icon': Icons.videocam_rounded},
      {'name': 'Lift', 'icon': Icons.elevator_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Common Amenities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Select amenities available for all tenants.',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 18),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
          ),
          itemCount: allAmenities.length + 1,
          itemBuilder: (ctx, idx) {
            if (idx == allAmenities.length) {
              return GestureDetector(
                onTap: () => _showAddCustomAmenityDialog(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, color: AppColors.primary, size: 24),
                      SizedBox(height: 4),
                      Text('Add More', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                ),
              );
            }

            final item = allAmenities[idx];
            final String name = item['name'];
            final IconData icon = item['icon'];
            final bool isSelected = _selectedAmenities.contains(name);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedAmenities.remove(name);
                  } else {
                    _selectedAmenities.add(name);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: isSelected ? AppColors.primary : const Color(0xFF64748B), size: 22),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? AppColors.primary : const Color(0xFF0F172A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ================= HOSTEL FLOW STEP 4: FULL SCREEN "1st Floor - Rooms" =================
  Widget _buildStep4HostelRoomsListScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_selectedFloorName - Rooms',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Number of Rooms',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_hostelRoomsList.length > 1) {
                        setState(() {
                          _hostelRoomsList.removeLast();
                          _floorRoomsMap[_selectedFloorName] = _hostelRoomsList.length;
                        });
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: const Center(child: Icon(Icons.remove_rounded, color: Color(0xFF0F172A), size: 22)),
                    ),
                  ),
                  Text(
                    '${_hostelRoomsList.length}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        final rNo = '10${_hostelRoomsList.length + 1}';
                        _hostelRoomsList.add(HostelRoomModel(roomNo: rNo, beds: 2));
                        _floorRoomsMap[_selectedFloorName] = _hostelRoomsList.length;
                      });
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: const Center(child: Icon(Icons.add_rounded, color: Color(0xFF16A34A), size: 22)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rooms List',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            Text(
              '${_hostelRoomsList.length} Rooms Configured',
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _hostelRoomsList.length,
          itemBuilder: (ctx, idx) {
            final r = _hostelRoomsList[idx];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          r.roomNo,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          '${r.beds} Beds',
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showEditHostelRoomDialog(context, idx),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F172A)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _hostelRoomsList.removeAt(idx);
                        _floorRoomsMap[_selectedFloorName] = _hostelRoomsList.length;
                      });
                      ToastUtils.showSuccess(context, 'Room removed');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => _showAddHostelRoomDialog(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
          label: const Text(
            'Add Room',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ================= APARTMENT FLOW SCREEN 8: Apartment Structure =================
  Widget _buildStep8ApartmentStructure() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apartment Structure',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Number of Floors',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_aptFloorsList.length > 1) {
                        setState(() {
                          _aptFloorsList.removeLast();
                        });
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: const Center(child: Icon(Icons.remove_rounded, color: Color(0xFF0F172A), size: 22)),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${_aptFloorsList.length}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '(Ground Floor + ${_aptFloorsList.length - 1} Floors)',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        final idx = _aptFloorsList.length;
                        _aptFloorsList.add(
                          FloorModel(
                            code: '$idx',
                            name: '${idx}th Floor',
                            units: 3,
                            bg: const Color(0xFFEFF6FF),
                            fg: AppColors.primary,
                          ),
                        );
                      });
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: const Center(child: Icon(Icons.add_rounded, color: Color(0xFF16A34A), size: 22)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Floors Overview',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            Text(
              '${_aptFloorsList.length} Floors Configured',
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _aptFloorsList.length,
          itemBuilder: (ctx, idx) {
            final f = _aptFloorsList[idx];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFloorName = f.name;
                  _isEditingFloor = true;
                  _currentStep = 4;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: f.bg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          f.code,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: f.fg),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.name,
                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${f.units} Units',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => _showAddFloorDialog(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
          label: const Text(
            'Add Floor',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ================= APARTMENT FLOW SCREEN 9: FULL SCREEN "[Selected Floor] - Units" =================
  Widget _buildStep9AddFlatsUnits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_selectedFloorName - Units',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 18),

        const Text(
          'Add Unit Type',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),

        Row(
          children: ['Flat', 'Room', 'RK'].map((uType) {
            final isSel = _aptUnitType == uType;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _aptUnitType = uType),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFEFF6FF) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSel ? AppColors.primary : const Color(0xFFE2E8F0), width: isSel ? 2 : 1),
                  ),
                  child: Center(
                    child: Text(
                      uType,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isSel ? FontWeight.w900 : FontWeight.w600,
                        color: isSel ? AppColors.primary : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Units List',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            Text(
              '${_aptUnitsList.length} Units Added',
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _aptUnitsList.length,
          itemBuilder: (ctx, idx) {
            final u = _aptUnitsList[idx];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          u.flatNo,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          u.type,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showEditUnitDialog(context, idx),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F172A)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _aptUnitsList.removeAt(idx);
                      });
                      ToastUtils.showSuccess(context, 'Unit removed');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => _showAddUnitDialog(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
          label: const Text(
            'Add Unit',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ================= APARTMENT FLOW SCREEN 10: Flat Configuration (1:1 Pixel Perfect matching media_1787752658314.png) =================
  Widget _buildStep10FlatConfiguration() {
    final List<Map<String, dynamic>> flatAmenities = [
      {'name': 'AC', 'icon': Icons.ac_unit_rounded, 'color': const Color(0xFF2563EB), 'bg': const Color(0xFFEFF6FF)},
      {'name': 'WiFi', 'icon': Icons.wifi_rounded, 'color': const Color(0xFF16A34A), 'bg': const Color(0xFFDCFCE7)},
      {'name': 'Geyser', 'icon': Icons.hot_tub_rounded, 'color': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7)},
      {'name': 'Parking', 'icon': Icons.directions_car_rounded, 'color': const Color(0xFF2563EB), 'bg': const Color(0xFFEFF6FF)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Flat Number Horizontal Row
        _buildFormRowLabelAndInput(
          label: 'Flat Number',
          child: SizedBox(
            width: 140,
            child: TextField(
              controller: _aptFlatNoController,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '101',
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 2. Flat Type Horizontal Row
        _buildFormRowLabelAndInput(
          label: 'Flat Type',
          child: Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _aptFlatType,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                items: ['1 BHK', '2 BHK', '3 BHK', '4 BHK', 'Studio Flat']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _aptFlatType = val);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 3. Monthly Rent (₹) Horizontal Row
        _buildFormRowLabelAndInput(
          label: 'Monthly Rent (₹)',
          child: Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _aptRentController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 4. Security Deposit (₹) Horizontal Row
        _buildFormRowLabelAndInput(
          label: 'Security Deposit (₹)',
          child: Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _aptSecurityController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 5. Maintenance (₹) Horizontal Row
        _buildFormRowLabelAndInput(
          label: 'Maintenance (₹)',
          child: Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _aptMaintenanceController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Furnishing Pill Buttons
        const Text(
          'Furnishing',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        Row(
          children: ['Fully Furnished', 'Semi Furnished', 'Unfurnished'].map((fOpt) {
            final isSel = _aptFurnishing == fOpt;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _aptFurnishing = fOpt),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFDCFCE7) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSel ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0), width: isSel ? 1.5 : 1),
                  ),
                  child: Center(
                    child: Text(
                      fOpt,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                        color: isSel ? const Color(0xFF16A34A) : const Color(0xFF475569),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // Available From Box
        const Text(
          'Available From',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectAvailableDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_aptAvailableDate, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Flat Amenities Square Icon Cards (1:1 Reference media_1787752658314.png)
        const Text(
          'Flat Amenities',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ...flatAmenities.map((fa) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: fa['bg'] as Color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(fa['icon'] as IconData, size: 18, color: fa['color'] as Color),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        fa['name'] as String,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Expanded(
              child: GestureDetector(
                onTap: () => _showAddCustomAmenityDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: Center(
                          child: Icon(Icons.add_rounded, size: 22, color: AppColors.primary),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'More',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Electricity Cost Radio Rows (1:1 Reference media_1787752658314.png)
        const Text(
          'Electricity Cost',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),

        // Radio 1: No Cost
        GestureDetector(
          onTap: () => setState(() => _aptElectricityType = 'No Cost'),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  _aptElectricityType == 'No Cost' ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                  color: _aptElectricityType == 'No Cost' ? AppColors.primary : const Color(0xFFCBD5E1),
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Text('No Cost', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
              ],
            ),
          ),
        ),

        // Radio 2: Fixed Cost
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _aptElectricityType = 'Fixed Cost'),
                child: Row(
                  children: [
                    Icon(
                      _aptElectricityType == 'Fixed Cost' ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                      color: _aptElectricityType == 'Fixed Cost' ? AppColors.primary : const Color(0xFFCBD5E1),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text('Fixed Cost', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Text('₹ ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                    Expanded(
                      child: TextField(
                        controller: _aptFixedElectricityController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text('/ Month', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
            ],
          ),
        ),

        // Radio 3: Meter Per Unit
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _aptElectricityType = 'Meter Per Unit'),
                child: Row(
                  children: [
                    Icon(
                      _aptElectricityType == 'Meter Per Unit' ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                      color: _aptElectricityType == 'Meter Per Unit' ? AppColors.primary : const Color(0xFFCBD5E1),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text('Meter Per Unit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Text('₹ ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                    Expanded(
                      child: TextField(
                        controller: _aptMeterRateController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text('/ Unit   ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormRowLabelAndInput({required String label, required Widget child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        child,
      ],
    );
  }

  // ================= APARTMENT FLOW SCREEN 11: Special Flat Amenities =================
  Widget _buildStep11SpecialFlatAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special Flat Amenities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        Text(
          'Flat: ${_aptFlatNoController.text.trim()} ($_aptFlatType)',
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),

        const Text(
          'Additional Amenities',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: _aptSpecialAmenities.keys.map((aKey) {
              final isChecked = _aptSpecialAmenities[aKey]!;
              return CheckboxListTile(
                value: isChecked,
                activeColor: AppColors.primary,
                title: Text(
                  aKey,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _aptSpecialAmenities[aKey] = val ?? false;
                  });
                },
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => _showAddCustomAmenityDialog(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
          label: const Text(
            'Add Custom Amenity',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ================= APARTMENT & HOSTEL FLOW SCREEN 12: Property Summary =================
  Widget _buildStep12PropertySummary() {
    int totalCalculatedUnits = 0;
    if (_selectedPropertyType == 'Apartment') {
      for (var f in _aptFloorsList) {
        totalCalculatedUnits += f.units;
      }
    } else {
      totalCalculatedUnits = _hostelRoomsList.length * _floorRoomsMap.length;
    }
    if (totalCalculatedUnits == 0) totalCalculatedUnits = 13;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Property Summary',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
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
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      _propertyPhotos.first,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _selectedPropertyType,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _propertyNameController.text.trim(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          _addressController.text.trim(),
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '👥 ${_selectedPropertyType == 'Apartment' ? _aptFloorsList.length : _floorRoomsMap.length} Floors • $totalCalculatedUnits Units',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Text(
          'Common Amenities',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ...['wifi', 'water_drop', 'hot_tub', 'link'].map((icName) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 20),
              );
            }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('+${_selectedAmenities.length > 4 ? _selectedAmenities.length - 4 : 3}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
            ),
          ],
        ),

        const SizedBox(height: 22),
        const Text(
          'Unit Summary',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(child: _buildSummaryBadgeCard('Total Units', '$totalCalculatedUnits', const Color(0xFF0F172A), const Color(0xFFF8FAFC))),
            const SizedBox(width: 8),
            Expanded(child: _buildSummaryBadgeCard('Occupied', '9', const Color(0xFF16A34A), const Color(0xFFDCFCE7))),
            const SizedBox(width: 8),
            Expanded(child: _buildSummaryBadgeCard('Available', '${totalCalculatedUnits > 9 ? totalCalculatedUnits - 9 : 4}', const Color(0xFFD97706), const Color(0xFFFEF3C7))),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryBadgeCard(String label, String val, Color textCol, Color bgCol) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgCol,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: textCol)),
        ],
      ),
    );
  }

  // ================= HOSTEL / PG STEP HANDLERS =================
  Widget _buildStep3FloorAndRoomSetupHostel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hostel Structure',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 18),

        // Number of Floors Stepper Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Number of Floors',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_floorRoomsMap.length > 1) {
                        setState(() {
                          final lastKey = _floorRoomsMap.keys.last;
                          _floorRoomsMap.remove(lastKey);
                        });
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: const Center(child: Icon(Icons.remove_rounded, color: Color(0xFF0F172A), size: 22)),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${_floorRoomsMap.length - 1}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '(Ground Floor + ${_floorRoomsMap.length - 1} Floors)',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        final idx = _floorRoomsMap.length - 1;
                        _floorRoomsMap['${idx}th Floor'] = 4;
                      });
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: const Center(child: Icon(Icons.add_rounded, color: Color(0xFF16A34A), size: 22)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Floors Overview',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            Text(
              '${_floorRoomsMap.length} Floors Configured',
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _floorRoomsMap.keys.length,
          itemBuilder: (ctx, idx) {
            final floorName = _floorRoomsMap.keys.elementAt(idx);
            final roomCount = _floorRoomsMap[floorName]!;
            final code = idx == 0 ? 'G' : '$idx';
            final colors = [
              const Color(0xFF2563EB),
              const Color(0xFF16A34A),
              const Color(0xFF7C3AED),
              const Color(0xFFD97706),
            ];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFloorName = floorName;
                  _isEditingFloor = true;
                  _currentStep = 4;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: colors[idx % colors.length].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          code,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: colors[idx % colors.length]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            floorName,
                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$roomCount Rooms',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () {
            final idx = _floorRoomsMap.length - 1;
            setState(() {
              _floorRoomsMap['${idx + 1}th Floor'] = 4;
            });
            ToastUtils.showSuccess(context, 'Floor added!');
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
          label: const Text(
            'Add Floor',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4RoomAndBedSetupHostel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Room & Bed Setup',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        Text(
          'Each room will have $_bedsPerRoom beds by default.',
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),

        const Text(
          'Default Beds in Each Room',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [1, 2, 3, 4].map((bCount) {
              final isSelected = _bedsPerRoom == bCount;
              return ListTile(
                leading: Icon(
                  isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: isSelected ? AppColors.primary : const Color(0xFF94A3B8),
                  size: 22,
                ),
                title: Text(
                  '$bCount Bed${bCount > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _bedsPerRoom = bCount;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStep5RentAndChargesHostel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rent & Charges (Per Bed)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Set default charges for each bed.',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),

        CustomTextField(
          controller: _monthlyRentController,
          label: 'Monthly Rent (Per Bed) *',
          keyboardType: TextInputType.number,
          hintText: 'e.g. 5000',
          prefixIcon: const Icon(Icons.currency_rupee_rounded, color: AppColors.primary),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _securityDepositController,
          label: 'Security Deposit (Per Bed)',
          keyboardType: TextInputType.number,
          hintText: 'e.g. 10000',
          prefixIcon: const Icon(Icons.savings_rounded, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    String buttonText = 'Continue';

    if (_currentStep == 4 || _isEditingFloor) {
      buttonText = 'Save';
    } else if (_selectedPropertyType == 'Apartment') {
      if (_currentStep == 5) buttonText = 'Save Flat';
      if (_currentStep == 6) buttonText = 'Save Amenities';
      if (_currentStep == 7) buttonText = 'Go to Dashboard';
    } else {
      if (_currentStep == 6) buttonText = 'Save Property';
      if (_currentStep == 7) buttonText = 'Go to Dashboard';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1.0)),
      ),
      child: CustomButton(
        text: buttonText,
        isLoading: _isSubmitting,
        onPressed: _nextStep,
      ),
    );
  }
}

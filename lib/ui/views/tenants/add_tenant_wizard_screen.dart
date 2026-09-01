import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/header_wave_painter.dart';
import '../../view_models/tenants_view_model.dart';

class AddTenantWizardScreen extends StatefulWidget {
  final TenantsViewModel? viewModel;

  const AddTenantWizardScreen({super.key, this.viewModel});

  @override
  State<AddTenantWizardScreen> createState() => _AddTenantWizardScreenState();
}

class _AddTenantWizardScreenState extends State<AddTenantWizardScreen> {
  int _currentStep = 1;

  // Step 1: Personal Details
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController();
  final _emergencyController = TextEditingController();

  // Step 2: Property & Rental Terms
  final String _selectedProperty = 'Green View Student Hostel';
  bool _tenantWithoutUnit = false;
  final String _selectedRoomNo = '101';
  final TextEditingController _rentController = TextEditingController(text: '10000');
  final TextEditingController _depositController = TextEditingController(text: '20000');

  // Step 3: Documents
  bool _idUploaded = false;
  bool _photoUploaded = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _occupationController.dispose();
    _emergencyController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
        ToastUtils.showError(context, 'Please enter Full Name and Phone Number');
        return;
      }
    }
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (widget.viewModel != null) {
      widget.viewModel!.onboardTenant(
        name: _nameController.text.trim().isEmpty ? 'Ramesh Kumar' : _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? '9876543210' : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? 'tenant@example.com' : _emailController.text.trim(),
        roomNo: _selectedRoomNo,
        bedNo: 'Bed A',
        monthlyRent: double.tryParse(_rentController.text) ?? 10000,
        depositPaid: double.tryParse(_depositController.text) ?? 20000,
        guardianName: 'Guardian',
        guardianPhone: _emergencyController.text.trim().isEmpty ? '9876500000' : _emergencyController.text.trim(),
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    ToastUtils.showSuccess(context, 'Tenant onboarded successfully!');

    if (context.canPop()) {
      context.pop();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    String subtitle = 'Basic info about the tenant';
    if (_currentStep == 2) subtitle = 'Assign property and rental terms';
    if (_currentStep == 3) subtitle = 'Upload KYC documents & submit';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            // 1. Header Banner with Connected Stepper
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color(0xFF0052D4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: CustomPaint(
                painter: HeaderWavePainter(),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topPadding + 6,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Arrow Tile
                      GestureDetector(
                        onTap: () {
                          if (_currentStep > 1) {
                            _prevStep();
                          } else if (context.canPop()) {
                            context.pop();
                          } else {
                            Navigator.of(context).maybePop();
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                          ),
                          child: const Center(
                            child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Add Tenant',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 14),

                      // Perfectly Connected Stepper Component
                      _buildConnectedStepper(),
                    ],
                  ),
                ),
              ),
            ),

            // 2. White Scrollable Body Form Container (Compact & Balanced Font Sizes)
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF8FAFC),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(14),
                    child: _buildStepContent(),
                  ),
                ),
              ),
            ),

            // 3. Fixed Bottom Action Bar
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1.0)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 1) ...[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton.icon(
                        onPressed: _prevStep,
                        icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF0F172A)),
                        label: const Text('Back', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w800)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: _currentStep == 3 ? 'Submit Tenant' : 'Next →',
                      backgroundColor: AppColors.primary,
                      isLoading: _isSubmitting,
                      onPressed: _currentStep == 3 ? _handleSubmit : _nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Connected Stepper Component
  Widget _buildConnectedStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row of Circles and Directly Connected Lines
          Row(
            children: [
              const SizedBox(width: 14),
              _buildStepCircle(1),
              Expanded(child: _buildConnectingLine(1)),
              _buildStepCircle(2),
              Expanded(child: _buildConnectingLine(2)),
              _buildStepCircle(3),
              const SizedBox(width: 14),
            ],
          ),
          const SizedBox(height: 5),
          // Row of Step Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel(1, 'Personal'),
              _buildStepLabel(2, 'Property'),
              _buildStepLabel(3, 'Documents'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int stepNo) {
    final isDone = _currentStep > stepNo;
    final isActive = _currentStep == stepNo;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDone
            ? const Color(0xFF10B981)
            : isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
            : Text(
                '$stepNo',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: isActive ? AppColors.primary : Colors.white70,
                ),
              ),
      ),
    );
  }

  Widget _buildConnectingLine(int afterStep) {
    final isDone = _currentStep > afterStep;
    return Container(
      height: 2.5,
      color: isDone ? const Color(0xFF10B981) : Colors.white30,
    );
  }

  Widget _buildStepLabel(int stepNo, String label) {
    final isDone = _currentStep > stepNo;
    final isActive = _currentStep == stepNo;

    return SizedBox(
      width: 62,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: isActive || isDone ? FontWeight.w900 : FontWeight.w500,
          color: isActive || isDone ? Colors.white : Colors.white60,
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1Personal();
      case 2:
        return _buildStep2Property();
      case 3:
        return _buildStep3Documents();
      default:
        return Container();
    }
  }

  // STEP 1: PERSONAL DETAILS (Compact & Balanced Font Sizes)
  Widget _buildStep1Personal() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_pin_rounded, size: 16, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'BASIC INFORMATION',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 0.8),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _nameController,
            label: 'Full Name *',
            hintText: 'Enter full name',
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _phoneController,
            label: 'Phone Number *',
            hintText: 'Enter phone number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hintText: 'Enter email address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _occupationController,
            label: 'Occupation',
            hintText: 'Enter occupation',
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _emergencyController,
            label: 'Emergency Contact',
            hintText: 'Enter emergency phone number',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  // STEP 2: PROPERTY & RENTAL TERMS
  Widget _buildStep2Property() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SELECT PROPERTY CARD
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.domain_rounded, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('SELECT PROPERTY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 0.8)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 1.6),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Center(child: Icon(Icons.domain_rounded, color: AppColors.primary, size: 22)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_selectedProperty, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: Color(0xFF0F172A))),
                          const SizedBox(height: 2),
                          const Text('Managed PG / Apartment', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.check_rounded, size: 13, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => setState(() => _tenantWithoutUnit = !_tenantWithoutUnit),
                child: Row(
                  children: [
                    Checkbox(
                      value: _tenantWithoutUnit,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _tenantWithoutUnit = v ?? false),
                    ),
                    const Expanded(
                      child: Text('Register tenant without assigning unit now', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // RENT & DEPOSIT TERMS
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.payments_outlined, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('RENTAL TERMS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 0.8)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _rentController,
                      label: 'Monthly Rent (₹) *',
                      hintText: 'Enter monthly rent',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _depositController,
                      label: 'Security Deposit (₹) *',
                      hintText: 'Enter deposit',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 3: DOCUMENTS
  Widget _buildStep3Documents() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.verified_user_outlined, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('KYC DOCUMENTATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 0.8)),
                ],
              ),
              const SizedBox(height: 12),
              _buildUploadTile('Aadhaar / Govt ID Proof', _idUploaded, () => setState(() => _idUploaded = !_idUploaded)),
              const SizedBox(height: 10),
              _buildUploadTile('Tenant Photo (Passport Size)', _photoUploaded, () => setState(() => _photoUploaded = !_photoUploaded)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadTile(String title, bool isDone, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDone ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDone ? const Color(0xFF10B981) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFFDCFCE7) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
                  color: isDone ? const Color(0xFF15803D) : AppColors.primary,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: Color(0xFF0F172A))),
                  const SizedBox(height: 1),
                  Text(isDone ? 'Document Uploaded' : 'Tap to upload file', style: TextStyle(fontSize: 10.5, color: isDone ? const Color(0xFF15803D) : const Color(0xFF64748B), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

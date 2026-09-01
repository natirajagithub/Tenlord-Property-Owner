import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/header_wave_painter.dart';
import '../../../data/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _businessNameController;
  late TextEditingController _cityController;
  late TextEditingController _bankNameController;
  late TextEditingController _accountNoController;
  late TextEditingController _ifscController;
  late TextEditingController _upiIdController;

  String? _avatarPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = StorageService.getOwnerProfile();

    _nameController = TextEditingController(text: profile['name']);
    _phoneController = TextEditingController(text: profile['phone']);
    _emailController = TextEditingController(text: profile['email']);
    _businessNameController = TextEditingController(text: profile['business']);
    _cityController = TextEditingController(text: profile['city']);
    _bankNameController = TextEditingController(text: profile['bank']);
    _accountNoController = TextEditingController(text: profile['accountNo']);
    _ifscController = TextEditingController(text: profile['ifsc']);
    _upiIdController = TextEditingController(text: profile['upi']);
    _avatarPath = profile['avatarPath']?.isNotEmpty == true ? profile['avatarPath'] : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _businessNameController.dispose();
    _cityController.dispose();
    _bankNameController.dispose();
    _accountNoController.dispose();
    _ifscController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 600,
        maxHeight: 600,
      );
      if (image != null) {
        setState(() => _avatarPath = image.path);
        await StorageService.saveAvatarPath(image.path);
        if (mounted) {
          ToastUtils.showSuccess(context, 'Profile photo updated!');
        }
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showInfo(context, 'Image picker opened');
      }
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Profile Photo Source',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library_rounded, color: AppColors.primary, size: 20),
              ),
              title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: const Text('Select photo from gallery', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            ListTile(
              leading: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Color(0xFFD97706), size: 20),
              ),
              title: const Text('Take Photo via Camera', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: const Text('Capture new photo using camera', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_avatarPath != null) ...[
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              ListTile(
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEF0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 20),
                ),
                title: const Text('Remove Photo', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFFEF4444))),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _avatarPath = null);
                  StorageService.saveAvatarPath('');
                  ToastUtils.showInfo(context, 'Profile photo removed');
                },
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));

    await StorageService.saveOwnerProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      business: _businessNameController.text.trim(),
      city: _cityController.text.trim(),
      bank: _bankNameController.text.trim(),
      accountNo: _accountNoController.text.trim(),
      ifsc: _ifscController.text.trim(),
      upi: _upiIdController.text.trim(),
      avatarPath: _avatarPath,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);
    ToastUtils.showSuccess(context, 'Owner Profile details saved locally!');
    context.pop(true);
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
        body: Column(
          children: [
            // 1. Premium Royal Blue Gradient Header Banner
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
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
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
                      const Expanded(
                        child: Text(
                          'Edit Owner Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 36),
                    ],
                  ),
                ),
              ),
            ),

            // 2. White Sheet Form Body
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar Photo Upload Section
                        Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: _showImagePickerModal,
                                child: Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    color: AppColors.coralOrange,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.coralOrange.withValues(alpha: 0.25),
                                        blurRadius: 14,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: _avatarPath != null && File(_avatarPath!).existsSync()
                                        ? Image.file(
                                            File(_avatarPath!),
                                            fit: BoxFit.cover,
                                            width: 88,
                                            height: 88,
                                          )
                                        : Center(
                                            child: Text(
                                              _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'N',
                                              style: const TextStyle(
                                                fontSize: 38,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: _showImagePickerModal,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.camera_alt_rounded, size: 15, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: TextButton.icon(
                            onPressed: _showImagePickerModal,
                            icon: const Icon(Icons.photo_camera_outlined, size: 15, color: AppColors.primary),
                            label: const Text(
                              'Change Profile Photo',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Section 1: Personal Details
                        const Text(
                          'PERSONAL DETAILS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _nameController,
                                label: 'Full Name *',
                                hintText: 'Enter your full name',
                                prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Name required' : null,
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 14),
                              CustomTextField(
                                controller: _phoneController,
                                label: 'Phone Number *',
                                hintText: '10-digit mobile number',
                                keyboardType: TextInputType.phone,
                                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary, size: 20),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Phone required' : null,
                              ),
                              const SizedBox(height: 14),
                              CustomTextField(
                                controller: _emailController,
                                label: 'Email Address *',
                                hintText: 'owner@example.com',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary, size: 20),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Email required' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 2: Business & PG Info
                        const Text(
                          'BUSINESS & PG INFORMATION',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _businessNameController,
                                label: 'Business / PG Group Name',
                                hintText: 'e.g. Shanti Residency PG',
                                prefixIcon: const Icon(Icons.business_outlined, color: AppColors.primary, size: 20),
                              ),
                              const SizedBox(height: 14),
                              CustomTextField(
                                controller: _cityController,
                                label: 'City & Region',
                                hintText: 'e.g. Indore, Madhya Pradesh',
                                prefixIcon: const Icon(Icons.location_city_outlined, color: AppColors.primary, size: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 3: Bank & Settlement Info
                        const Text(
                          'BANK & SETTLEMENT DETAILS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _bankNameController,
                                label: 'Bank Name',
                                hintText: 'e.g. HDFC Bank',
                                prefixIcon: const Icon(Icons.account_balance_outlined, color: AppColors.primary, size: 20),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _accountNoController,
                                      label: 'Account Number',
                                      hintText: 'e.g. 918273644891',
                                      keyboardType: TextInputType.number,
                                      prefixIcon: const Icon(Icons.credit_card_outlined, color: AppColors.primary, size: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _ifscController,
                                      label: 'IFSC Code',
                                      hintText: 'e.g. HDFC0001234',
                                      prefixIcon: const Icon(Icons.domain_outlined, color: AppColors.primary, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              CustomTextField(
                                controller: _upiIdController,
                                label: 'UPI ID (For Auto Settlement)',
                                hintText: 'e.g. dormly@hdfcbank',
                                prefixIcon: const Icon(Icons.qr_code_rounded, color: AppColors.primary, size: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Save Button
                        CustomButton(
                          text: 'Save Profile Changes',
                          isLoading: _isSaving,
                          onPressed: _handleSave,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

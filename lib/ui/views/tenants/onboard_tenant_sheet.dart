import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../view_models/tenants_view_model.dart';

class OnboardTenantSheet extends StatefulWidget {
  final TenantsViewModel viewModel;

  const OnboardTenantSheet({super.key, required this.viewModel});

  @override
  State<OnboardTenantSheet> createState() => _OnboardTenantSheetState();
}

class _OnboardTenantSheetState extends State<OnboardTenantSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roomController = TextEditingController(text: '304');
  final TextEditingController _bedController = TextEditingController(text: 'Bed C');
  final TextEditingController _rentController = TextEditingController(text: '8500');
  final TextEditingController _depositController = TextEditingController(text: '15000');
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianPhoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _roomController.dispose();
    _bedController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.viewModel.onboardTenant(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      roomNo: _roomController.text.trim(),
      bedNo: _bedController.text.trim(),
      monthlyRent: num.tryParse(_rentController.text.trim()) ?? 8500,
      depositPaid: num.tryParse(_depositController.text.trim()) ?? 15000,
      guardianName: _guardianNameController.text.trim(),
      guardianPhone: _guardianPhoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      ToastUtils.showSuccess(context, 'Tenant onboarded & room allocated successfully!');
    } else {
      ToastUtils.showError(context, 'Failed to onboard tenant. Try again.');
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                    'Onboard New Tenant',
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
              const SizedBox(height: 12),
              CustomTextField(
                controller: _nameController,
                label: 'Tenant Full Name',
                hintText: 'e.g. Priyanshu Sharma',
                validator: (v) => v == null || v.trim().isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _phoneController,
                      label: 'Mobile Number',
                      hintText: '10 digits',
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Phone required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _emailController,
                      label: 'Email ID',
                      hintText: 'name@example.com',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _roomController,
                      label: 'Room Number',
                      hintText: 'e.g. 304',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Room required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _bedController,
                      label: 'Bed Allotment',
                      hintText: 'e.g. Bed C',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _rentController,
                      label: 'Monthly Rent (₹)',
                      hintText: '8500',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _depositController,
                      label: 'Security Deposit (₹)',
                      hintText: '15000',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _guardianNameController,
                label: 'Guardian Full Name',
                hintText: 'Parent / Guardian Name',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _guardianPhoneController,
                label: 'Guardian Phone Number',
                hintText: 'Emergency Contact Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 22),
              ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  return CustomButton(
                    text: 'Save & Allocate Room',
                    icon: Icons.person_add_alt_1_rounded,
                    backgroundColor: AppColors.primary,
                    isLoading: widget.viewModel.isSubmitting,
                    onPressed: _handleSubmit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

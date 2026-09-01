import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class AddPropertySheet extends StatefulWidget {
  const AddPropertySheet({super.key});

  @override
  State<AddPropertySheet> createState() => _AddPropertySheetState();
}

class _AddPropertySheetState extends State<AddPropertySheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _totalRoomsController = TextEditingController(text: '20');
  final TextEditingController _totalBedsController = TextEditingController(text: '40');

  bool _isSubmitting = false;

  @override
  void dispose() {
    _propertyNameController.dispose();
    _addressController.dispose();
    _totalRoomsController.dispose();
    _totalBedsController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.of(context).pop();
    ToastUtils.showSuccess(context, 'New property "${_propertyNameController.text.trim()}" added successfully!');
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
                    'Add New PG Property',
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
                controller: _propertyNameController,
                label: 'Property / PG Name',
                hintText: 'Enter property name',
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _addressController,
                label: 'Address / Location',
                hintText: 'Enter address',
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _totalRoomsController,
                      label: 'Total Rooms',
                      hintText: 'Total rooms',
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _totalBedsController,
                      label: 'Total Beds',
                      hintText: 'Total beds',
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              CustomButton(
                text: 'Create Property',
                icon: Icons.add_home_work_rounded,
                backgroundColor: AppColors.primary,
                isLoading: _isSubmitting,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  user_edit_profile_screen.dart  –  Memomate
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproj/core/services/auth_storage.dart';
import 'package:gradproj/core/theme/app_colors.dart';
import 'package:gradproj/core/widgets/custom_button.dart';
import 'package:gradproj/core/widgets/custom_text_field.dart';
import 'package:gradproj/features/user/data/models/user_models.dart';
import 'package:gradproj/features/user/logic/user_cubit.dart';

class UserEditProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final String token;

  const UserEditProfileScreen({
    super.key,
    required this.profile,
    required this.token,
  });

  @override
  State<UserEditProfileScreen> createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _caregiverNameCtrl;
  late TextEditingController _caregiverPhoneCtrl;
  late TextEditingController _patientNameCtrl;
  late TextEditingController _patientPhoneCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _memoryProblemCtrl;
  late TextEditingController _aboutCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _caregiverNameCtrl = TextEditingController(text: p.caregiverName);
    _caregiverPhoneCtrl = TextEditingController(text: p.caregiverPhone);
    _patientNameCtrl = TextEditingController(text: p.patientName);
    _patientPhoneCtrl = TextEditingController(text: p.patientPhone);
    _ageCtrl = TextEditingController(text: p.age.toString());
    _weightCtrl = TextEditingController(text: p.weight.toString());
    _addressCtrl = TextEditingController(text: p.address);
    _memoryProblemCtrl = TextEditingController(text: p.memoryProblem);
    _aboutCtrl = TextEditingController(text: p.about);
  }

  @override
  void dispose() {
    _caregiverNameCtrl.dispose();
    _caregiverPhoneCtrl.dispose();
    _patientNameCtrl.dispose();
    _patientPhoneCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _addressCtrl.dispose();
    _memoryProblemCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'caregiverName': _caregiverNameCtrl.text.trim(),
      'caregiverPhone': _caregiverPhoneCtrl.text.trim(),
      'patientName': _patientNameCtrl.text.trim(),
      'patientPhone': _patientPhoneCtrl.text.trim(),
      'age': int.tryParse(_ageCtrl.text.trim()) ?? widget.profile.age,
      'weight': int.tryParse(_weightCtrl.text.trim()) ?? widget.profile.weight,
      'address': _addressCtrl.text.trim(),
      'memoryProblem': _memoryProblemCtrl.text.trim(),
      'about': _aboutCtrl.text.trim(),
    };

    context.read<UserCubit>().updateUserProfile(data, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) async {
        if (state is UserUpdateSuccess) {
          // Update local session so auto-login has the new data
          await AuthStorage.saveUserSession(
            token: widget.token,
            profile: state.profile,
          );

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully! ✨'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
          Navigator.pop(context); // Go back to profile screen
        } else if (state is UserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Edit Profile',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Caregiver Info'),
                CustomTextField(
                  controller: _caregiverNameCtrl,
                  labelText: 'Caregiver Name',
                  hintText: 'Enter name',
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _caregiverPhoneCtrl,
                  labelText: 'Caregiver Phone',
                  hintText: 'Enter phone',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 32.h),

                _buildSectionTitle('Patient Info'),
                CustomTextField(
                  controller: _patientNameCtrl,
                  labelText: 'Patient Name',
                  hintText: 'Enter name',
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _patientPhoneCtrl,
                  labelText: 'Patient Phone',
                  hintText: 'Enter phone',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _ageCtrl,
                        labelText: 'Age',
                        hintText: 'years',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextField(
                        controller: _weightCtrl,
                        labelText: 'Weight',
                        hintText: 'kg',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _addressCtrl,
                  labelText: 'Address',
                  hintText: 'Enter address',
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _memoryProblemCtrl,
                  labelText: 'Memory Problem',
                  hintText: 'Describe issue',
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _aboutCtrl,
                  labelText: 'About',
                  hintText: 'General info',
                  maxLines: 3,
                ),
                SizedBox(height: 40.h),

                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    return CustomButton(
                      text: 'Save Changes',
                      onPressed: _submit,
                    );
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

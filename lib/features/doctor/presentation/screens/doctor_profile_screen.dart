// ─────────────────────────────────────────────
//  doctor_profile_screen.dart  –  Memomate
//  Doctor's profile tab with edit + logout.
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproj/core/theme/app_colors.dart';
import 'package:gradproj/core/widgets/custom_button.dart';
import 'package:gradproj/core/widgets/custom_text_field.dart';
import 'package:gradproj/features/doctor/data/models/doctor_model.dart';
import 'package:gradproj/features/doctor/logic/doctor_cubit.dart';

class DoctorProfileScreen extends StatefulWidget {
  final DoctorProfile doctor;
  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  late DoctorProfile _doctor;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
  }

  // ── Logout ─────────────────────────────────────────────────────
  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/roleSelectionScreen',
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  // ── Edit profile bottom sheet ───────────────────────────────────
  void _showEditSheet() {
    final nameCtrl = TextEditingController(text: _doctor.name);
    final specCtrl = TextEditingController(text: _doctor.specialization);
    final degreeCtrl = TextEditingController(text: _doctor.degree);
    final expCtrl = TextEditingController(text: _doctor.experience);
    final aboutCtrl = TextEditingController(text: _doctor.about);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return BlocConsumer<DoctorCubit, DoctorState>(
          listener: (context, state) {
            if (state is DoctorUpdateSuccess) {
              setState(() => _doctor = state.profile);
              Navigator.pop(ctx); // close sheet
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Profile updated successfully ✓'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            } else if (state is DoctorFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 24.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ──────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit Profile',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // ── Fields ───────────────────────────────
                      CustomTextField(
                        controller: nameCtrl,
                        labelText: 'Full Name',
                        hintText: 'Enter your name',
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: specCtrl,
                        labelText: 'Specialization',
                        hintText: 'e.g. Dermatologist',
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: degreeCtrl,
                        labelText: 'Degree',
                        hintText: 'e.g. MBBS, MD',
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: expCtrl,
                        labelText: 'Experience',
                        hintText: 'e.g. 7 Years',
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: aboutCtrl,
                        labelText: 'About',
                        hintText: 'Brief bio...',
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: 20.h),

                      // ── Save Button ──────────────────────────
                      state is DoctorLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : CustomButton(
                              text: 'Save Changes',
                              onPressed: () {
                                if (!formKey.currentState!.validate()) return;

                                // Build only non-empty changed fields
                                final fields = <String, dynamic>{};
                                if (nameCtrl.text.trim() != _doctor.name) {
                                  fields["name"] = nameCtrl.text.trim();
                                }
                                if (specCtrl.text.trim() !=
                                    _doctor.specialization) {
                                  fields['specialization'] = specCtrl.text
                                      .trim();
                                }
                                if (degreeCtrl.text.trim() != _doctor.degree) {
                                  fields['degree'] = degreeCtrl.text.trim();
                                }
                                if (expCtrl.text.trim() != _doctor.experience) {
                                  fields['experience'] = expCtrl.text.trim();
                                }
                                if (aboutCtrl.text.trim() != _doctor.about) {
                                  fields['about'] = aboutCtrl.text.trim();
                                }

                                if (fields.isEmpty) {
                                  Navigator.pop(ctx);
                                  return;
                                }
                                // ignore: avoid_print
                                print(
                                  '[update] doctorId="${_doctor.id}" fields=$fields',
                                );
                                context.read<DoctorCubit>().updateDoctor(
                                  _doctor.id,
                                  fields,
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          // ── Edit button ─────────────────────────────────────
          IconButton(
            onPressed: _showEditSheet,
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            tooltip: 'Edit Profile',
          ),
          // ── Logout button ───────────────────────────────────
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: AppColors.error),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          children: [
            // ── Avatar ──────────────────────────────────────
            CircleAvatar(
              radius: 56.r,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.3),
              backgroundImage: _doctor.image.isNotEmpty
                  ? NetworkImage(_doctor.image)
                  : null,
              child: _doctor.image.isEmpty
                  ? Icon(Icons.person, size: 56.sp, color: AppColors.primary)
                  : null,
            ),
            SizedBox(height: 16.h),
            Text(
              _doctor.name,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _doctor.specialization,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 24.h),

            // ── Info Cards ───────────────────────────────────
            _infoCard(Icons.school_outlined, 'Degree', _doctor.degree),
            _infoCard(Icons.work_outline, 'Experience', _doctor.experience),
            _infoCard(Icons.email_outlined, 'Email', _doctor.email),
            _infoCard(Icons.info_outline, 'About', _doctor.about),

            SizedBox(height: 16.h),

            // ── Logout full-width button ─────────────────────
            CustomButton(
              text: 'Logout',
              backgroundColor: AppColors.error,
              onPressed: _logout,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: AppColors.grey,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

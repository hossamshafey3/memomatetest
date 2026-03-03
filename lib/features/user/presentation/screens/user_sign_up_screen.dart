// ─────────────────────────────────────────────────────────────────────────────
//  sign_up_screen.dart  –  Memomate  (user feature)
//  3-step caregiver + patient registration.
//
//  Step 1: Caregiver info  (name, email, password, gender, phone, relationship)
//  Step 2: Patient info    (name, gender, age, phone, address, weight)
//  Step 3: Medical info    (about, disease history, memory problem, allergies)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproj/core/theme/app_colors.dart';
import 'package:gradproj/core/widgets/custom_button.dart';
import 'package:gradproj/core/widgets/custom_text_field.dart';
import 'package:gradproj/features/user/data/models/user_register_model.dart';
import 'package:gradproj/features/user/logic/user_cubit.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // ── Step 1 – Caregiver ─────────────────────────────────────────
  final _step1Key = GlobalKey<FormState>();
  final _caregiverNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _caregiverPhoneCtrl = TextEditingController();
  String _caregiverGender = 'male';
  String _relationship = 'son';
  bool _obscurePassword = true;

  // ── Step 2 – Patient ────────────────────────────────────────────
  final _step2Key = GlobalKey<FormState>();
  final _patientNameCtrl = TextEditingController();
  final _patientPhoneCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _patientGender = 'male';

  // ── Step 3 – Medical ────────────────────────────────────────────
  final _step3Key = GlobalKey<FormState>();
  final _aboutCtrl = TextEditingController();
  final _memoryProblemCtrl = TextEditingController();
  final _diseaseCtrl = TextEditingController();
  final _allergiesCtrl = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _caregiverNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _caregiverPhoneCtrl.dispose();
    _patientNameCtrl.dispose();
    _patientPhoneCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _addressCtrl.dispose();
    _aboutCtrl.dispose();
    _memoryProblemCtrl.dispose();
    _diseaseCtrl.dispose();
    _allergiesCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────
  List<String> _splitComma(String raw) =>
      raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  void _nextStep() {
    final keys = [_step1Key, _step2Key, _step3Key];
    if (!keys[_currentStep].currentState!.validate()) return;

    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _submit() {
    final model = UserRegisterModel(
      caregiverName: _caregiverNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      caregiverGender: _caregiverGender,
      relationship: _relationship,
      caregiverPhone: _caregiverPhoneCtrl.text.trim(),
      patientName: _patientNameCtrl.text.trim(),
      patientGender: _patientGender,
      age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
      about: _aboutCtrl.text.trim(),
      weight: int.tryParse(_weightCtrl.text.trim()) ?? 0,
      address: _addressCtrl.text.trim(),
      patientPhone: _patientPhoneCtrl.text.trim(),
      diseaseHistory: _splitComma(_diseaseCtrl.text),
      memoryProblem: _memoryProblemCtrl.text.trim(),
      allergies: _splitComma(_allergiesCtrl.text),
    );
    context.read<UserCubit>().registerUser(model);
  }

  // ── Progress bar ────────────────────────────────────────────────
  Widget _buildProgress() {
    return Row(
      children: List.generate(3, (i) {
        final active = i <= _currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            height: 4.h,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary
                  : AppColors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        );
      }),
    );
  }

  static const _stepTitles = [
    'Tell us about yourself',
    'About your loved one',
    'Medical information',
  ];

  // ── STEP 1 ──────────────────────────────────────────────────────
  Widget _step1() {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Your name'),
          CustomTextField(
            controller: _caregiverNameCtrl,
            hintText: 'Enter your first name',
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16.h),
          _label('Email'),
          CustomTextField(
            controller: _emailCtrl,
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (!v.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          SizedBox(height: 16.h),
          _label('Password'),
          CustomTextField(
            controller: _passwordCtrl,
            hintText: 'Enter your password',
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.grey,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (v.length < 6) return 'At least 6 characters';
              return null;
            },
          ),
          SizedBox(height: 16.h),
          _label('Phone number'),
          CustomTextField(
            controller: _caregiverPhoneCtrl,
            hintText: '+20100...',
            keyboardType: TextInputType.phone,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16.h),
          _label('Gender'),
          _genderToggle(
            selected: _caregiverGender,
            onChanged: (v) => setState(() => _caregiverGender = v),
          ),
          SizedBox(height: 16.h),
          _label('Relationship to patient'),
          _dropdownField(
            value: _relationship,
            items: const [
              'son',
              'daughter',
              'spouse',
              'parent',
              'sibling',
              'in law',
              'family member',
            ],
            onChanged: (v) => setState(() => _relationship = v!),
          ),
        ],
      ),
    );
  }

  // ── STEP 2 ──────────────────────────────────────────────────────
  Widget _step2() {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("Patient's first name"),
          CustomTextField(
            controller: _patientNameCtrl,
            hintText: 'Enter their first name',
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16.h),
          _label('Gender'),
          _genderToggle(
            selected: _patientGender,
            onChanged: (v) => setState(() => _patientGender = v),
          ),
          SizedBox(height: 16.h),
          _label('Age'),
          CustomTextField(
            controller: _ageCtrl,
            hintText: 'e.g. 70',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16.h),
          _label('Weight (kg)'),
          CustomTextField(
            controller: _weightCtrl,
            hintText: 'e.g. 80',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16.h),
          _label('Phone number'),
          CustomTextField(
            controller: _patientPhoneCtrl,
            hintText: '+20100...',
            keyboardType: TextInputType.phone,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16.h),
          _label('Address'),
          CustomTextField(
            controller: _addressCtrl,
            hintText: 'e.g. 123 Nile St, Cairo',
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  // ── STEP 3 ──────────────────────────────────────────────────────
  Widget _step3() {
    return Form(
      key: _step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("Brief about patient's history"),
          CustomTextField(
            controller: _aboutCtrl,
            hintText: "Enter a brief note about patient's history...",
            keyboardType: TextInputType.multiline,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16.h),
          _label('Memory problem description'),
          CustomTextField(
            controller: _memoryProblemCtrl,
            hintText: 'e.g. Forgets recent events occasionally',
            keyboardType: TextInputType.multiline,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16.h),
          _label('Disease history (comma separated)'),
          CustomTextField(
            controller: _diseaseCtrl,
            hintText: 'e.g. diabetes, hypertension',
          ),
          SizedBox(height: 16.h),
          _label('Allergies (comma separated)'),
          CustomTextField(
            controller: _allergiesCtrl,
            hintText: 'e.g. penicillin, aspirin',
          ),
        ],
      ),
    );
  }

  // ── Shared widgets ──────────────────────────────────────────────
  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
    ),
  );

  Widget _genderToggle({
    required String selected,
    required void Function(String) onChanged,
  }) {
    return Row(
      children: ['male', 'female'].map((g) {
        final isSelected = selected == g;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(g),
            child: Container(
              margin: EdgeInsets.only(right: g == 'male' ? 8.w : 0),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.grey.withValues(alpha: 0.4),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  g == 'male' ? '♂  Male' : '♀  Female',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: isSelected ? Colors.white : AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          style: GoogleFonts.poppins(fontSize: 13.sp, color: AppColors.black),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e[0].toUpperCase() + e.substring(1)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── BUILD ───────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserRegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Account created successfully 🎉'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/loginScreen',
            (route) => false,
            arguments: 'user',
          );
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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ──────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primary,
                      ),
                      onPressed: _prevStep,
                    ),
                    Expanded(child: _buildProgress()),
                    Text(
                      '${_currentStep + 1}/3',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.grey,
                      ),
                    ),
                    SizedBox(width: 16.w),
                  ],
                ),
              ),

              // ── Step title ───────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _stepTitles[_currentStep],
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'This helps us personalise care.',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),

              // ── Scrollable form pages ────────────────────────
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _scrollable(_step1()),
                    _scrollable(_step2()),
                    _scrollable(_step3()),
                  ],
                ),
              ),

              // ── Bottom button ────────────────────────────────
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                    child: state is UserLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : CustomButton(
                            text: _currentStep < 2
                                ? 'Continue'
                                : 'Create Account',
                            onPressed: _nextStep,
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollable(Widget child) => SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: child,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproj/core/theme/app_colors.dart';
import 'package:gradproj/core/widgets/custom_button.dart';
import 'package:gradproj/core/widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  final String userType;
  const SignUpScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top decoration (simplified)
            Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      'Please complete your data registration to enter the application',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  const CustomTextField(
                    hintText: 'enter your name',
                    labelText: 'User name',
                  ),
                  SizedBox(height: 20.h),
                  const CustomTextField(
                    hintText: 'enter your email',
                    labelText: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h),
                  const CustomTextField(
                    hintText: 'enter your password',
                    labelText: 'Password',
                    obscureText: true,
                    suffixIcon: Icon(
                      Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (v) {},
                        activeColor: AppColors.primary,
                      ),
                      Text(
                        'I agree with privacy policy',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    text: 'Next',
                    onPressed: () {
                      // Handle Sign Up
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

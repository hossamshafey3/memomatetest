import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproj/core/theme/app_colors.dart';
import 'package:gradproj/core/widgets/custom_button.dart';
import 'package:gradproj/core/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  final String userType;
  const LoginScreen({super.key, required this.userType});

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
                  SizedBox(height: 40.h),
                  Center(
                    child: Text(
                      'Log in',
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
                      'Please type your email and password to enter the application',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forget your password?',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      // Handle Login
                    },
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You don't have an account? ",
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/signUpScreen',
                            arguments: userType,
                          );
                        },
                        child: Text(
                          "sign up",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

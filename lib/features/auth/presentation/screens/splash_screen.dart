import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproj/core/theme/app_colors.dart';

import 'package:gradproj/core/widgets/custom_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(), // Spacer
              Column(
                children: [
                  // Placeholder for the brain/hands image
                  // In a real app, use Image.asset('assets/images/logo.png')
                  Icon(
                    Icons.psychology,
                    size: 100.sp,
                    color: AppColors.secondary,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Memomate',
                    style: GoogleFonts.dancingScript(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    'Together we will make each day\nwith memomate a little easier a\nlittle lighter',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: CustomButton(
                  text: 'Get Started',
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/roleSelectionScreen',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

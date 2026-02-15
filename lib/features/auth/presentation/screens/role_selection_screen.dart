import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproj/core/theme/app_colors.dart';
import 'package:gradproj/core/widgets/custom_button.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Top Circle Decoration
          Positioned(
            top: -50.h,
            left: -50.w,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Bottom Circle Decoration
          Positioned(
            bottom: -50.h,
            right: -50.w,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Placeholder for the connected people image
                  Icon(Icons.groups, size: 100.sp, color: AppColors.primary),
                  SizedBox(height: 40.h),
                  Text(
                    'User type:',
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    text: 'Doctor',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/welcomeScreen',
                        arguments: 'Doctor',
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    text: 'User',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/welcomeScreen',
                        arguments: 'User',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

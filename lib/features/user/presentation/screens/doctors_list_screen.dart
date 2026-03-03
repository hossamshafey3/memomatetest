// ─────────────────────────────────────────────────────────────────────────────
//  doctors_list_screen.dart  –  Memomate
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproj/core/theme/app_colors.dart';
import 'package:gradproj/features/user/logic/doctors_list_cubit.dart';

class DoctorsListTabContent extends StatefulWidget {
  final String userId;
  final bool isAcceptedOnly;

  const DoctorsListTabContent({
    super.key,
    required this.userId,
    required this.isAcceptedOnly,
  });

  @override
  State<DoctorsListTabContent> createState() => _DoctorsListTabContentState();
}

class _DoctorsListTabContentState extends State<DoctorsListTabContent> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header / Search ────────────────────────────────────
        Container(
          padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
          color: AppColors.background,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Icon(
                          Icons.search,
                          color: AppColors.black,
                          size: 24.r,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: InputDecoration(
                            hintText: 'Search a doctor',
                            hintStyle: GoogleFonts.playfairDisplay(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary.withValues(alpha: 0.6),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              bottom: 4.h,
                            ), // align center
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                          onChanged: (val) {
                            setState(() {}); // trigger rebuild to filter
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Grid ───────────────────────────────────────────────
        Expanded(
          child: BlocBuilder<DoctorsListCubit, DoctorsListState>(
            builder: (context, state) {
              if (state is DoctorsListLoading || state is DoctorsListInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (state is DoctorsListFailure) {
                return Center(
                  child: Text(
                    state.message,
                    style: GoogleFonts.poppins(color: AppColors.error),
                  ),
                );
              }

              if (state is DoctorsListSuccess) {
                // Filter by search query and accepted only
                final query = _searchCtrl.text.toLowerCase();
                final doctors = state.doctors.where((d) {
                  // Only include if `isAcceptedOnly` is false OR if it's true, check if `patients` contains userId
                  final matchesAccepted =
                      !widget.isAcceptedOnly ||
                      d.patients.contains(widget.userId);
                  final matchesSearch = d.name.toLowerCase().contains(query);
                  return matchesAccepted && matchesSearch;
                }).toList();

                if (doctors.isEmpty) {
                  return Center(
                    child: Text(
                      widget.isAcceptedOnly
                          ? 'You have no accepted doctors yet'
                          : 'No doctors found',
                      style: GoogleFonts.poppins(color: AppColors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: 16.w,
                    top: 4.h,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return _DoctorCard(
                      name: doctor.name,
                      image: doctor.image,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/doctorDetailsScreen',
                          arguments: doctor,
                        );
                      },
                      onRequest: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Request sent to ${doctor.name}'),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback onTap;
  final VoidCallback onRequest;

  const _DoctorCard({
    required this.name,
    required this.image,
    required this.onTap,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: 40.r,
                backgroundColor: AppColors.background,
                backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                child: image.isEmpty
                    ? Icon(Icons.person, size: 40.r, color: AppColors.primary)
                    : null,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              name,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: onRequest,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.symmetric(vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Request',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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

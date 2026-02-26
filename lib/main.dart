import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradproj/app_router.dart';
import 'package:gradproj/core/theme/app_colors.dart';
import 'package:gradproj/features/doctor/data/data_sources/doctor_remote_data_source.dart';
import 'package:gradproj/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:gradproj/features/doctor/logic/doctor_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Dependency construction ──────────────────────────────────
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    final dataSource = DoctorRemoteDataSourceImpl(dio);
    final repository = DoctorRepositoryImpl(dataSource);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<DoctorCubit>(
          create: (_) => DoctorCubit(repository),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Memomate',
            theme: ThemeData(
              primaryColor: AppColors.primary,
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              useMaterial3: true,
            ),
            onGenerateRoute: AppRouter().generateRoute,
            initialRoute: Routes.splashScreen,
          ),
        );
      },
    );
  }
}

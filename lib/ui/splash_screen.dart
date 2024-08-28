import 'dart:async';
import 'package:e_commerce_app_with_firebase/constant/Colors/app_colors.dart';
import 'package:e_commerce_app_with_firebase/constant/Strings/app_string.dart';
import 'package:e_commerce_app_with_firebase/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),(){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>const LoginScreen(),
      ),
      );
     },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppString.splashScreenTitle,
                style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 44.sp,
                ),
              ),
              SizedBox(height: 5.h),
              CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

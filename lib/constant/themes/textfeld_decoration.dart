import 'package:e_commerce_app_with_firebase/constant/Colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldDecoration{
  static InputDecorationTheme getTextFormField(){
    return  InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 12.sp,
        color: AppColors.grey,
      ),
      labelStyle: TextStyle(
        fontSize: 15.sp,
        color: AppColors.deep_orange,
      ),
    );
  }
}
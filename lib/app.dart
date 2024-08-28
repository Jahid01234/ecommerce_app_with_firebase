import 'package:e_commerce_app_with_firebase/constant/themes/app_bar_style.dart';
import 'package:e_commerce_app_with_firebase/constant/themes/textfeld_decoration.dart';
import 'package:e_commerce_app_with_firebase/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375,812),// set fixed screen (width,height)
      builder: (_,child){
        return MaterialApp(
          title: "E-commerce App",
          debugShowCheckedModeBanner: false,
          home:  const SplashScreen(),
          theme: ThemeData(
            appBarTheme:AppBarStyle.appBarStyle(),
            inputDecorationTheme: TextFormFieldDecoration.getTextFormField()
          ),
        );
      },
    );
  }
}
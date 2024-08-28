import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/constant/Strings/app_string.dart';
import 'package:e_commerce_app_with_firebase/ui/main_bottom_nav_screen.dart';
import 'package:e_commerce_app_with_firebase/ui/registration_screen.dart';
import 'package:e_commerce_app_with_firebase/ui/user_form.dart';
import 'package:e_commerce_app_with_firebase/widgets/showDialog_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/Colors/app_colors.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;


  // Login user with Firebase
  Future<void> _loginUser() async {
    // Show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      // Sign-In the user
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final authCredential = userCredential.user;
      if (authCredential != null && authCredential.uid.isNotEmpty) {
        // Check if the user has filled the form
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('user-form_data')
            .doc(authCredential.email)
            .get();

        Navigator.pop(context); // Remove the loading circle

        if (userData.exists) {
          // If data exists, go to MainBottomNavScreen
          if (mounted) {
            displayMessageToUser("Login is successful!", context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainBottomNavScreen()),
            );
          }
        } else {
          // If data does not exist, go to UserForm
          if (mounted) {
            displayMessageToUser("Please fill out your profile information", context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserForm()),
            );
          }
        }
      } else {
        if (mounted) {
          displayMessageToUser("Something is wrong!", context);
        }
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Remove the loading circle

      if (e.code == 'user-not-found') {
        if (mounted) {
          displayMessageToUser("No user found for that email!", context);
        }
      } else if (e.code == 'wrong-password') {
        if (mounted) {
          displayMessageToUser("Wrong password provided for that user", context);
        }
      } else {
        if (mounted) {
          displayMessageToUser("An error occurred: ${e.message}", context);
        }
      }
    } catch (e) {
      Navigator.pop(context); // Remove the loading circle
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: Column(
          children: [
            // 1st layer
            SizedBox(
              height: 150.h,
              width: ScreenUtil().screenWidth,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w,top: 50.h),
                child: Text(
                  AppString.loginPageTitle,
                  style: TextStyle(fontSize: 22.sp, color: Colors.white),
                ),
              ),
            ),

            // 2nd layer
            Expanded(
              child: Container(
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            AppString.welcomeText,
                            style: TextStyle(
                                fontSize: 22.sp, color: AppColors.deep_orange,
                            ),
                          ),
                          Text(
                            AppString.gladText,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 48.h,
                                width: 41.w,
                                decoration: BoxDecoration(
                                    color: AppColors.deep_orange,
                                    borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: 20.w,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    hintText: AppString.hintTextMail,
                                    labelText: AppString.emailText,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 48.h,
                                width: 41.w,
                                decoration: BoxDecoration(
                                    color: AppColors.deep_orange,
                                    borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.lock_outline,
                                    color: Colors.white,
                                    size: 20.w,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _showPassword == false,
                                  decoration: InputDecoration(
                                    hintText: AppString.hintPassword,
                                    labelText: AppString.passwordText,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _showPassword
                                            ?Icons.visibility
                                            :Icons.visibility_off,
                                        color: AppColors.grey,
                                      ),
                                      onPressed: (){
                                        _showPassword = !_showPassword;
                                        if(mounted){
                                          setState(() {});
                                        }
                                      },

                                    ),
                                  ),
                                  validator: (value){
                                    if(value==null || value.isEmpty){
                                      return "Please enter password";
                                    }
                                    else if(value.length<=7){
                                      return " please enter 8 character";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 50.h,
                          ),

                          SizedBox(
                            height: 20.h,
                          ),

                          SizedBox(
                            height: 56.h,
                            width: 1.sw,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.deep_orange,
                                elevation: 2
                              ),
                              child: Text(AppString.signInText,style: TextStyle(color: AppColors.white, fontSize: 14.sp),),
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  _loginUser();
                                }
                              },
                            ),
                          ),

                          SizedBox(
                            height: 20.h,
                          ),

                          Center(
                            child: Wrap(
                              children: [
                                Text(
                                  AppString.accountText,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  child: Text(
                                    AppString.signUpText,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deep_orange,
                                    ),
                                  ),
                                  onTap: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegistrationScreen(),
                                   ),
                                   );
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
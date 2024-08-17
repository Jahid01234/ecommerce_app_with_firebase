import 'package:e_commerce_app_with_firebase/constant/Strings/app_string.dart';
import 'package:e_commerce_app_with_firebase/ui/login_screen.dart';
import 'package:e_commerce_app_with_firebase/widgets/showDialog_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/Colors/app_colors.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  
  // Register user with Firebase
  Future<void> _registerUser() async{
    // loading circle
    showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    //  create the user
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email:_emailController.text ,
              password: _passwordController.text
          );

      final authCredential = userCredential.user;
      if(authCredential!.uid.isNotEmpty) {
        if (mounted) {
          displayMessageToUser("Registration is successful!", context);
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginScreen(),
            ),
          );
        }
      }else{
        if (mounted) {
          displayMessageToUser("Something is wrong!", context);
        }
      }

    } on FirebaseAuthException catch(e){
        if(e.code == 'weak-password'){
          if (mounted) {
            displayMessageToUser("The password provided is too weak!", context);
          }
        }else if(e.code == 'email-already-in-use'){
          if (mounted) {
            displayMessageToUser("The account already exists for that email", context);
          }
        }
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
                  AppString.registrationPageTitle,
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

                          // elevated button
                          // customButton("Sign In", (){
                          //   signIn();
                          // },),

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
                              child: Text(AppString.continueText,
                                style: TextStyle(color: AppColors.white, fontSize: 14.sp,
                                ),
                              ),
                              onPressed: (){
                                if(_formKey.currentState!.validate()) {
                                  _registerUser();
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
                                    AppString.signInText,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deep_orange,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen(),
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
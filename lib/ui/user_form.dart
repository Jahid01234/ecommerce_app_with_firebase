import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/constant/Colors/app_colors.dart';
import 'package:e_commerce_app_with_firebase/constant/Strings/app_string.dart';
import 'package:e_commerce_app_with_firebase/ui/main_bottom_nav_screen.dart';
import 'package:e_commerce_app_with_firebase/widgets/showDialog_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {

  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _phoneNumberTextEditingController = TextEditingController();
  final TextEditingController _dobTextEditingController = TextEditingController();
  final TextEditingController _genderTextEditingController = TextEditingController();
  final TextEditingController _ageTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext context) async{
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        firstDate:  DateTime(1900),
        lastDate:  DateTime(2100)
    );
    if(datePicked !=null) {
      setState(() {
         _dobTextEditingController.text = "${datePicked.day}/ ${datePicked.month}/ ${datePicked.year}";
        });
    }
  }

  Widget _selectGender() {
   return DropdownButton<String>(
      items: gender.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
          onTap: () {
            setState(() {
              _genderTextEditingController.text = value;
            });
          },
        );
      }).toList(),
      onChanged: (_) {},
    );
  }

  // sent data to FireStore Database
  Future<void> _sendData(context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if(currentUser == null){
      displayMessageToUser("User is not logged in!", context);
      return;
    }

    try {
      CollectionReference collectionRef =  FirebaseFirestore.instance.collection("user-form_data");
      await collectionRef.doc(currentUser.email).set({
        "name":_nameTextEditingController.text,
        "phone":_phoneNumberTextEditingController.text,
        "dob":_dobTextEditingController.text,
        "gender":_genderTextEditingController.text,
        "age":_ageTextEditingController.text,
      });

      displayMessageToUser("Data sent successfully!", context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainBottomNavScreen(),
        ),
      );
  }catch(e){
      displayMessageToUser("Failed to send data: $e", context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key:_formKey ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Submit the form to continue.",
                    style:
                    TextStyle(fontSize: 22.sp, color: AppColors.deep_orange),
                  ),
                  Text(
                    "We will not share your information with anyone.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),

                  // Name TextFormField
                  TextFormField(
                    controller: _nameTextEditingController,
                    decoration: const InputDecoration(
                      hintText: "Enter your name",
                      labelText: "Name",
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                    validator: ( value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                      keyboardType: TextInputType.name,


                  ),
                  SizedBox(
                    height: 15.h,
                  ),

                  // Phone number TextFormField
                  TextFormField(
                    controller: _phoneNumberTextEditingController,
                    decoration: const InputDecoration(
                      hintText: "Enter your phone number",
                      labelText: "Phone Number",
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                   // maxLength: 11,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number.';
                      }

                      if (!RegExp(r'^(\+)|\d{11}$').hasMatch(value)) {
                        return 'Enter a valid phone number.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,


                  ),
                  SizedBox(
                    height: 15.h,
                  ),

                  // Date of Birth TextFormField
                  TextFormField(
                    controller: _dobTextEditingController,
                    decoration:  InputDecoration(
                      hintText: "Enter your dob",
                      labelText: "Date of Birth",
                      enabledBorder: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed:() {
                            _selectDateFromPicker(context);
                            },
                          icon: const Icon(Icons.calendar_month)
                      ),
                    ),
                    readOnly: true, //set it true, so that user will not able to edit text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your DOB.';
                      }
                      return null;
                    },


                  ),
                  SizedBox(
                    height: 15.h,
                  ),

                  // Gender TextFormField
                  TextFormField(
                    controller: _genderTextEditingController,
                    decoration:  InputDecoration(
                      hintText: "Enter your gender",
                      labelText: "Gender",
                      enabledBorder: const OutlineInputBorder(),
                      focusedBorder:const OutlineInputBorder(),
                      suffixIcon: _selectGender(),
                    ),
                    // maxLength: 11,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your gender.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,


                  ),
                  SizedBox(
                    height: 15.h,
                  ),


                  // Age TextFormField
                  TextFormField(
                    controller: _ageTextEditingController,
                    decoration:  const InputDecoration(
                      hintText: "Enter your age",
                      labelText: "Age",
                      enabledBorder:  OutlineInputBorder(),
                      focusedBorder:  OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age.';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 35.h,
                  ),

                  SizedBox(
                    height: 56.h,
                    width: 1.sw,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deep_orange,
                          elevation: 2
                      ),
                      child: Text(AppString.submitText,style: TextStyle(color: AppColors.white, fontSize: 14.sp),),
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _sendData(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

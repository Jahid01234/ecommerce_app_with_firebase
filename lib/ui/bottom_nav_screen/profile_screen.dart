import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/constant/Colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant/Strings/app_string.dart';
import '../../widgets/showDialog_message.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   TextEditingController _nameTextEditingController = TextEditingController();
   TextEditingController _phoneNumberTextEditingController = TextEditingController();
   TextEditingController _dobTextEditingController = TextEditingController();
   TextEditingController _genderTextEditingController = TextEditingController() ;
   TextEditingController _ageTextEditingController = TextEditingController() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("Update User Information",style: TextStyle(fontSize: 18,color: Colors.white),),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("user-form_data").doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("Something went wrong: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data == null ||
                    !snapshot.data!.exists) {
                  return const Center(child: Text("No data available"));
                } else {
                  var myData = snapshot.data!.data();
                  return setDataToTextFormField(myData);
                }
              },
            ),
          ),
        ),
      ),
    );
  }


   Future<void> updateData() async{
     CollectionReference _collectionRef = FirebaseFirestore.instance.collection("user-form_data");
    await _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update(
         {
           "name":_nameTextEditingController.text,
           "phone":_phoneNumberTextEditingController.text,
           "age":_ageTextEditingController.text,
           "dob" : _dobTextEditingController.text,
           "gender": _genderTextEditingController.text
         }
     ).then((value) =>
         displayMessageToUser("Update is successful!",context),
     );

   }


  Widget setDataToTextFormField(myData) {
    return Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person,size: 50,),
              ),
              SizedBox(
                height: 15.h,
              ),
              // Name TextFormField
              TextFormField(
                controller: _nameTextEditingController = TextEditingController(text: myData?["name"] ),
                decoration: const InputDecoration(
                    labelText: "Name",
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                ),
              ),

              SizedBox(
                height: 15.h,
              ),

              // Phone number TextFormField
              TextFormField(
                controller: _phoneNumberTextEditingController = TextEditingController(text: myData?["phone"] ),
                decoration: const InputDecoration(
                    labelText: "Phone Number",
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                ),
              ),

              SizedBox(
                height: 15.h,
              ),

              // Date of Birth TextFormField
              TextFormField(
                controller: _dobTextEditingController = TextEditingController(text: myData?["dob"] ),
                decoration: const InputDecoration(
                    labelText: "Date of Birth",
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                ),
              ),

              SizedBox(
                height: 15.h,
              ),

              // Gender TextFormField
              TextFormField(
                controller: _genderTextEditingController = TextEditingController(text: myData?["gender"] ),
                decoration: const InputDecoration(
                    labelText: "Gender",
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                ),
              ),

              SizedBox(
                height: 15.h,
              ),

              // Age TextFormField
              TextFormField(
                controller: _ageTextEditingController = TextEditingController(text: myData?["age"] ),
                decoration: const InputDecoration(
                    labelText: "Age",
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                ),
              ),

              SizedBox(
                height: 35.h,
              ),

              SizedBox(
                height: 56.h,
                width: 1.sw,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deep_orange, elevation: 2),
                  child: Text(
                    AppString.updateText,
                    style:
                        TextStyle(color: AppColors.white, fontSize: 14.sp),
                  ),
                  onPressed: () {updateData();},
                ),
              ),
            ],
          );
  }

}





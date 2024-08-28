import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/ui/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String inputText= '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Page"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                //controller: _searchTEController,
                onChanged: (value){
                  inputText=value;
                  setState(() {});
                  },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search by product',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.cyan,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              const Text("Search Product List",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8.h),
              Expanded(
                  child: Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.
                      collection("products").where("product-name",isEqualTo: inputText).snapshots(),
                      builder: (context,snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ) {
                          return const Center(child: Text('No photos found'));
                        } else {
                           return ListView(
                             children: snapshot.data!.docs.map((DocumentSnapshot document){
                                 Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                 return GestureDetector(
                                   onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailsScreen(product: data,)));
                                   },
                                   child: Card(
                                     child: ListTile(
                                       title: Text(data["product-name"]),
                                       leading: Image.network(data["product-img"][0]),
                                     ),
                                   ),
                                 );
                             }).toList(),
                           );
                          }
                      },
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

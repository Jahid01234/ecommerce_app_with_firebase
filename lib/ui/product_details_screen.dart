import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_commerce_app_with_firebase/constant/Colors/app_colors.dart';
import 'package:e_commerce_app_with_firebase/constant/Strings/app_string.dart';
import 'package:e_commerce_app_with_firebase/widgets/showDialog_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsScreen extends StatefulWidget {
   var product;

   ProductDetailsScreen({
    super.key,
    required this.product
  });


  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _dotsPosition = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_orange,
            child: IconButton(onPressed: () {
              Navigator.pop(context);
            },
              icon: const Icon(Icons.arrow_back),
              color: AppColors.white,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.deep_orange,
              child: IconButton(
                onPressed: () {
                  toggleFavorite(context);
                },
                icon: Icon(
                  _isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border, // Change icon based on favorite status
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20,),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // show product image
                AspectRatio(
                  aspectRatio: 2.5,
                  child: CarouselSlider(
                    items: widget.product["product-img"]
                        .map<Widget>(
                          (item) =>
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                    )
                        .toList(),
                    options: CarouselOptions(
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                      const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      onPageChanged: (value, carouselPageChangedReason) {
                        setState(() {
                          _dotsPosition = value;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),

                // Dots Indicator show
                SizedBox(height: 20.h),
                Center(
                  child: DotsIndicator(
                    dotsCount: widget.product.isEmpty ? 1 : widget.product.length,
                    position: _dotsPosition,
                    decorator: const DotsDecorator(
                      activeColor: AppColors.deep_orange,
                    ),
                  ),
                ),

                //  show product name
                SizedBox(height: 20.h),
                Text(widget.product["product-name"], style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
                ),

                //  show product price
                SizedBox(height: 5.h),
                RichText(
                  text: TextSpan(
                      text: "Price: ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "\$${widget.product["product-price"]}".toString(),
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ]
                  ),
                ),

                //  show product description
                SizedBox(height: 10.h),
                Text(widget.product["product-description"],
                  style: const TextStyle(), textAlign: TextAlign.justify,
                ),

                //  show product description
                SizedBox(height: 50.h),
                SizedBox(
                  height: 56.h,
                  width: 1.sw,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deep_orange,
                        elevation: 2
                    ),
                    child: Text(AppString.addToCartText,
                      style: TextStyle(color: AppColors.white, fontSize: 14.sp,
                      ),
                    ),
                    onPressed: () {
                      addToCart(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Add product item to Cart
  Future<void> addToCart(context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final currentUser = firebaseAuth.currentUser;

    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("user-cart-item");
    await collectionReference.doc(currentUser!.email).collection("items")
        .doc()
        .set({
      "name": widget.product["product-name"],
      "price": widget.product["product-price"],
      "images": widget.product["product-img"],
    });
    displayMessageToUser("Add to cart successfully!", context);
  }

  // Add product item to Favourite
  Future<void> toggleFavorite(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final currentUser = firebaseAuth.currentUser;

    if (currentUser != null) {
      CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("user-favourite-item");

      if (_isFavorite) {
        // Remove from favorites
        await collectionReference
            .doc(currentUser.email)
            .collection("items")
            .where("name", isEqualTo: widget.product["product-name"])
            .limit(1)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete(); // Delete the document
          }
        });
        displayMessageToUser("Removed from favorites!", context);
      } else {

        // Add to favorites
        await collectionReference.doc(currentUser.email)
            .collection("items")
            .doc()
            .set({
          "name": widget.product["product-name"],
          "price": widget.product["product-price"],
          "images": widget.product["product-img"],
        });
        displayMessageToUser("Added to favorites!", context);
      }

      // Update the favorite status
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  // Function to check if product is already in favorites
  Future<void> checkIfFavorite() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final currentUser = firebaseAuth.currentUser;

    if (currentUser != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("user-favourite-item")
          .doc(currentUser.email)
          .collection("items")
          .where("name", isEqualTo: widget.product["product-name"])
          .limit(1)
          .get();

      setState(() {
        _isFavorite = snapshot.docs.isNotEmpty; // Set favorite status
      });
    }
  }


}

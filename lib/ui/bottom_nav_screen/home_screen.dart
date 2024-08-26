import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_commerce_app_with_firebase/constant/Colors/app_colors.dart';
import 'package:e_commerce_app_with_firebase/ui/product_details_screen.dart';
import 'package:e_commerce_app_with_firebase/ui/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchTEController = TextEditingController();
  final List<String> carouselImagesList = [];
  final List productsList = [];
  int _dotsPosition = 0;

  // Get CarouselImages data from firebase
  Future<void> _getCarouselImages() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firebaseFirestore.collection("carousel-slider").get();

    for (int i = 0; i < qn.docs.length; i++) {
      setState(() {
        carouselImagesList.add(
          qn.docs[i]["img-path"],
        );
      });
    }
  }

  // Get Product data from firebase
  Future<void> _getProductDetails() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firebaseFirestore.collection("products").get();

    for (int i = 0; i < qn.docs.length; i++) {
      setState(() {
        productsList.add({
          "product-name": qn.docs[i]["product-name"],
          "product-description": qn.docs[i]["product-description"],
          "product-img": qn.docs[i]["product-img"],
          "product-price": qn.docs[i]["product-price"]
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCarouselImages();
    _getProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false ,
      appBar: AppBar(
        title: const Text("E-Commerce"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // search box
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60.h,
                      child: TextFormField(
                        controller: _searchTEController,
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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SearchScreen()));
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                          color: AppColors.deep_orange,
                          borderRadius: BorderRadius.circular(0),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),


              // show image
              SizedBox(height: 20.h),
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                  items: carouselImagesList
                      .map(
                        (item) => ClipRRect(
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
              SizedBox(height: 10.h),
              DotsIndicator(
                dotsCount: carouselImagesList.isEmpty ? 1 : carouselImagesList.length,
                position: _dotsPosition,
                decorator: const DotsDecorator(
                  activeColor: AppColors.deep_orange,
                ),
              ),

              // Text Part(top Products,view all)
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Top Products",
                    style:  TextStyle(
                      color: AppColors.deep_orange,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "View All",
                        style: TextStyle(
                          color: AppColors.deep_orange,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(Icons.arrow_forward_ios,
                            size: 15, color: AppColors.deep_orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),


              // show product details
              SizedBox(height: 15.h),
              Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>ProductDetailsScreen(product: productsList[index]),
                        ),
                        );
                      },
                      child: Card(
                        elevation: 1,
                        child: Column(
                          children: [
                            AspectRatio(
                                aspectRatio: 2,
                                child: Image.network(
                                    productsList[index]["product-img"][0],
                                    fit: BoxFit.fill)),
                            SizedBox(height: 10.h),
                            Text(
                              "${productsList[index]["product-name"]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text("${productsList[index]["product-price"]}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

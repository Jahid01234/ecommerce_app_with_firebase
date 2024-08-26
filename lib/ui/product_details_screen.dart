import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_commerce_app_with_firebase/constant/Colors/app_colors.dart';
import 'package:e_commerce_app_with_firebase/constant/Strings/app_string.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_orange,
            child: IconButton(onPressed: (){
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
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              },
                icon: const Icon(Icons.favorite),
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // show product image
              AspectRatio(
                aspectRatio: 2.5,
                 child: CarouselSlider(
                  items: widget.product["product-img"]
                      .map<Widget>(
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
              Text(widget.product["product-name"],style: const TextStyle(
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
              Text(widget.product["product-description"],style: const TextStyle(),textAlign: TextAlign.justify,),

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
                  child: Text(AppString.addToCartText,style: TextStyle(color: AppColors.white, fontSize: 14.sp),),
                  onPressed: (){
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

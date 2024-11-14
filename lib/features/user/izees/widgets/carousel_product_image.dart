import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:izees/resources/strings_res.dart';

class ProductCarousel extends StatelessWidget {
  final List<File> imageUrls; // List of image URLs

  const ProductCarousel({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: imageUrls.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 10),
          child: Container(
              // height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width ,
           // margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.network(
              "${StringsRes.uri}/${imageUrls[index].path}",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
            ),
          ),
        );
      },
      options: CarouselOptions(
        viewportFraction: 1,

        height: MediaQuery.of(context).size.height * 0.3,
        autoPlay: false, // Enable autoplay
      //  enlargeCenterPage: true, // Enlarge the center page
       // enableInfiniteScroll: true, // Infinite scroll
        scrollDirection: Axis.horizontal, // Horizontal scrolling
      ),
    );
  }
}

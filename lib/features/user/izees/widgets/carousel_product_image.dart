import 'dart:io';


import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:izees/resources/strings_res.dart';


class ProductCarousel extends StatelessWidget {
  final List<String> imageUrls;


  const ProductCarousel({Key? key, required this.imageUrls}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: imageUrls.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
          child: AspectRatio(
            aspectRatio: 3 / 2, // 👈 Set your desired aspect ratio here
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "${StringsRes.uri}/${imageUrls[index]}",
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlay: false,
        height: MediaQuery.of(context).size.height * 0.56, // Set the height you want


      ),
    );
  }
}




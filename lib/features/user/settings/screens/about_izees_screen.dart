import 'package:flutter/material.dart';
import 'package:izees/resources/strings_res.dart';
class AboutIzeesScreen extends StatelessWidget {
  const AboutIzeesScreen({super.key});
  static const  routeName = '/about-izees';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: ColorManager.primaryColor,),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
         // SizedBox(height: 12,),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('We are Izees App , Market for perfumes were you can find your memory perfume ',style: TextStyle(fontSize: 20),),
          ),
         // SizedBox(height: 300,),
          Center(
            child: Container(

              //color: Colors.green,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration:    BoxDecoration(

                // shape: BoxShape.circle,
                //  border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(30),
                image:  const DecorationImage(image: AssetImage("assets/images/izeesjo.jpg") ,
                  //    fit: BoxFit.contain,
                )  ,
              ),

            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Instagram: izeesjo',style: TextStyle(fontSize: 15)),
          ),
          const SizedBox(height: 20,),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Email: izeesjo@gmail.com',style: TextStyle(fontSize: 15)),
          ),

        ],
      ),
    );
  }
}

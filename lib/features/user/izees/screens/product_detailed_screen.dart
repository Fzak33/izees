import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/custom_button.dart';
import 'package:izees/features/user/izees/services/recommended/recommended_cubit.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cart/services/cart_service_cubit/cart_services_cubit.dart';
import '../widgets/carousel_product_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailedScreen extends StatelessWidget {
  static const routeName = '/product-detailed';
  final Product product;
  const ProductDetailedScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff56f133),
        title: Text('${product.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 10 ),
            //   child: Container(
            //     //color: Colors.green,
            //     height: MediaQuery.of(context).size.height * 0.3,
            //    width: MediaQuery.of(context).size.width ,
            //     decoration:    BoxDecoration(
            //       // shape: BoxShape.circle,
            //       border: Border.all(color: Colors.blueGrey),
            //       borderRadius: BorderRadius.circular(15),
            //       image:  DecorationImage(image: NetworkImage("${StringsRes.uri}/${product.images[0].path}") ,
            //         fit: BoxFit.fitHeight,
            //       ),
            //     ),
            //
            //   ),
            // ),
            ProductCarousel(imageUrls: product.images,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(text: localization.addToCart, onTap: ()async{


                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  String user = ( prefs.getString('x-auth-token'))!;
                  if(user == '' || user.isEmpty || user == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localization.firstLogIn)));
                  }else{
                    context.read<CartServicesCubit>().addToCart(id: product.id ??'', context: context, );

                  }


                }, color: Color(0xff50C878),),
              ),
              SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text( style: const TextStyle(fontSize: 13), localization.productName,
              textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text( style: const TextStyle(fontSize: 20), '${product.name} - ${product.price} ${localization.jod} '),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text( style: const TextStyle(fontSize: 13), localization.productName,
                textAlign: TextAlign.start,
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text( style: const TextStyle(fontSize: 20), '${product.description}'),
              ),
            const SizedBox(height: 30,),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(localization.recommendedForYou ,style: const TextStyle(fontSize: 18),),
            ),
            SizedBox(
              height: 200,
              child: BlocBuilder<RecommendedCubit, RecommendedState>(

  builder: (context, state) {
    if(state is RecommendedLoading){
      return const Center(child: CircularProgressIndicator(),);
    }
    else if(state is RecommendedFailed){
      return Center(child: Text(state.err),);
    }
    else if(state is RecommendedSuccess){
      final product = state.product;
      return ListView.builder(

        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: product.length,
        itemBuilder: (context, index) {
          final prod =product[index];
          return  InkWell(
            onTap: (){
              Navigator.pushNamed(context, ProductDetailedScreen.routeName, arguments: prod);
              context.read<RecommendedCubit>().recommended(category: prod.category);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width:  100,
                      decoration:    BoxDecoration(
                        shape: BoxShape.rectangle,
                        image:  DecorationImage(image: NetworkImage("${StringsRes.uri}/${prod.images[0].path}")  ,)  ,
                      ),
                    ),
                    SizedBox(height: 2,),
                    Text('${prod.name}', style: TextStyle(fontSize: 15),)
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
    else{
      return Center(child: Text("something occurd"),);
    }
  },
),
            )
            
          ],
        ),
      ),
    );
  }
}

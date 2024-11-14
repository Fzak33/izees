import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/custom_button.dart';
import 'package:izees/features/user/izees/services/recommended/recommended_cubit.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cart/services/cart_cubit/cart_cubit.dart';
import '../widgets/carousel_product_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailedScreen extends StatefulWidget {
  static const routeName = '/product-detailed';
  final Product product;
  const ProductDetailedScreen({super.key, required this.product});

  @override
  State<ProductDetailedScreen> createState() => _ProductDetailedScreenState();
}

class _ProductDetailedScreenState extends State<ProductDetailedScreen> {
  String? _user;


  @override
  void initState() {
    super.initState();
    getUser();

  }

  void getUser()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    _user =   prefs.getString('x-auth-token')?? '';

  }


  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return  Scaffold(
      appBar: AppBar(
        backgroundColor:ColorManager.primaryColor,
        title: Text('${widget.product.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ProductCarousel(imageUrls: widget.product.images,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(text: localization.addToCart, onTap: ()async{



                  if(_user == '' || _user!.isEmpty || _user == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localization.firstLogIn)));
                  }else{
                    context.read<CartCubit>().addToCart(product: widget.product,id: widget.product.id ??'', context: context, );

                  }


                }, color: ColorManager.primaryColor,),
              ),
              const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text( style: const TextStyle(fontSize: 13), localization.productName,
              textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text( style: const TextStyle(fontSize: 20), '${widget.product.name} - ${widget.product.price} ${localization.jod} '),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text( style: const TextStyle(fontSize: 13), localization.productName,
                textAlign: TextAlign.start,
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text( style: const TextStyle(fontSize: 20), '${widget.product.description}'),
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
                    const SizedBox(height: 2,),
                    Text('${prod.name}', style: const TextStyle(fontSize: 15),)
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
    else{
      return const Center(child: Text("something occurd"),);
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

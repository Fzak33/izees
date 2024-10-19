
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/user/izees/screens/product_detailed_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/strings_res.dart';
import '../../cart/services/cart_service_cubit/cart_services_cubit.dart';
import '../services/recommended/recommended_cubit.dart';
import '../services/show_category_products_cubit/show_category_products_cubit.dart';
import '../services/show_product_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CategoryProductScreen extends StatefulWidget {
  static const String routeName ='/show-category-products';
  String category;
  CategoryProductScreen({super.key, required this.category});

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {

  final ScrollController _scrollController = ScrollController();
  late ShowCategoryProductsCubit _showCategoryProductsCubit;

  @override
  void initState() {
    super.initState();
    _showCategoryProductsCubit = ShowCategoryProductsCubit(ShowProductServices());
    _showCategoryProductsCubit.showCategoryProducts(category: widget.category);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          0.7 * _scrollController.position.maxScrollExtent) {
        _showCategoryProductsCubit.showCategoryProducts(category: widget.category);
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<ShowCategoryProductsCubit,ShowCategoryProductsState>(
        bloc: _showCategoryProductsCubit,
        builder: (context, state) {

    if(state is ShowCategoryProductsLoading){
    return const Center(child: CircularProgressIndicator(),);
    }
    else if(state is ShowCategoryProductsFailed){
    return  Center(child:Text(state.err),);
    }
    else if(state is ShowCategoryProductsSuccess) {
      final product = state.product;
      return  Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,

                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 6.0, // Spacing between rows
                  childAspectRatio: 0.55
              ),
              //   physics: BouncingScrollPhysics(),
              clipBehavior: Clip.hardEdge,
            //  physics: NeverScrollableScrollPhysics(),
              //  padding: const EdgeInsets.only(bottom: 110, top: 20),
              scrollDirection: Axis.vertical,
              itemCount: product.length,
              itemBuilder: (context, index){
                final prod = product[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap:(){
                            Navigator.pushNamed(context, ProductDetailedScreen.routeName, arguments: prod);
                            context.read<RecommendedCubit>().recommended(category: prod.category);
                          },
                          child: Container(

                            //color: Colors.green,
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration:    BoxDecoration(
                              // shape: BoxShape.circle,
                              border: Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(15),
                              image:  DecorationImage(image: NetworkImage("${StringsRes.uri}/${prod.images[0].path}") ,
                                fit: BoxFit.fitHeight,
                              )  ,
                            ),

                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          child: Text(prod.name,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          child: Text("${prod.price}",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2,  horizontal: 10),
                          child: Text("${prod.quantity}",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black
                            ),),
                        ),
                        ElevatedButton(onPressed: ()async{
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          String user = ( prefs.getString('x-auth-token'))!;
                          if(user == '' || user.isEmpty || user == null){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(localization.firstLogIn)));
                          }else{
                            context.read<CartServicesCubit>().addToCart(id: prod.id ??'', context: context, );

                          }

                        }, style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green
                        ), child: Text(localization.addToCart, style: const TextStyle(color: Colors.black),),),
                      ],
                    ),
                  ),
                );
              }

          )

      );
    }
    else{
      return const Center(child: Text('something went wrong'),);
    }
        },
      ),
    );
  }
}

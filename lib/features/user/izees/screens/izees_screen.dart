import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/user/cart/services/cart_service_cubit/cart_services_cubit.dart';
import 'package:izees/features/user/izees/screens/product_detailed_screen.dart';
import 'package:izees/features/user/izees/services/show_product_cubit/show_products_cubit.dart';
import 'package:izees/features/user/izees/services/show_product_services.dart';
import 'package:izees/models/cart_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/widgets/category_widget.dart';
import '../../../auth/auth_cubit/auth_cubit.dart';
import '../../cart/services/cart_cubit/cart_cubit.dart';
import '../services/recommended/recommended_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IzeesScreen extends StatefulWidget {
  const IzeesScreen({super.key});

  @override
  State<IzeesScreen> createState() => _IzeesScreenState();
}

class _IzeesScreenState extends State<IzeesScreen> {
  final ScrollController _scrollController = ScrollController();
  late ShowProductsCubit _showProductsCubit;
  String? _user;

  @override
  void initState() {
    super.initState();
    getUser();
    _showProductsCubit = ShowProductsCubit(ShowProductServices());
    _showProductsCubit.scheduleHourlyFetch(context: context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          0.7 * _scrollController.position.maxScrollExtent) {
        _showProductsCubit.showProducts();
      }
    });
  }



  void getUser()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    _user =   prefs.getString('x-auth-token')?? '';

  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    // final auth = context.read<AuthCubit>();
    return   BlocBuilder<ShowProductsCubit, ShowProductsState>(
      bloc: _showProductsCubit,
  builder: (context, state) {
    if(state is ShowProductsLoading){
      return const Center(child: CircularProgressIndicator(),);
    }
    else if(state is ShowProductsFailed){
      return  Center(child:Text(state.err),);
    }
    else if(state is ShowProductsSuccess){
      final product = state.product;
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Text(localization.categories,
                  style: const TextStyle(
                      fontSize: 24
                  ),
                ),
              ),
              CategoryWidget(),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10, ),
                child: Text(localization.getStarted,
                  style: const TextStyle(
                      fontSize: 24
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    controller: _scrollController,
                      shrinkWrap: true,
                      gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,

                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 6.0, // Spacing between rows
                          childAspectRatio: 0.55
                      ),
                      //   physics: BouncingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      physics: const NeverScrollableScrollPhysics(),
                      //  padding: const EdgeInsets.only(bottom: 110, top: 20),
                      scrollDirection: Axis.vertical,
                      itemCount: product.length,
                      itemBuilder: (context, index){
                      final prod = product[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                child: Text("${prod.storeName}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black
                                  ),),
                              ),
                              ElevatedButton(onPressed: ()async{

                              if(_user == '' || _user!.isEmpty || _user == null){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(localization.firstLogIn)));
                              }else{
                                context.read<CartCubit>().addToCart(product: prod,id: prod.id ??'', context: context, );

                              }

                              }, style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.primaryColor
                              ), child: Text(localization.addToCart, style: const TextStyle(color: Colors.black),),),
                            ],
                          ),
                        );
                      }

                  )

              )
            ],
          ),

        ),
      );
    }
    else{
      return const Center(child: Text('something went wrong'),);
    }

  },
)
    ;
  }
}

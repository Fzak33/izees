
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/user/izees/screens/product_detailed_screen.dart';
import 'package:izees/features/user/izees/services/show_product_cubit/show_products_cubit.dart';
import 'package:izees/features/user/izees/services/show_product_services.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/widgets/category_widget.dart';
import '../../../../models/product_model.dart';
import '../../cart/services/cart_cubit/cart_cubit.dart';
import '../services/recommended/recommended_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IzeesScreen extends StatefulWidget {
  const IzeesScreen({super.key});

  @override
  State<IzeesScreen> createState() => _IzeesScreenState();
}

class _IzeesScreenState extends State<IzeesScreen> {
  String? _user;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getUser();
    context.read<ShowProductsCubit>().fetchProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.7) {
        print('Fetching more products...');

        context.read<ShowProductsCubit>().fetchProducts();
      }
    });
  }

  // void _onScroll() {
  //   if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.7) {
  //     context.read<ShowProductsCubit>().loadMore();
  //   }
  // }



  void getUser()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    _user =   prefs.getString('x-auth-token')?? '';

  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    // final auth = context.read<AuthCubit>();
    return   SafeArea(
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
                  child: BlocBuilder<ShowProductsCubit, ProductState>(
                  builder: (context, state) {
                    List<Product> products = [];
                    bool isLoading = false;

                    if (state is ProductLoading ) {
                      products = state.existingProducts;
                      isLoading = true;
                    } else if (state is ProductLoaded) {
                      products = state.products;
                    }
                    return  Container(
                      height: 600,
                      width: double.infinity,
                      child: GridView.builder(
                          controller: _scrollController,
                        //  shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,

                              crossAxisSpacing: 10.0, // Spacing between columns
                              mainAxisSpacing: 6.0, // Spacing between rows
                              childAspectRatio: 0.55
                          ),
                             //physics: BouncingScrollPhysics(),
                          clipBehavior: Clip.hardEdge,
                        //  physics: const NeverScrollableScrollPhysics(),
                          //  padding: const EdgeInsets.only(bottom: 110, top: 20),
                          scrollDirection: Axis.vertical,
                          itemCount: products.length ,
                          itemBuilder: (context, index) {
                            // if (index == state.products.length) {
                            //  // return const Center(child: CircularProgressIndicator()); // Loading indicator at bottom
                            // }

                            final prod = products[index];
                            return ProductCard(prod: prod, user: _user, localization: localization);
                          }

                      ),
                    );
                  },
)

              )
            ],
          ),

        ),
      );
    }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  }

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.prod,
    required String? user,
    required this.localization,
  }) : _user = user;

  final Product prod;
  final String? _user;
  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context,
                  ProductDetailedScreen.routeName,
                  arguments: prod);
              context.read<RecommendedCubit>()
                  .recommended(category: prod.category);
            },
            child: Container(

              //color: Colors.green,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.45,
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(
                      "${StringsRes.uri}/${prod.images[0].path}"),
                  fit: BoxFit.fitHeight,
                ),
              ),

            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 2, horizontal: 10),
            child: Text(prod.name,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black
              ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 2, horizontal: 10),
            child: Text("${prod.price}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black
              ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 2, horizontal: 10),
            child: Text("${prod.storeName}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black
              ),),
          ),
          ElevatedButton(onPressed: () async {
            if (_user != '') {
              context.read<CartCubit>().addToCart(
                product: prod,
                id: prod.id ?? '',
                context: context,);

            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                  SnackBar(content: Text(
                      localization.firstLogIn)));
            }
          },
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager
                    .primaryColor
            ),
            child: Text(localization.addToCart,
              style: const TextStyle(
                  color: Colors.black),),),
        ],
      ),
    );
  }
}


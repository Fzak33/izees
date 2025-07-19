
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/user/izees/screens/product_detailed_screen.dart';
import 'package:izees/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/strings_res.dart';
import '../../cart/services/cart_cubit/cart_cubit.dart';
import '../../store_products/screens/store_products_screen.dart';
import '../services/recommended/recommended_cubit.dart';
import '../services/show_category_products_cubit/show_category_products_cubit.dart';
import '../services/show_product_services.dart';


class CategoryProductScreen extends StatefulWidget {
  static const String routeName ='/show-category-products';
  String category;
  CategoryProductScreen({super.key, required this.category});

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {

  String? _user;


  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getUser();
    context.read<ShowCategoryProductsCubit>().fetchCategoryProducts( widget.category);

  _scrollController.addListener((){
  if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.7) {
      context.read<ShowCategoryProductsCubit>().loadmore( widget.category);
    }}
  );
  }



  void getUser()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    _user =   prefs.getString('x-auth-token')?? '';

  }


  @override
  Widget build(BuildContext context) {

    final localization = AppLocalizations.of(context)!;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
      ),
      body: BlocBuilder<ShowCategoryProductsCubit,ShowCategoryProductsState>(
        builder: (context, state) {
List<Product> products=[];
bool isLoading = false;

if(state is ShowCategoryProductLoading ){
products = state.products;
    }
    // else if(state is ShowCategoryProductsFailed){
    // return  Center(child:Text(state.err),);
    // }
    else if(state is ShowCategoryProductLoaded) {
   products = state.products;
    }
return  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: double.infinity,
      width: double.infinity,
      child: GridView.builder(
          controller: _scrollController,
          //shrinkWrap: true,
          gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,

              crossAxisSpacing: 10.0, // Spacing between columns
              mainAxisSpacing: 6.0, // Spacing between rows
              childAspectRatio: 0.55
          ),
          //   physics: BouncingScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          //  physics: NeverScrollableScrollPhysics(),
          //  padding: const EdgeInsets.only(bottom: 110, top: 20),
          scrollDirection: Axis.vertical,
          itemCount: state.products.length ,
          itemBuilder: (context, index){
            // if (index == state.products.length) {
            //   return const Center(child: CircularProgressIndicator()); // Loading indicator at bottom
            // }

            final prod = products[index];
            return CategoryProductCard(prod: prod, user: _user, localization: localization);
          }

      ),
    )

);

        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class CategoryProductCard extends StatelessWidget {
  const CategoryProductCard({
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
                image:  DecorationImage(image: NetworkImage("${StringsRes.uri}/${prod.images[0]}") ,
                  fit: BoxFit.fitHeight,
                )  ,
              ),

            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: Text("${prod.price} ${localization.jod} ",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black
              ),),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, StoreProductScreen.routeName , arguments: {
                'storeName':prod.storeName,
                'storeImage':prod.storeImage
              });

            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: SizedBox(
                    height: 33,
                    width: 33,
                    child: CircleAvatar(
                      backgroundColor: ColorManager.bottomButtonColor,
                      backgroundImage:prod.storeImage != null
                          ? NetworkImage("${StringsRes.uri}/${prod.storeImage}") // Load network image if storeImage is not null
                          : AssetImage('assets/images/perfume-icon.jpg') as ImageProvider
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2, horizontal: 10),
                  child: Text("${prod.storeName}",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

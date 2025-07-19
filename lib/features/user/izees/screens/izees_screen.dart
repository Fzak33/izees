
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/user/izees/screens/product_detailed_screen.dart';
import 'package:izees/features/user/izees/services/show_product_cubit/show_products_cubit.dart';
import 'package:izees/features/user/store_products/screens/store_products_screen.dart';
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




  void getUser()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _user =   prefs.getString('x-auth-token')?? '';

  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<ShowProductsCubit, ProductState>(
      builder: (context, state) {
        List<Product> products = [];
        bool isLoading = false;

        if (state is ProductLoading ) {
          products = state.existingProducts;
          isLoading = true;
        } else if (state is ProductLoaded) {
          products = state.products;
        }
return CustomScrollView(
    controller: _scrollController,

    slivers: [
      SliverList(
          delegate:
          SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(

                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor, // Deep purple color
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    CategoryWidget(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Items',
                        style: FontStyles.allItems
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_alt_outlined, color: ColorManager.primaryColor), onPressed: () {  },

                      ),
                    ],
                  ),
                ),

              ]
          )
      ),
      SliverGrid(

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 2,
          mainAxisSpacing: 6.0, // Spacing between rows
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
        ), delegate: SliverChildBuilderDelegate(
  childCount: products.length,
            (context, index) {

  final prod = products[index];
          return ProductCard(prod: prod, user: _user, localization: localization);
        },
      ),
      )
    ],
  );

      },


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
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center( // center image inside the box
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // less than outer radius
                  child: Image.network(
                    "${StringsRes.uri}/${prod.images[0]}",
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width * 0.4,
                    fit: BoxFit.contain, // <- don't use cover
                  ),
                ),
              ),
            ),

          ),


          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 2, horizontal: 10),
            child: Text(prod.name,
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: FontStyles.stuffName,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10),
            child: Text("${prod.price} ${localization.jod}",
              style: FontStyles.homeName,),
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
                    height: 25,
                    width: 25,
                    child: CircleAvatar(
                      backgroundColor: ColorManager.bottomButtonColor,
                      backgroundImage:
                      prod.storeImage != null
                          ? NetworkImage("${StringsRes.uri}/${prod.storeImage}") // Load network image if storeImage is not null
                          : AssetImage('assets/images/perfume-icon.jpg') as ImageProvider
                    ),
                  ),
                ),
                Text("${prod.storeName}",
                  style:FontStyles.storeName,),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


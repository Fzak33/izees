import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:izees/features/user/store_products/services/store_products_cubit/store_products_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/product_model.dart';
import '../../../../resources/strings_res.dart';
import '../../../auth/auth_cubit/auth_cubit.dart';
import '../../izees/screens/product_detailed_screen.dart';
import '../../izees/services/recommended/recommended_cubit.dart';

class StoreProductScreen extends StatefulWidget {
   StoreProductScreen({super.key, required this.storeName, this.storeImage});

  static const String routeName = '/store-product-screen';
  String storeName;
  String? storeImage;

  @override
  State<StoreProductScreen> createState() => _StoreProductScreenState();
}

class _StoreProductScreenState extends State<StoreProductScreen> {

   final ScrollController _scrollController = ScrollController();
   @override
   void initState() {
     super.initState();
     context.read<StoreProductsCubit>().fetchCategoryProducts( widget.storeName);

     _scrollController.addListener((){
       if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.7) {
         context.read<StoreProductsCubit>().loadmore( widget.storeName);
       }}
     );
   }
   @override
  Widget build(BuildContext context) {
     final localization = AppLocalizations.of(context)!;

     return Scaffold(
      appBar: AppBar(

        title:   Text(widget.storeName,
          style: FontStyles.appBarName,
        ),
        backgroundColor: ColorManager.primaryColor,
      ),

      body:


             BlocBuilder<StoreProductsCubit, StoreProductsState>(
  builder: (context, state) {
    List<Product> products=[];
    bool isLoading = false;
    if(state is ShowStoreProductLoading ){
      products = state.products;
    }
    else if(state is ShowStoreProductLoaded) {
      products = state.products;
    }
return CustomScrollView(
  controller: _scrollController,
  slivers: [
    SliverList(
       delegate:
SliverChildListDelegate(
    [Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
      child: SizedBox(
        height: 75,
        width: 75,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: widget.storeImage != null
              ? NetworkImage("${StringsRes.uri}/${widget.storeImage}") // Load network image if storeImage is not null
              : AssetImage('assets/images/perfume-icon.jpg') as ImageProvider,
        ),
      ),
    ),


  ],
),]),


     ),
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
         mainAxisSpacing: 6.0, // Spacing between rows
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
           final   prod = products[index];
          return
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              InkWell(
              onTap:(){
              Navigator.pushNamed(context, ProductDetailedScreen.routeName, arguments: prod);
              context.read<RecommendedCubit>().recommended(category: prod.category);
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
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
              ),


              Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Text(products[index].name ?? 'name',
              textAlign: TextAlign.start,
              maxLines:2,
              overflow:TextOverflow.ellipsis,
              style: FontStyles.stuffName,),
              ),

              Padding(
              padding: const EdgeInsets.symmetric(vertical: 2,  horizontal: 10),
              child: Text('${products[index].price} ${localization.jod}',

              style: FontStyles.homeName,),
              ),
              ],
              ),
            )
            ;
        },
        childCount: products.length,
      ),
    ),
  ],
);
  },
)



        ,
      );


  }
   @override
   void dispose() {
     _scrollController.dispose();
     super.dispose();
   }
}









// return Column(
// children: [
// SingleChildScrollView(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
// child: SizedBox(
// height: 75,
// width: 75,
// child: CircleAvatar(
// backgroundColor: Colors.transparent,
// backgroundImage: AssetImage('assets/images/perfume-icon.jpg'),
// ),
// ),
// ),
//
//
// ],
// ),
//
// ),
// Expanded(child:
// GridView.builder(
// controller: _scrollController,
// gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
//
// crossAxisSpacing: 10.0, // Spacing between columns
// mainAxisSpacing: 6.0, // Spacing between rows
// childAspectRatio: 0.63
// ),
// clipBehavior: Clip.hardEdge,
// // padding: const EdgeInsets.only(bottom: 110, top: 20),
// scrollDirection: Axis.vertical,
// itemCount: products.length,
// itemBuilder: (context, index){
// final prod = products[index];
// return Padding(
// padding: const EdgeInsets.symmetric(horizontal: 8.0),
// child: Column(
//
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
//
// InkWell(
// onTap:(){
// Navigator.pushNamed(context, ProductDetailedScreen.routeName, arguments: prod);
// context.read<RecommendedCubit>().recommended(category: prod.category);
// },
// child: Container(
// //color: Colors.green,
// height: MediaQuery.of(context).size.height * 0.25,
// width: MediaQuery.of(context).size.width * 0.45,
// decoration:    BoxDecoration(
// // shape: BoxShape.circle,
// border: Border.all(color: Colors.blueGrey),
// borderRadius: BorderRadius.circular(15),
// image:  DecorationImage(image:NetworkImage('${StringsRes.uri}/${prod.images[0].path}'),
// fit: BoxFit.fitHeight,
// )  ,
// ),
//
// ),
// ),
//
//
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
// child: Text(products[index].name ?? 'name',
// textAlign: TextAlign.start,
// maxLines:1,
// overflow:TextOverflow.ellipsis,
// style: const TextStyle(
// fontSize: 18,
// color: Colors.black
// ),),
// ),
//
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 2,  horizontal: 10),
// child: Text('${products[index].price} ${localization.jod}',
//
// style: const TextStyle(
// fontSize: 14,
// color: Colors.black
// ),),
// ),
// ],
// ),
// );
// }
//
// ),
// )
// ],
// );
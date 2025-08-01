import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/custom_button.dart';
import 'package:izees/features/user/izees/services/recommended/recommended_cubit.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cart/services/cart_cubit/cart_cubit.dart';
import '../../cart/widgets/product_bottom_sheet.dart';
import '../widgets/carousel_product_image.dart';

class ProductDetailedScreen extends StatefulWidget {
  static const routeName = '/product-detailed';
  final Product product;
  const ProductDetailedScreen({super.key, required this.product});

  @override
  State<ProductDetailedScreen> createState() => _ProductDetailedScreenState();
}

class _ProductDetailedScreenState extends State<ProductDetailedScreen> {
  late List<String> displayedImages;
  int? selectedColorIndex = 0 ;
  String? _user;


  @override
  void initState() {
    super.initState();
    getUser();
    displayedImages = widget.product.images;
  }

  void getUser()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    _user =   prefs.getString('x-auth-token')?? '';

  }

  void _onColorSelected(int index ) {
    final selectedColorImage = widget.product.colors[index].image;
    setState(() {
      selectedColorIndex = index;
      displayedImages =   selectedColorImage.isNotEmpty && selectedColorImage != null
          ? [selectedColorImage]
          : widget.product.images;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.product.colors;
    final localization = AppLocalizations.of(context)!;

    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorManager.secondaryColor,
        ),
        backgroundColor:ColorManager.primaryColor,
        title: Text('${widget.product.name}' , style: FontStyles.appBarText,),
      ),
      body: SingleChildScrollView(
        child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ProductCarousel(imageUrls: displayedImages,),
            const SizedBox(height: 12),

            if (colors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: List.generate(colors.length, (index) {
                    final color = colors[index];
                    final colorValue = color.colorValue;
                    final isSelected = selectedColorIndex == index;

                    return GestureDetector(
                      onTap: () => _onColorSelected(index),
                      child:
                      colorValue != null ?
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(colorValue),
                        )
                              , // empty circle space
                      ) : Container(),
                    );
                  }),
                ),
              ),

          //  const SizedBox(height: 10),
              Builder(
                   builder: (context) => Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: ElevatedButton(
                          onPressed: () => showProductBottomSheet(context, widget.product, selectedColorIndex),
                                       child:  Text("${localization.addToCart}", style: FontStyles.addToCart
                                       ),
                       style: ElevatedButton.styleFrom(

                         minimumSize: const Size(double.infinity, 50),
                         backgroundColor: ColorManager.primaryColor,

                       ),
                                       ),
                   ),
                  ),
              const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text( style: FontStyles.priceText, "${widget.product.price} ${localization.jod}",
              textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text( style: FontStyles.stuffName, '${widget.product.name}  '),
            ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text( style: FontStyles.homeName, '${widget.product.description}'),
              ),
            const SizedBox(height: 30,),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(localization.recommendedForYou ,style:FontStyles.nameText ,),
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

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners for the card
                ),
                elevation: 4, // Adds shadow for a better visual effect
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50), // Make the image circular or adjust for rounded rectangle
                        child: Image.network(
                          "${StringsRes.uri}/${prod.images[0]}",
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${prod.name}',
                        style: FontStyles.homeName,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
              ,
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
  void showProductBottomSheet(BuildContext context, Product product, int? colorIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ProductBottomSheet(product: product, user:_user!, colorIndex:colorIndex ),
    );
  }

}







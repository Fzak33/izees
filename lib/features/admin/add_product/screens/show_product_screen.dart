import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izees/common/widgets/custom_button.dart';
import 'package:izees/features/admin/add_product/screens/add_product_screen.dart';
import 'package:izees/features/admin/add_product/screens/start_sell_screen.dart';
import 'package:izees/features/admin/add_product/screens/update_product_screen.dart';
import 'package:izees/features/user/settings/screens/settings_screen.dart';
import 'package:izees/models/product_model.dart';

import '../../../../common/widgets/add_phone_number_screen.dart';
import '../../../../resources/strings_res.dart';
import '../../../auth/auth_cubit/auth_cubit.dart';
import '../../admin_orders/screens/admin_order_screen.dart';
import '../../detailed_charts/screens/tab_bar_detailed_charts.dart';
import '../services/AdminProductServiceCubit/admin_product_service_cubit.dart';

class ShowProductScreen extends StatefulWidget {
  const ShowProductScreen({super.key});

  @override
  State<ShowProductScreen> createState() => _ShowProductScreenState();
}

class _ShowProductScreenState extends State<ShowProductScreen> {
 // final ScrollController _scrollController = ScrollController();
  File? _image;
  final _picker = ImagePicker();

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<AdminProductServiceCubit>().fetchProducts( context: context);
  //
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels >=
  //         _scrollController.position.maxScrollExtent * 0.7) {
  //       context.read<AdminProductServiceCubit>().fetchMoreProducts(context: context);
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    var _auth = BlocProvider
        .of<AuthCubit>(context)
    ;
    Future<void> _uploadImage() async {
      if (_image != null) {
        try {
          // Call the Cubit method to upload the image
        final res=  await context.read<AdminProductServiceCubit>().addStoreImage(
            storeImage: _image!,
            context: context,
          );

          // Update the UI after the image is successfully uploaded
          setState(() {
           // Update the store image URL or path after upload
           _auth.adminModel.storeImage = res; // You could also update this to a URL if that's returned from the backend
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick an image first')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [

          IconButton(onPressed: (){
            Navigator.pushNamed(context, AdminOrderScreen.routeName);
          }, icon: Icon(Icons.menu_book_outlined, color: Colors.purple ,)),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, SettingsScreen.routeName);
          }, icon: Icon(Icons.settings, color: Colors.black,)),

        ],
        title:   Text(_auth.adminModel.storeName.toString(),
          style: TextStyle(
              fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.w500
          ),
        ),
        backgroundColor: ColorManager.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if(_auth.adminModel.phoneNumber == '' || _auth.adminModel.phoneNumber == null){
          Navigator.pushNamed(context, AddPhoneNumberScreen.routeName);

        }else{
          Navigator.pushNamed(context, AddProductScreen.routeName);

        }
      },
      child: const Icon(Icons.add),
        backgroundColor: ColorManager.primaryColor,
      ),
      body:  BlocBuilder<AdminProductServiceCubit, AdminProductServiceState>(

  builder: (context, state) {
List<Product> products =[];
     if(state is AdminProductServiceSuccess){
       products = state.product;

    }
   return  CustomScrollView(
     slivers: [
       SliverList(
         delegate:
         SliverChildListDelegate([
           Column(
             // crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [

                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
                     child: SizedBox(
                       height: 75,
                       width: 75,
                       child: CircleAvatar(
                           backgroundColor: Colors.transparent,
                           backgroundImage:
                           _auth.adminModel.storeImage != null
                               ? NetworkImage("${StringsRes.uri}/${_auth.adminModel.storeImage}") // Load network image if storeImage is not null
                               : AssetImage('assets/images/perfume-icon.jpg') as ImageProvider
                       ),
                     ),
                   ),
                   Padding(
                     padding:  EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.175),
                     child: Column(
                       children: [

                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                           child: Text('products',
                             style: const TextStyle(
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black
                             ),),
                         ),
                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                           child: Text(products.length.toString(),
                             style: const TextStyle(
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black
                             ),),
                         ),
                       ],),
                   )
                 ],

               ),
               SizedBox(height: 10,),
               Row(
                 mainAxisAlignment: _auth.adminModel.isSell!
                     ? MainAxisAlignment.start
                     : MainAxisAlignment.spaceAround,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 8.0),
                     child: ElevatedButton(
                       onPressed: () async{
                         await _pickImage(); // Pick image from gallery
                         if (_image != null) {// Ensure an image was picked before uploading

                           await _uploadImage();
                           // Upload the image if it's picked
                         } else {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Please pick an image first')),
                           );
                         }
                       },
                       child: const Text(
                         'Edit avatar',
                         style: TextStyle(color: Colors.white),
                       ),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.blueGrey,
                         minimumSize: const Size(150, 45),
                       ),
                     ),
                   ),
                   if (!_auth.adminModel.isSell! )
                     ElevatedButton(
                       onPressed: () async {
                         final res = await Navigator.pushNamed(context, StartSellScreen.routeName);
                         if (res == true) {
                           setState(() {
                             _auth.adminModel.isSell = true;
                           });
                         }
                       },
                       child: const Text('Start Sell'),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: ColorManager.primaryColor,
                         minimumSize: const Size(150, 45),
                       ),
                     ),
                 ],
               )

             ],
           )
         ])
       ),
             SliverGrid(
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 6.0, // Spacing between rows
    childAspectRatio: 0.55,
  //  crossAxisSpacing: 10,
    ),
    delegate: SliverChildBuilderDelegate(
      childCount: products.length,
    (context, index) {
      final   prod = products[index];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(left:150,top: 4,bottom: 4, ),
              child: PopupMenuButton<String>(
                offset: Offset(-30, 20),
                icon: Icon(Icons.more_vert_outlined),
                onSelected: (String value){
                  if(value == 'Edit'){
                    Navigator.pushNamed(context, UpdateProductScreen.routeName, arguments: prod);

                  }else if(value == 'Delete'){
                    _showDeleteDialog(context, prod.id??'');
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'Edit',
                      child: Text('Edit', style: TextStyle(fontSize: 15, color: Colors.black),),

                    ),
                    PopupMenuItem(
                      value: 'Delete',
                      child: Text('Delete', style: TextStyle(fontSize: 15, color: Colors.red),),

                    ),
                  ];
                },

              ),
            ),
            Container(
              //color: Colors.green,
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration:    BoxDecoration(
                // shape: BoxShape.circle,
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(15),
                image:  DecorationImage(image:NetworkImage('${StringsRes.uri}/${prod.images[0].path}'),
                  fit: BoxFit.fitHeight,
                )  ,
              ),

            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Text(products[index].name ?? 'name',
                textAlign: TextAlign.start,
                maxLines:1,
                overflow:TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black
                ),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Text('your quantity ${prod.quantity}',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black
                ),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2,  horizontal: 10),
              child: Text('the price is ${products[index].price}',

                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black
                ),),
            ),
          ],
        ),
      );
    },
    )
             )
     ],
   );



  },
)
      ,
    );


  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


}


void _showDeleteDialog(BuildContext context,String productId) {

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('are you sure you want to delete this product ?'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          ElevatedButton(
          onPressed: (){Navigator.pop(context);},
          style: ElevatedButton.styleFrom(

            minimumSize:  const Size( 50,50),
            backgroundColor: Colors.white,

          ),
          child: const Text('Cancel', style: TextStyle(

              color: Colors.black
          ),),

        )   ,
            ElevatedButton(
              onPressed: (){
context.read<AdminProductServiceCubit>().deleteProduct(productId: productId, context: context);
Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(

                minimumSize:  const Size( 50,50),
                backgroundColor: Colors.red,

              ),
              child: const Text('Delete', style: TextStyle(

                  color: Colors.black
              ),),

            )
          ],
        ),
      );
    },
  );
}



///////////////////////





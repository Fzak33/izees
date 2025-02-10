import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/add_product/screens/add_product_screen.dart';
import 'package:izees/features/admin/add_product/screens/update_product_screen.dart';

import '../../../../resources/strings_res.dart';
import '../services/AdminProductServiceCubit/admin_product_service_cubit.dart';

class ShowProductScreen extends StatelessWidget {
  const ShowProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Your Products',
          style: TextStyle(
              fontSize: 24
          ),
        ),
        backgroundColor: ColorManager.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, AddProductScreen.routeName);
      },
      child: const Icon(Icons.add),
        backgroundColor: ColorManager.primaryColor,
      ),
      body:  BlocConsumer<AdminProductServiceCubit, AdminProductServiceState>(
        listener: (context, state) {
          if(state is AdminProductServiceSuccess){

          }
        },
  builder: (context, state) {
    if(state is AdminProductServiceLoding){
      return const Center(child: CircularProgressIndicator(),);
    }
    else if(state is AdminProductServiceSuccess){
      final product = state.product;
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,

                        crossAxisSpacing: 10.0, // Spacing between columns
                        mainAxisSpacing: 6.0, // Spacing between rows
                        childAspectRatio: 0.55
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    clipBehavior: Clip.hardEdge,
                    // padding: const EdgeInsets.only(bottom: 110, top: 20),
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
                                Navigator.pushNamed(context, UpdateProductScreen.routeName, arguments: prod);
                              },
                              child: Container(
                                //color: Colors.green,
                                height: MediaQuery.of(context).size.height * 0.2,
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
                            ),


                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                              child: Text(product[index].name ?? 'name',
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
                              child: Text('the price is ${product[index].price}',

                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black
                                ),),
                            ),
                            ElevatedButton(onPressed: ()=>
                              _showDeleteDialog(context, prod.id??'')
                            , child: Text('Remove Product', style: TextStyle(color: Colors.black),), style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primaryColor
                            ),)
                          ],
                        ),
                      );
                    }

                ),
              )
            ],
          ),

        ),
      );
    }
    else if(state is AdminProductServiceEmpty){
      return  Center(child: Text(state.empty),);
    }
    else if(state is AdminProductServiceFailed){
     return  Center(child: Text(state.err),);
    }else{
      return  const Center(child: Text('something occurd'),);
    }

  },
)
      ,
    );
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





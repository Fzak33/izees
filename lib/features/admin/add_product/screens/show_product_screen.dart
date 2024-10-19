import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/add_product/screens/add_product_screen.dart';

import '../../../../common/widgets/category_widget.dart';
import '../../../../resources/strings_res.dart';
import '../services/AdminProductServiceCubit/admin_product_service_cubit.dart';

class ShowProductScreen extends StatelessWidget {
  const ShowProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Your Products',
          style: TextStyle(
              fontSize: 24
          ),
        ),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, AddProductScreen.routeName);
      },),
      body:  BlocBuilder<AdminProductServiceCubit, AdminProductServiceState>(
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
                    physics: NeverScrollableScrollPhysics(),
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
                            Container(
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


                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                              child: Text(product[index].name ?? 'name',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                              child: Text('your quantity ${prod.quantity}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black
                                ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2,  horizontal: 10),
                              child: Text('the price is ${product[index].price}',

                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black
                                ),),
                            ),
                            ElevatedButton(onPressed: (){}, child: Text('Remove Product', style: TextStyle(color: Colors.black),), style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green
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





///////////////////////





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/detailed_charts/services/product_profit/product_profit_cubit.dart';
import 'package:izees/resources/strings_res.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllDetailedCharts extends StatelessWidget {
  const AllDetailedCharts({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      child: SingleChildScrollView(
        child: BlocBuilder<ProductProfitCubit, ProductProfitState>(
  builder: (context, state) {
    if(state is ProductProfitLoading){
      return const Center(child: CircularProgressIndicator(),);
    }
    else if(state is ProductProfitFailed){
      return Center(child: Text(state.err),);
    }
    else if(state is ProductProfitSuccess){
      final productProfit = state.productProfit;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            height: MediaQuery.of(context).size.height ,
            child: GridView.builder(
                shrinkWrap: true,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,

                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 6.0, // Spacing between rows
                    childAspectRatio: 0.6
                ),
                //   physics: BouncingScrollPhysics(),
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.only(bottom: 110, top: 20),
                scrollDirection: Axis.vertical,
                itemCount: productProfit.length,
                itemBuilder: (context, index){
                  final prod = productProfit[index];
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
                            image:  DecorationImage(image: NetworkImage('${StringsRes.uri}/${prod.product?.images[0].path}') ,
                              fit: BoxFit.fitHeight,
                            )  ,
                          ),

                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          child: Text('${prod.product?.name}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          child: Text('${localization.totalProfit} ${prod.totalPrice}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2,  horizontal: 10),
                          child: Text('${localization.soldQuantity} ${prod.totalQuantity}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black
                            ),),
                        ),

                      ],
                    ),
                  );
                }

            ),
          )
        ],
      );
    }
    else{
      return const Center(child: Text("something occurd"),);
    }


  },
),

      ),
    );
  }
}
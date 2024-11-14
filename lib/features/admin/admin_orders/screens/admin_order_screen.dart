import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/admin_orders/admin_order_cubit/admin_order_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../resources/strings_res.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocConsumer<AdminOrderCubit, AdminOrderState>(
      listener: (context, state) {
        if(state is AdminOrderSuccess){

        }
      },
      builder: (context, state) {

        if(state is AdminOrderLoading){
          return const Center(child: CircularProgressIndicator(),);
        }else if(state is AdminOrderFailed){
          return Center(child: Text(state.err),);
        }else if(state is AdminOrderSuccess){
            final profit =  state.profit;
          return ListView.builder(
            itemCount: profit.length,
            itemBuilder: (context, index) {
             final prof = profit[index];
              return Card(
                child: ListTile(
                  title: Text("${prof.product?.name} - ${localization.price} ${prof.totalPrice }"),
                  subtitle: Text("${localization.quantity} ${prof.totalQuantity}"),
                   trailing:  Container(
                      height: 100,
                      width:  100,
                      decoration:    BoxDecoration(
                        shape: BoxShape.rectangle,
                        image:  DecorationImage(image: NetworkImage("${StringsRes.uri}/${prof.product?.images[0].path}") ,)  ,
                      ),
                    )
                ),
              );
            },);
        }
        else{
          return const Center(child: Text('something occurd'),);
        }



      },
    );
  }
}

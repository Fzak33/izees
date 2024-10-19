import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/admin_orders/admin_order_cubit/admin_order_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<AdminOrderCubit, AdminOrderState>(
      builder: (context, state) {

        if(state is AdminOrderLoading){
          return Center(child: CircularProgressIndicator(),);
        }else if(state is AdminOrderFailed){
          return Center(child: Text(state.err),);
        }else if(state is AdminOrderSuccess){
            final profit =  state.profit;
          return ListView.builder(
            itemCount: profit.length,
            itemBuilder: (context, index) {
             final prof = profit[index];
              return ListTile(
                title: Text("${prof.category} - ${localization.price} ${prof.price }"),
                subtitle: Text("${localization.orderID} ${prof.orderId}"),
                trailing: Text("${localization.quantity} ${prof.quantity}"),
              );
            },);
        }
        else{
          return Center(child: Text('something occurd'),);
        }



      },
    );
  }
}

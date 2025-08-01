import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/admin/admin_orders/admin_order_cubit/admin_order_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../resources/strings_res.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});
  static const String routeName = '/admin-order';
  
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
        title: Text('Orders'),
      ),
      body: BlocConsumer<AdminOrderCubit, AdminOrderState>(
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
               final colorName = prof.colorName == "Default" || prof.colorName == null ? " " : prof.colorName ;
               String? image = prof.image != null ? prof.image : prof.product?.colors[0].image;

               return Card(
                  child: ListTile(
                    title: Text("${prof.product?.name} - ${localization.price} ${prof.totalPrice }"),
                    subtitle: Text("${localization.quantity} ${prof.totalQuantity} $colorName"),
                     trailing:  Container(
                        height: 100,
                        width:  100,
                        decoration:    BoxDecoration(
                          shape: BoxShape.rectangle,
                          image:  DecorationImage(image: NetworkImage("${StringsRes.uri}/$image") ,)  ,
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
      ),
    );
  }
}

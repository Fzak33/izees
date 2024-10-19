import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/driver/screens/detailed_order/detailed_order_screen.dart';
import 'package:izees/features/driver/services/driver_order_cubit/driver_order_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DriverOrderListScreen extends StatelessWidget {
  static const routeName = '/driver';

  const DriverOrderListScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return
      Scaffold(
        body: BlocBuilder<DriverOrderCubit, DriverOrderState>(
          builder: (context, state) {

            if(state is DriverOrderLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(state is DriverOrderEmpty){
              return  Center(child: Text(state.empty),);
            }
            else if(state is DriverOrderFailed){
              return  Center(child: Text(state.err),);
            }else if(state is DriverOrderSuccess){
              final order = state.order;
              return SafeArea(
                child: ListView.builder(itemCount: order.length,
                  itemBuilder: (context, index) {
               final ord = order[index];
               String status(){
                 if(ord.status == 0){
                   return localization.status0;
                 }
                 else if(ord.status == 1){
                   return localization.status1;
                 }else{
                   return '';
                 }
               }
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context,
                                DetailedOrderScreen.routeName, arguments: ord);
                          },
                          title: Text('${localization.customerName} ${ord.userName}'),
                          subtitle: Text('${localization.orderID} - ${ord.id} ${localization.status} - ${status()}'),
                        ),
                        const Divider(thickness: 0.75, color: Colors.blue,)
                      ],
                    );
                  },),
              );
            }
            else {
              return  const Center(child: Text('something occurd'),);
            }






          },
        ),
      );
  }
}

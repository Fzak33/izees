import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/driver/services/driver_order_cubit/driver_order_cubit.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../../models/order.dart';
import '../../services/driver_order_cubit/change_order_status_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailedOrderScreen extends StatefulWidget {
  Order order;
  static const routeName = '/detailed-order';

  DetailedOrderScreen({super.key, required this.order});

  @override
  State<DetailedOrderScreen> createState() => _DetailedOrderScreenState();
}

class _DetailedOrderScreenState extends State<DetailedOrderScreen> {
  // int currentStep = 0;


  @override
  void initState() {
    super.initState();
    final cubit = context.read<ChangeStatus>();
    cubit.getOrderStatus(id: widget.order.id ?? '',context: context);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.order.products.length,
              itemBuilder: (context, index) {
                final ord = widget.order.products[index];
                return Column(
                  children: [
                    ListTile(

                      title: Text(
                          '${ord.product?.name}- ${localization.store} ${ord.product
                              ?.storeName}'),
                      subtitle: Text('${ord.product?.location}'),
                      trailing: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(image: NetworkImage(
                              "${StringsRes.uri}/${ord.product?.images[0].path}"),),
                        ),
                      ),
                    ),
                    const Divider(thickness: 0.75, color: Colors.blue,)
                  ],
                );
              },),
            BlocBuilder<ChangeStatus, Map<String,int>>(
              builder: (context, state) {
                final status = state[widget.order.id] ?? 0;
                return Stepper(
                  currentStep: status ,
                  controlsBuilder: (context, details) {
                    if (status != 2) {
                      return CustomButton(
                          text: localization.done,
                          onTap: () {
                            setState(() {
                                context.read<ChangeStatus>().incrementStatus(id: widget.order.id ?? '', context: context);
                            });
                          }
                        //() => changeOrderStatus(details.currentStep),
                      );
                    }
                    else {
                      return Container();
                    }
                  },
                  steps: [
                    Step(
                      title:  Text(localization.ordered),
                      content:  Text(
                        localization.orderedDes,
                      ),
                      isActive: status > 0,
                      state: status > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title:  Text(localization.completedDes),
                      content:  Text(
                        localization.completedDes,
                      ),
                      isActive: status > 1,
                      state: status > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title:  Text(localization.received),
                      content:  Text(
                        localization.receivedDes,
                      ),
                      isActive: status >= 2,
                      state: status >= 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),

                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

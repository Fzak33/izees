import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/text_field.dart';

import '../../../../resources/strings_res.dart';
import '../services/seller_cubit/seller_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BecomeASellerScreen extends StatefulWidget {
  static const String routeName = '/open-your-store';
  const BecomeASellerScreen({super.key});

  @override
  State<BecomeASellerScreen> createState() => _BecomeASellerScreenState();
}

class _BecomeASellerScreenState extends State<BecomeASellerScreen> {
  final TextEditingController _storeNameEditingController = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _building = TextEditingController();
  final TextEditingController _neighborhood = TextEditingController();

  String city = "Irbid";


  @override
  void dispose() {
    _storeNameEditingController.dispose();
    _street.dispose();
    _building.dispose();
    _neighborhood.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(controller: _storeNameEditingController, hintText: localization.storeName,),



          CustomTextField(controller: _neighborhood, hintText: localization.neighborhood),
          CustomTextField(controller: _street, hintText: localization.street),
          CustomTextField(controller: _building, hintText: localization.building),
          DropdownButton(
            hint:  Text(localization.choseYourCity),
            items: StringsRes.jordanCities().map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )
            ).toList(),
            value: city,  onChanged: (String? newVal) {
            setState(() {
              city = newVal!;
            });
          },),

          ElevatedButton(onPressed: (){
      if(_neighborhood.text.isNotEmpty && _street.text.isNotEmpty && _building.text.isNotEmpty && _storeNameEditingController.text.isNotEmpty) {
        BlocProvider.of<SellerCubit>(context).becomeASeller(
            context: context, storeName: _storeNameEditingController.text,
            cityStore: city,
            address: "$city-${_neighborhood.text}-${_street.text}-${_building
                .text}"
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localization.errAddress)));
      }

          },

            style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor

            ),
            child: Text(localization.openYourStore),
          ),

        ],
      ),
    );
  }
}

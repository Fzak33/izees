import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/text_field.dart';

import '../../../../resources/strings_res.dart';
import '../services/seller_cubit/seller_cubit.dart';

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
  final TextEditingController _phoneNumber = TextEditingController();
  String? errorMessage;

  String city = "Amman";

  bool isValidJordanianPhoneNumber(String value) {
    final RegExp phoneRegExp = RegExp(r'^07[789]\d{7}$');
    return phoneRegExp.hasMatch(value);
  }

  @override
  void dispose() {
    _storeNameEditingController.dispose();
    _street.dispose();
    _building.dispose();
    _neighborhood.dispose();
    _phoneNumber.dispose();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _phoneNumber,
              keyboardType: TextInputType.phone,
              maxLength: 10,  // Limit the phone number length to 10 digits
              decoration: InputDecoration(
                hintText: localization.phoneNumber,
                // labelText: 'Phone Number',
                errorText: errorMessage,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black38
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black38
                  ),
                ),// Show error message

              ),
              onChanged: (value) {
                if (isValidJordanianPhoneNumber(value)) {
                  setState(() {
                    errorMessage = null; // Clear error when valid
                  });
                } else {
                  setState(() {
                    errorMessage = localization.errPhone;
                  });
                }
              },
            ),
          ),
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
      if(_phoneNumber.text.isNotEmpty && _neighborhood.text.isNotEmpty && _street.text.isNotEmpty && _building.text.isNotEmpty && _storeNameEditingController.text.isNotEmpty) {
        BlocProvider.of<SellerCubit>(context).becomeASeller(
            context: context, storeName: _storeNameEditingController.text,
            cityStore: city,
            address: "$city-${_neighborhood.text}-${_street.text}-${_building
                .text}",
          phoneNumber: _phoneNumber.text
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

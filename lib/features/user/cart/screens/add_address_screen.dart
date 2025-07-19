import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/text_field.dart';

import 'package:izees/resources/strings_res.dart';

import '../../../../common/widgets/add_phone_number_screen.dart';
import '../../../../common/widgets/add_phone_number_screen.dart';
import '../../../auth/auth_cubit/auth_cubit.dart';
import '../services/cart_cubit/cart_cubit.dart';



class AddAddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _street = TextEditingController();
  final TextEditingController _building = TextEditingController();
  final TextEditingController _neighborhood = TextEditingController();

  String city = "Amman";


  @override
  void dispose() {
    _street.dispose();
    _building.dispose();
    _neighborhood.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = BlocProvider
        .of<AuthCubit>(context)
    ;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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

          CustomTextField(controller: _neighborhood, hintText: localization.neighborhood),
          CustomTextField(controller: _street, hintText: localization.street),
          CustomTextField(controller: _building, hintText: localization.building),

          ElevatedButton(onPressed: (){
            if(_neighborhood.text.isNotEmpty && _street.text.isNotEmpty && _building.text.isNotEmpty){
              context.read<CartCubit>().addAddress(city: city,
                  address: "$city-${_neighborhood.text}-${_street.text}-${_building.text}", context: context);
              if(auth.authModel.phoneNumber == '' || auth.authModel.phoneNumber == null){
                Navigator.pushNamed(context, AddPhoneNumberScreen.routeName);

              }else{
                Navigator.pop(context);

              }

            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(localization.errAddress)));
            }

          },

            style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor

            ),
            child:  Text(localization.addAddress),
          ),

        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:izees/common/widgets/text_field.dart';
import 'package:izees/resources/strings_res.dart';

class AddAddressWidget extends StatefulWidget {
  const AddAddressWidget({super.key});

  @override
  State<AddAddressWidget> createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends State<AddAddressWidget> {
  final TextEditingController _street = TextEditingController();
  final TextEditingController _building = TextEditingController();
  final TextEditingController _neighborhood = TextEditingController();

  String city = "Irbid";


  @override
  void dispose() {
    _street.dispose();
    _building.dispose();
    _neighborhood.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return  Column(
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
        CustomTextField(controller: _building, hintText: localization.building)


      ],
    );
  }
}

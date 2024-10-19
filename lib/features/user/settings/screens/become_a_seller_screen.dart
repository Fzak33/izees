import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/common/widgets/text_field.dart';

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
  final TextEditingController _branchEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _storeNameEditingController.dispose();
    _branchEditingController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(controller: _storeNameEditingController, hintText: localization.storeName,),

          CustomTextField(controller: _branchEditingController, hintText: localization.yourLocation,),
          ElevatedButton(onPressed: (){
            BlocProvider.of<SellerCubit>(context).becomeASeller(context: context, storeName: _storeNameEditingController.text,branch: _branchEditingController.text);

          },

            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green

            ),
            child: Text(localization.openYourStore),
          ),

        ],
      ),
    );
  }
}

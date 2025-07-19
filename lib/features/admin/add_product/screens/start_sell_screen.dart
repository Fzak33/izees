import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/resources/strings_res.dart';

import '../services/AdminProductServiceCubit/admin_product_service_cubit.dart';

class StartSellScreen extends StatelessWidget {
  const StartSellScreen({super.key});

  static const String routeName = '/start-sell';

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: TextEditingController(text:localization.izeesPolicy
                      ),
                      // enabled: false,
                      // Makes the TextField read-only
                      readOnly: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'izees policy',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () async{
                await context
                  .read<AdminProductServiceCubit>()
                  .startSell(context: context);
                Navigator.pop(context, true);
                },
              child: const Text(
                'Agree and continue',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                minimumSize: const Size(150, 45),
              ),
            ),
          ),
        ],
      )
    );
  }

}

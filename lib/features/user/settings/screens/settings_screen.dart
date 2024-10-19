import 'package:flutter/material.dart';
import 'package:izees/features/auth/screens/login_screen.dart';
import 'package:izees/features/user/settings/screens/become_a_seller_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
   const SettingsScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.welcome),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(localization.cc),
            leading: const Icon(Icons.person_outline_outlined),
          ),
          const Divider(),
          ListTile(
            title: Text(localization.language),
            leading: const Icon(Icons.language),
          ),
          const Divider(),
          ListTile(
            onTap: (){
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
            title: Text(localization.login),
            leading: const Icon(Icons.logout_sharp),
          ),
          const Divider(),
          ListTile(
            title: Text(localization.aboutUs),
            leading: const Icon(Icons.account_tree_outlined),
          ),
          const Divider(),
          ListTile(
            title: Text(localization.becomeASeller),
            leading: const Icon(Icons.storefront_outlined),
            onTap: (){
                 Navigator.pushNamed(context, BecomeASellerScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}




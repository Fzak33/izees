import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/features/auth/screens/login_screen.dart';
import 'package:izees/features/user/settings/screens/about_izees_screen.dart';
import 'package:izees/features/user/settings/screens/about_me_screen.dart';
import 'package:izees/features/user/settings/screens/become_a_seller_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/language_cubit/locale_cubit.dart';

class SettingsScreen extends StatefulWidget {
    SettingsScreen({super.key});
    static const routeName = '/setting';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
   String? _user;

   String? _role ;

   void _getUser()async {
     final prefs = await SharedPreferences.getInstance();
     setState(() {
       _user = prefs.getString('x-auth-token') ?? '';
       _role = prefs.getString('role') ?? '';
     });
   }

   @override
  void initState() {
    super.initState();
      _getUser();

  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.welcome),
        backgroundColor: ColorManager.primaryColor,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(localization.cc),
            leading: const Icon(Icons.person_outline_outlined),
            onTap: (){
              Navigator.pushNamed(context, AboutMeScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: Text(localization.language),
            leading: const Icon(Icons.language),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              if (_user == '') {
                // Navigate to the LoginScreen
                Navigator.pushNamed(context, LoginScreen.routeName);
              } else {
                // Log out the user and then update the state
                context.read<AuthCubit>().logOut(context: context).then((_) {
                  setState(() {
                    _user = ''; // Reset the _user variable after logout
                  });

                  // Optionally, check the auth token for debugging
                  final auth = BlocProvider.of<AuthCubit>(context);
                  debugPrint('your auth token =========== ${auth.authModel.token}');
                });
              }
            },
            title: _user != '' ? Text(localization.logOut) : Text(localization.login),
            leading: _user == ''
                ? const Icon(Icons.login_outlined)
                : const Icon(Icons.logout_sharp),
          )
          ,
          const Divider(),
          ListTile(
            title: Text(localization.aboutUs),
            leading: const Icon(Icons.account_tree_outlined),
            onTap: (){
              Navigator.pushNamed(context,AboutIzeesScreen.routeName);
            },
          ),
          const Divider(),

          _role == "user"
              ? ListTile(
            title: Text(localization.becomeASeller),
            leading: const Icon(Icons.storefront_outlined),
            onTap: () async {
              // Navigate to the BecomeASellerScreen
              final result = await Navigator.pushNamed(context, BecomeASellerScreen.routeName);

              // If the user successfully becomes a seller, update the role
              if (result == true) {
                setState(() {
                  _role = "admin";
                });
              }
            },
          )
              : Container(),

        ],
      ),
    );
  }
}


void _showLanguageDialog(BuildContext context) {
  final localization = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(localization.languageLabel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.read<LocaleCubit>().changeLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                context.read<LocaleCubit>().changeLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}


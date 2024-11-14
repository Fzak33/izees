import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/auth/auth_cubit/auth_cubit.dart';
import 'package:izees/resources/strings_res.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({super.key});
  static const  routeName = '/about-me';
  @override
  Widget build(BuildContext context) {
    final auth = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(auth.authModel.name??'',   style: const TextStyle(
                overflow: TextOverflow.ellipsis
            ),),
            leading: const Icon(Icons.person_outline_outlined),
          ),
          const Divider(),
          ListTile(
            title: Text(auth.authModel.email??'',   style: const TextStyle(
                overflow: TextOverflow.ellipsis
            ),),
            leading: const Icon(Icons.email_outlined),

          ),
          const Divider(),
          ListTile(
           title: Text(auth.authModel.phoneNumber ??''),
            leading: const Icon(Icons.local_phone_outlined),

          ),
          const Divider(),
          ListTile(
            title: Text(auth.authModel.address ??'',
              style: const TextStyle(
              overflow: TextOverflow.ellipsis
            ),
            ),
            leading: const Icon(Icons.location_on_outlined),

          ),
        ],
      ),
    );
  }
}

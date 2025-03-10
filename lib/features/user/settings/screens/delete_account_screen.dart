import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izees/features/user/settings/services/seller_cubit/seller_cubit.dart';
import 'package:izees/resources/strings_res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class DeleteAccountScreen extends StatefulWidget {
  static const routeName ="/delete-account";
   DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
   TextEditingController _passwordEditingController = TextEditingController();

String _privacyPolicyDeletion =
'''   
              Privacy Policy:

We value your privacy and are committed to protecting the personal information you share with us. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our services.

Information Collection: We collect personal information such as your name, email address, and phone number when you register for our services. We also collect information about your usage of our services to improve your experience.

Use of Information: We use the information you provide to personalize your experience, process transactions, and communicate with you about your account and our services. We do not sell or share your personal data with third parties for marketing purposes.

Data Security: We take appropriate measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.

Your Rights: You have the right to access, update, or delete the personal information you’ve provided. You can also choose to opt-out of receiving marketing communications.

Account Deletion:

If you wish to delete your account, please note that:

Deleting your account will permanently remove your profile, associated data, and any content you’ve uploaded. This action cannot be undone.

Requesting Deletion: To request account deletion, you can contact us directly through our support channels or visit the settings section of your account and follow the steps for account deletion.

Time for Deletion:

Customers: If you are a customer, your account will be deleted immediately after the deletion request is processed.
Stores: If you are a store, your account will be deleted within 3 months for financial and accounting purposes.
Data Retention: Certain data, such as transaction records, may be retained for legal and administrative purposes even after account deletion.
              ''';




@override
  void dispose() {
    super.dispose();
    _passwordEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;


    return Scaffold(

      appBar: AppBar(backgroundColor: ColorManager.primaryColor,),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: TextEditingController(text:_privacyPolicyDeletion
                    ),
                   // enabled: false,
                    // Makes the TextField read-only
                    readOnly: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Privacy policy Deletion',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(localization.passwordDeleteAccount,textAlign: TextAlign.start,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _passwordEditingController,
                  // Makes the TextField read-only
                  decoration: InputDecoration(
                   hintText: "password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
        ElevatedButton(
          onPressed: () {
            if(_passwordEditingController.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localization.enterPassword)));
            }else{
              _showDeleteDialog(context,_passwordEditingController.text.trim());

            }
          },


          child: Text(localization.delete, style: TextStyle(

              color:   Colors.black
          ),),
          style: ElevatedButton.styleFrom(

            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.red,

          ),

        )

            ],
          ),
        ),
      ),
    );
  }
}


void _showDeleteDialog(BuildContext context,String password) {
  final localization = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(localization.deleteAccount),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: (){Navigator.pop(context);},
              style: ElevatedButton.styleFrom(

                minimumSize:  const Size( 50,50),
                backgroundColor: Colors.white,

              ),
              child:  Text(localization.cancel, style: TextStyle(

                  color: Colors.black
              ),),

            )   ,
            ElevatedButton(
              onPressed: (){
                context.read<SellerCubit>().deleteMyAccount( password: password, context: context);
              },
              style: ElevatedButton.styleFrom(

                minimumSize:  const Size( 50,50),
                backgroundColor: Colors.red,

              ),
              child:  Text(localization.delete, style: TextStyle(

                  color: Colors.black
              ),),

            )
          ],
        ),
      );
    },
  );
}

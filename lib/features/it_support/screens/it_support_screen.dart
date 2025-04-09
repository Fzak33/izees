import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/features/it_support/services/it_support_cubit/it_support_cubit.dart';
import 'package:izees/features/user/settings/screens/settings_screen.dart';
import 'package:izees/models/temp_admin.dart';
import 'package:izees/resources/strings_res.dart';

class ItSupportScreen extends StatelessWidget {
  const ItSupportScreen({super.key});
static const String routeName ='/it-support-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, SettingsScreen.routeName);
          }, icon: Icon(Icons.settings))
        ],
      ),
      body: BlocBuilder<ItSupportCubit,ItSupportState>(
        builder: (context, state) {
          List<TempAdmin> tempAdmin =[];
          if(state is ItSupportSuccess){
            tempAdmin = state.tempAdmin;
          }
          return ListView.builder(
            itemCount: tempAdmin.length,
            itemBuilder:
          (context, index) {
              final temp = tempAdmin[index];
            return Card(
              child: ListTile(
                onTap: ()=> _showDeleteDialog(context, temp.userId ?? '')
                ,
                title: Text(temp.storeName ?? '',style: TextStyle(color: Colors.black),),
                subtitle: Text("${temp.phoneNumber ?? ''} \n ${temp.branches}",style: TextStyle(color: Colors.black),),

              ),
            );
          },
          );
        },
      ),
    );
  }
}


void _showDeleteDialog(BuildContext context,String adminId) {

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('are you sure you want to add this to admin ?'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: (){Navigator.pop(context);},
              style: ElevatedButton.styleFrom(

                minimumSize:  const Size( 50,50),
                backgroundColor: Colors.white,

              ),
              child: const Text('Cancel', style: TextStyle(

                  color: Colors.black
              ),),

            )   ,
            ElevatedButton(
              onPressed: (){
                context.read<ItSupportCubit>().changeIntoAdmin(id: adminId, context: context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(

                minimumSize:  const Size( 50,50),
                backgroundColor: ColorManager.primaryColor,

              ),
              child: const Text('ADD', style: TextStyle(

                  color: Colors.black
              ),),

            )
          ],
        ),
      );
    },
  );
}

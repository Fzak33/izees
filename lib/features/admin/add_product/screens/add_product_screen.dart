import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../../common/widgets/text_field.dart';
import '../services/AdminProductServiceCubit/admin_product_service_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();
  final TextEditingController _quantityEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();
  final TextEditingController _categoryEditingController = TextEditingController();
  List<File> _images =[];
  final ImagePicker picker = ImagePicker();
  FormData formData = FormData();

List<String> productCategory = [
  'Women perfume',
  'Men perfume',
  'Uni perfume',
  'Beauty',
  'Health and Care',
  'Hair Care'
];
 String category = 'Women perfume';

@override
  void dispose() {
  _nameEditingController.dispose() ;
   _descriptionEditingController.dispose() ;
  _quantityEditingController.dispose() ;
   _priceEditingController.dispose() ;
   _categoryEditingController.dispose() ;
  super.dispose();
  }


  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await picker.pickMultiImage();  // Allows selecting multiple images

    if (pickedFiles != null && pickedFiles.length <= 10) {
      setState(() {
        _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });



    } else if (pickedFiles != null && pickedFiles.length > 10) {
      print('You can only select up to 10 images.');
      // Optionally show a user alert here
    } else {
      return;
      print('No images selected.');
    }

  }



//late Product product;
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextField(controller: _nameEditingController, hintText: localization.productName,),
            CustomTextField(controller: _descriptionEditingController, hintText: localization.description, maxLines: 3,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                 inputFormatters: <TextInputFormatter>[
                   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                 ],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: _priceEditingController,
                decoration:  InputDecoration(
                  hintText: localization.productPrice,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black38
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black38
                    ),
                  ),
                ),


              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType:  TextInputType.number,
                controller: _quantityEditingController,
                decoration:  InputDecoration(
                  hintText: localization.productQuantity,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black38
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black38
                    ),
                  ),
                ),


              ),
            ),
          ElevatedButton(onPressed: _pickImages, child: const Icon(Icons.camera_alt_outlined)),
          DropdownButton(
            hint:  Text(localization.categoryChosen),
            items: productCategory.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
          )
          ).toList(),
              value: category,  onChanged: (String? newVal) {
      setState(() {
      category = newVal!;
      });
      },),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
                if(
                _nameEditingController.text.isNotEmpty &&
                    _descriptionEditingController.text.isNotEmpty &&
                    _quantityEditingController.text.isNotEmpty &&
                _priceEditingController.text.isNotEmpty &&
                _images.isNotEmpty
                ){
                  Product  product = Product(
                      name: _nameEditingController.text,
                      description: _descriptionEditingController.text,
                      quantity: int.parse(_quantityEditingController.text),
                      images: _images,
                      storeName: '',
                      location:"",
                      category: category,
                      price: double.parse(_priceEditingController.text)
                  );




                  BlocProvider.of<AdminProductServiceCubit>(context).addProduct(product: product,images: _images, context: context);
                  Navigator.pop(context);
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(localization.notCompleteData))
                  );
                }

              },

                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(localization.sellProduct),
              ),
            )


          ]


        ),
      ),
    );



  }
}



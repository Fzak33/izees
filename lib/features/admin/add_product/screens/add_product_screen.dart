import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/colors_names.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../../common/widgets/text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/color_model.dart';
import '../services/AdminProductServiceCubit/admin_product_service_cubit.dart';



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

  bool _addColorMode = false;
  List<ColorVariant> _colorVariants = [];




  List<File> _images =[];
  final ImagePicker picker = ImagePicker();
  FormData formData = FormData();

List<String> productCategory = [
  'Women perfume',
  'Men perfume',
  'Beauty',
  'Health and Care',
  'Bag',
  'Hat',
  'Glasses',
  'Watch'
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

    if (pickedFiles.length <= 10) {
      setState(() {
        _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });



    } else if (pickedFiles.length > 10) {
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

    void _showAddColorDialog() {
      ColorOption selectedColor = ColorOption.colorOptions.first;
      TextEditingController quantityController = TextEditingController();
      File? pickedImage;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Add Color Variant'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<ColorOption>(
                    value: selectedColor,
                    items: ColorOption.colorOptions.map((option) {
                      return DropdownMenuItem<ColorOption>(
                        value: option,
                        child: Row(
                          children: [
                            Container(width: 24, height: 24, color: option.color),
                            const SizedBox(width: 8),
                            Text(option.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedColor = value!),
                  ),

                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(hintText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() => pickedImage = File(image.path));
                      }
                    },
                    child: const Text("Pick Image"),
                  ),
                  if (pickedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.file(pickedImage!, height: 60),
                    )
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (quantityController.text.isNotEmpty) {
                  _colorVariants.add(ColorVariant(
                    color: selectedColor.color,
                    quantity: int.parse(quantityController.text),
                    image: pickedImage,
                    colorName: selectedColor.name
                  ));
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      );
    }


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
            if(!_addColorMode)
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
            CheckboxListTile(
              title: const Text("Add color"),
              value: _addColorMode,
              onChanged: (value) {
                setState(() {
                  _addColorMode = value!;
                  _images.clear();
                  _colorVariants.clear();
                });
              },
            ),
            _addColorMode
                ? ElevatedButton.icon(
              onPressed: () => _showAddColorDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Add Color Variant"),
            )
                : ElevatedButton(
              onPressed: _pickImages,
              child: const Icon(Icons.camera_alt_outlined),
            ),

           // ElevatedButton(onPressed: _pickImages, child: const Icon(Icons.camera_alt_outlined)),
            if (_addColorMode)
              Column(
                children: _colorVariants.map((variant) {
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: variant.color),
                    title: Text('Qty: ${variant.quantity}'),
                    trailing: variant.image != null
                        ? Image.file(variant.image!, width: 40)
                        : const Icon(Icons.image_not_supported),
                  );
                }).toList(),
              ),

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
              child: ElevatedButton(
                onPressed: () {
                  if (_nameEditingController.text.isNotEmpty &&
                      _descriptionEditingController.text.isNotEmpty &&
                      _priceEditingController.text.isNotEmpty &&
                      (_addColorMode
                          ? _colorVariants.isNotEmpty
                          : (_quantityEditingController.text.isNotEmpty && _images.isNotEmpty))
                  ) {
                    List<ColorModel> colorModels = _addColorMode
                        ? _colorVariants.map((variant) => ColorModel(
                      id: '',
                      colorValue: variant.color.value,
                      name: variant.colorName,
                      quantity: variant.quantity,
                      image: '',
                    )).toList()
                        : [];
                    // Create the base product object
                    Product product = Product(
                      name: _nameEditingController.text,
                      description: _descriptionEditingController.text,
                      quantity: _addColorMode ? 0 : int.parse(_quantityEditingController.text),
                      images: [], // This will be handled in backend
                      storeName: '',
                      location: '',
                      category: category,
                      colors: colorModels,
                      price: double.parse(_priceEditingController.text),
                    );

                    // Convert colorVariants into ColorModel


                    // Collect images depending on the mode
                    List<File> imageFiles = _addColorMode
                        ? _colorVariants
                        .map((variant) => variant.image)
                        .whereType<File>() // ✅ filters out nulls and ensures List<File>
                        .toList()
                        : _images;


                    BlocProvider.of<AdminProductServiceCubit>(context).addProduct(
                      product: product,
                      colors: colorModels,
                      images: imageFiles,
                      context: context,
                    );

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localization.notCompleteData)),
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

class ColorVariant {
  Color color;
  String colorName;
  int quantity;
  File? image;

  ColorVariant({required this.color, required this.quantity, this.image, required this.colorName});
}



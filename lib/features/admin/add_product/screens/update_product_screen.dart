
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../../common/widgets/text_field.dart';
import '../../../../models/color_model.dart';
import '../services/AdminProductServiceCubit/admin_product_service_cubit.dart';



class UpdateProductScreen extends StatefulWidget {
  static const String routeName = '/update-product';
   UpdateProductScreen({super.key, required this.product});
Product product;
  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  List<ColorModel> _colorVariants = [];
  bool _hasColors = false;
  final Map<String, TextEditingController> _colorQuantityControllers = {};

  late TextEditingController _nameEditingController ;
  late TextEditingController _descriptionEditingController ;
  late TextEditingController _quantityEditingController ;
  late TextEditingController _priceEditingController ;
late String category;
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

  @override
  void initState() {
    super.initState();
    category = widget.product.category;

    _nameEditingController = TextEditingController(text: widget.product.name);
    _descriptionEditingController = TextEditingController(text: widget.product.description);
    _quantityEditingController = TextEditingController(text: widget.product.quantity.toString());
    _priceEditingController = TextEditingController(text: widget.product.price.toString());

    if (widget.product.colors[0].name !="Default") {
      _hasColors = true;
      _colorVariants = List.from(widget.product.colors);
      for (var color in _colorVariants) {
        _colorQuantityControllers[color.name] =
            TextEditingController(text: color.quantity.toString());
      }
    }
  }


  @override
  void dispose() {
    _nameEditingController.dispose() ;
    _descriptionEditingController.dispose() ;
    _quantityEditingController.dispose() ;
    _priceEditingController.dispose() ;
    super.dispose();
  }



//late Product product;
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
              if(!_hasColors)
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
              ) ,

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
              if (_hasColors) ...[
                const SizedBox(height: 16),
                const Text("Update quantities for each color", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._colorVariants.map((color) {
                  final controller = _colorQuantityControllers[color.name]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            color.colorValue != null
                                ? Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(color.colorValue!),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black26),
                              ),
                            )
                                :Container(), // Placeholder if no color
                            const SizedBox(width: 8),
                            Text(color.name),
                          ],
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

              ] ,


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                onPressed: () {
    if (
    _nameEditingController.text.isNotEmpty &&
    _descriptionEditingController.text.isNotEmpty &&
    _priceEditingController.text.isNotEmpty

    ) {
    List<ColorModel> updatedColors = [];

    if (_hasColors) {
    updatedColors = _colorVariants.map((color) {
    final controller = _colorQuantityControllers[color.name]!;
    return ColorModel(

    name: color.name,
    colorValue: color.colorValue,
    quantity: int.tryParse(controller.text) ?? color.quantity,
      id: color.id, image: color.image,
    );
    }).toList();
    }

    BlocProvider.of<AdminProductServiceCubit>(context).updateProduct(
    productId: widget.product.id ?? '',
    name: _nameEditingController.text,
    description: _descriptionEditingController.text,
    price: double.parse(_priceEditingController.text),
    quantity: double.parse(_quantityEditingController.text).toInt(),
    category: category,
    colors: updatedColors,
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
                  child: Text('update'),
                ),
              )


            ]


        ),
      ),
    );



  }
}



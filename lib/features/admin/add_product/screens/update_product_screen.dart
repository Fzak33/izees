
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/models/product_model.dart';
import 'package:izees/resources/strings_res.dart';

import '../../../../common/widgets/text_field.dart';
import '../services/AdminProductServiceCubit/admin_product_service_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UpdateProductScreen extends StatefulWidget {
  static const String routeName = '/update-product';
   UpdateProductScreen({super.key, required this.product});
Product product;
  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController _nameEditingController ;
  late TextEditingController _descriptionEditingController ;
  late TextEditingController _quantityEditingController ;
  late TextEditingController _priceEditingController ;
late String category;
  List<String> productCategory = [
    'Women perfume',
    'Men perfume',
    'Uni perfume',
    'Beauty',
    'Health and Care',
    'Hair Care',
    'Bag',
    'Watch'
  ];

 @override
  void initState() {
    super.initState();
     category = widget.product.category;

    _nameEditingController = TextEditingController(text: widget.product.name );
      _descriptionEditingController = TextEditingController(text: widget.product.description);
      _quantityEditingController = TextEditingController(text: widget.product.quantity.toInt().toString());
      _priceEditingController = TextEditingController(text: widget.product.price.toString());
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
                      _priceEditingController.text.isNotEmpty
                  ){

                    BlocProvider.of<AdminProductServiceCubit>(context).updateProduct(
                      category: category,
                        productId: widget.product.id ?? '',
                        description: _descriptionEditingController.text,
                        name: _nameEditingController.text,
                        price: double.parse(_priceEditingController.text),
                        quantity: int.parse(_quantityEditingController.text),
                        context: context
                    );
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
                  child: Text('update'),
                ),
              )


            ]


        ),
      ),
    );



  }
}



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izees/resources/strings_res.dart';

import '../../features/user/izees/screens/category_product_screen.dart';
import '../../features/user/izees/services/show_category_products_cubit/show_category_products_cubit.dart';

class CategoryWidget extends StatelessWidget {
   CategoryWidget({super.key});


  final List<Map<String,String>> _categoryList =[
    {
      'image':'assets/images/bag.png',
      'name':'Bag'
    },
    {
      'image':'assets/images/lip.png',
      'name':'Beauty'
    },

    {
      'image':'assets/images/glasses.png',
      'name':'Glasses'
    },
    {
      'image':'assets/images/health-and-care.png',
      'name':'Health and Care'
    },
    {
      'image':'assets/images/watch.png',
      'name':'Watch'
    },
    {
      'image':'assets/images/hat.png',
      'name':'Hat'
    },
    {
      'image':'assets/images/men logo.png',
      'name':'Men perfume'
    },
    {
    'image':'assets/images/women logo.png',
    'name':'Women perfume'
  },

  ];
  @override
  Widget build(BuildContext context) {
    return
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category" , style: FontStyles.categoryLabel,),
          SizedBox(height: 16,),
          Wrap(
            spacing: 5,
            runSpacing: 15,
            children: List.generate(_categoryList.length, (index) {
              return buildCategoryItem(
                _categoryList[index]['name']!,
                _categoryList[index]['image']!,
                context,
              );
            }),
          )
          ,
        ],
      ),
    ) ;
  }
}

Widget buildCategoryItem(String title, String iconPath, BuildContext context) {
  return InkWell(
    onTap: (){
      Navigator.pushNamed(context, CategoryProductScreen.routeName,arguments:title);

    },
    child: SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(iconPath, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: FontStyles.categoryName,
          )
        ],
      ),
    ),
  );
}


// SizedBox(
// height: 100,
// child: ListView.builder(
// scrollDirection: Axis.horizontal,
// itemCount: _categoryList.length,
// itemBuilder: (context,index){
// return InkWell(
// onTap: (){
// Navigator.pushNamed(context, CategoryProductScreen.routeName,arguments: _categoryList[index]['name']!);
// //  context.read<ShowCategoryProductsCubit>().showCategoryProducts(category:_categoryList[index]['name']!);
// },
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
//
// children: [
// SizedBox(
// width: 50,
// height: 50,
// child: CircleAvatar(
// //backgroundColor: Colors.purple,
// backgroundImage: AssetImage(_categoryList[index]['image']!),
// ),
// ),
// SizedBox(height: 10,),
// Text(_categoryList[index]['name']!,
// style: TextStyle(
// fontSize: 12
// ),
// ),
// ],
// ),
// ),
// );
// }
//
// ),
// )
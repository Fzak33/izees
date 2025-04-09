import 'package:flutter/material.dart';

import '../../features/user/izees/screens/category_product_screen.dart';

class CategoryWidget extends StatelessWidget {
   CategoryWidget({super.key});


  final List<Map<String,String>> _categoryList =[
    {
    'image':'assets/images/women logo.jpg',
    'name':'Women perfume'
  },
    {
      'image':'assets/images/men logo.jpg',
      'name':'Men perfume'
    },
    {
      'image':'assets/images/perfume logo.jpg',
      'name':'Uni perfume'
    },
    {
      'image':'assets/images/lip.jpg',
      'name':'Beauty'
    },
    {
      'image':'assets/images/health-and-care.jpg',
      'name':'Health and Care'
    },
    {
      'image':'assets/images/hair-care.jpg',
      'name':'Hair Care'
    },
    {
      'image':'assets/images/bag.png',
      'name':'Bag'
    },
    {
      'image':'assets/images/watch.png',
      'name':'Watch'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categoryList.length,
          itemBuilder: (context,index){
            return InkWell(
              onTap: (){
                Navigator.pushNamed(context, CategoryProductScreen.routeName,arguments: _categoryList[index]['name']!);
              //  context.read<ShowCategoryProductsCubit>().showCategoryProducts(category:_categoryList[index]['name']!);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(

                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        //backgroundColor: Colors.purple,
                        backgroundImage: AssetImage(_categoryList[index]['image']!),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(_categoryList[index]['name']!,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

      ),
    )
    ;
  }
}

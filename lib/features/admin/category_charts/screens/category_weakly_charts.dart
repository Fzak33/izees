import 'package:flutter/material.dart';

class CategoryWeaklyCharts extends StatelessWidget {
  const CategoryWeaklyCharts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Your Weakly Profit from mens perfume is \$50', style: TextStyle(color: Colors.black, fontSize: 14)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Your Weakly Profit from womens perfume is \$50', style: TextStyle(color: Colors.black,fontSize: 14)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Your Weakly Profit from unisex perfume is \$50', style: TextStyle(color: Colors.black,fontSize: 14)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Your Weakly Profit from beauty  is \$50', style: TextStyle(color: Colors.black,fontSize: 14)),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Your Total Profit is \$1550', style: TextStyle(color: Colors.black,fontSize: 22)),
        ),


      ],
    );
  }
}

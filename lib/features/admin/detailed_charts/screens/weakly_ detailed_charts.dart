import 'package:flutter/material.dart';


class WeaklyDetailedCharts extends StatelessWidget {
  const WeaklyDetailedCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            SizedBox(
              height: MediaQuery.of(context).size.height ,
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,

                      crossAxisSpacing: 10.0, // Spacing between columns
                      mainAxisSpacing: 6.0, // Spacing between rows
                      childAspectRatio: 0.6
                  ),
                  //   physics: BouncingScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.only(bottom: 110, top: 20),
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //color: Colors.green,
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration:    BoxDecoration(
                              // shape: BoxShape.circle,
                              border: Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(15),
                              image:  DecorationImage(image: AssetImage('assets/images/perfume.jpg') ,
                                fit: BoxFit.fitHeight,
                              )  ,
                            ),

                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                            child: Text('product Name',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                            child: Text('you profit is : \$50',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2,  horizontal: 10),
                            child: Text('the qty you sold for this weak is 5',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black
                              ),),
                          ),

                        ],
                      ),
                    );
                  }

              ),
            )
          ],
        ),

      ),
    );
  }
}

import 'package:flutter/material.dart';

class RecentAddedProduct extends StatefulWidget {
  const RecentAddedProduct({super.key});

  @override
  State<RecentAddedProduct> createState() => _RecentAddedProductState();
}

class _RecentAddedProductState extends State<RecentAddedProduct> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin:const EdgeInsets.only(
          left: 15.0, right: 15.0),

      child:   ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {

          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            height: 130,
                            padding: const EdgeInsets.all(10),
                            child: Column(

                              children: [

                                Expanded(
                                  flex: 3,
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 15),
                                            child:
                                            Image.asset(
                                                'assets/images/a2.jpg',height:150,width:80),)
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Expanded(
                                                  child: Text('Product',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 19,
                                                          fontFamily: 'comfart',
                                                          fontWeight: FontWeight.bold
                                                      ))),
                                              const Expanded(
                                                child: Row(
                                                  children: [
                                                    Text('₹500'
                                                        ,style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontFamily: 'comfort',
                                                            fontWeight: FontWeight.bold)),
                                                    SizedBox(width: 10,),
                                                    Text('MRP '
                                                        '₹456'
                                                        '${860}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily: 'comfort',
                                                            decoration: TextDecoration.lineThrough
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: 100,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    //  border: Border.all(color: Colors.black),
                                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                                  ),
                                                  //   margin: EdgeInsets.only(right: 20),
                                                  child: Text('⭐⭐⭐⭐',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.5,
                                                          fontFamily: 'comfort',
                                                          fontWeight: FontWeight.bold
                                                      )),
                                                ),
                                              ),
                                              Expanded(
                                                child:  Container(
                                                  width: 220,
                                                  child: MaterialButton(
                                                    color: Colors.lightBlue.shade400,
                                                    onPressed: (){

                                                    }, child: Text('Edit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
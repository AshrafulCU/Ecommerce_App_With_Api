import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // have add manually

import 'api_service/api.dart';
import 'model/product.dart';
import 'product_details.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Step Second
  Future<List<Product>> getProducts() async{
    List<Product> products = [];
    try
    {
      final url = Uri.parse(Api.getProductsUrl); // import the dependency above manually
      var response = await http.get(url);
      if(response.statusCode ==200)
      {
        var responseData = jsonDecode(response.body);
        for (var eachProduct in responseData as List){
          products.add(Product.fromJson(eachProduct));
        }
      }else{
        Fluttertoast.showToast(msg: "Error");
      }

    }catch(errorMsg){
      Fluttertoast.showToast(msg: errorMsg.toString());
    }
    return products ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products",style: TextStyle(
            color: Colors.white
        ),),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [ // import Product if not
          Expanded(
              child: FutureBuilder(future: getProducts(), builder: (context,AsyncSnapshot<List<Product>> dataSnapShot){

                if( dataSnapShot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if(dataSnapShot.data == null){
                  return Center(
                    child: Text("No Products Found!!"),
                  );
                }

                if (dataSnapShot.data!.isNotEmpty){
                  return GridView.builder(
                      itemCount: dataSnapShot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: .85,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5
                      ), itemBuilder: (context,index)

                  {
                    Product eachProduct = dataSnapShot.data![index];
                    return GestureDetector(
                      onTap: (){
                        Get.to(ProductDetails(productInfo: eachProduct)); // get use korla definitely main.dart a gia  return GetMaterialApp( thakta hova

                      },
                      child: Column(
                        children: [
                          GestureDetector(
                            

                            child: Card(
                              elevation: 2,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.elliptical(10.0, 10.0)),

                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Hero(
                                      tag:eachProduct.image!,
                                      child: CachedNetworkImage( // To show image
                                        imageUrl: eachProduct.image!,
                                        placeholder: (context,url)=>CircularProgressIndicator(),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),

                                  Column(

                                    children: [

                                      Text(eachProduct.title!, style: TextStyle(  // ! kono kicho na poua gala app jano crash na kora
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis, // jai ga na hola ... seen korva
                                      ),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),



                                  Text("TK"+ eachProduct.price.toString()),

                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: Size.fromHeight(30),
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          )
                                      ),
                                      onPressed: (){},
                                      child: Text("Add to Cart", style: TextStyle(color: Colors.white),))


                                ],
                              ),




                            ),
                          ),




                        ],
                      ),
                    );
                  });
                } //*****************************

                return SizedBox(); // fallback return to avoid build errors

              })
          ),
        ],
      ),



    );
  }
}

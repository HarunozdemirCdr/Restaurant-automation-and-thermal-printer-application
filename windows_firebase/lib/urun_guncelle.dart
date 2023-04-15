
import 'package:fluent_ui/fluent_ui.dart';
import 'package:firedart/firedart.dart';
import 'package:windows_firebase/main.dart';

class urun_guncelle_sayfasi extends StatefulWidget {
  const urun_guncelle_sayfasi({Key? key}) : super(key: key);

  @override
  State<urun_guncelle_sayfasi> createState() => urun_guncelle_sayfasiState();
}

class urun_guncelle_sayfasiState extends State<urun_guncelle_sayfasi> {
  final product_collection = Firestore.instance.collection('product');
  late TextEditingController new_fiyat_controller;

  void initState() {

    new_fiyat_controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    new_fiyat_controller.dispose();
    super.dispose();
  }
  Future<void> _updateCustomer(String documentId , String new_price) async {
    try {
      await product_collection.document(documentId).update({"price" : new_price});
    } catch (e) {
      print('Error updating customer: $e');
    }
  }



  @override
  Widget build(BuildContext context) {

    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;


    return Container(color: Colors.yellow,
      child: Column(
        children: [
          SizedBox(height: height/80,),
          Container(height: height/10,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
              margin: EdgeInsets.all(height/30),
              child: Center(child: Text("UPDATE PRODUCTS SECTION",style: TextStyle(color: Colors.black,fontSize: height/45)),)),
          SizedBox(height: height/80,),
          Container(margin: EdgeInsets.all(10),height: height*0.7,width: width,color: Colors.transparent,
            child:     FutureBuilder<List<Document>>(


                future: product_collection.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Document>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text("Loading..."));
                  }

                  final products = snapshot.data!;
                  if (products.isEmpty) {
                    return const Center(child: Text("No product in list"));
                  }

                  return Expanded(child: ListView.builder(
                    primary: false,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final TextEditingController controller = TextEditingController();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            height: height / 8,
                            width: width,
                            child: Row(
                              children: [
                           Flexible(child:      Button(
                             style: ButtonStyle(
                                 backgroundColor: ButtonState.all(Colors.red)),
                             child: Text("UPDATE",
                                 style: TextStyle(color: Colors.white)),
                             onPressed: () {
                               if (!controller.text.isEmpty) {
                                 _updateCustomer(products[index].id,
                                     controller.text.toString());
                               }

                               Navigator.push(
                                   context,
                                   PageRouteBuilder(
                                     pageBuilder:
                                         (context, animation, secondaryAnimation) =>
                                         FirestoreApp(),
                                   ));
                             },
                           ),),
                                SizedBox(
                                  width: width / 100,
                                ),
                              Flexible(child:   Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Product Name : " +
                                      products[index]["name"].toString(),style: TextStyle(fontSize: height/50),),
                                  SizedBox(height: height/100),
                                  Text("Product Price :" +
                                      products[index]["price"].toString(),style: TextStyle(fontSize: height/50),),
                                  SizedBox(height: height/100),
                                  Text("Produc Category :" + products[index]["category"].toString(),style: TextStyle(fontSize: height/50),),

                                ],
                              ),),
                                Expanded(flex: 1,

                                  child: TextBox(

                                    decoration:
                                    BoxDecoration(color: Colors.white,boxShadow: List.filled(10,BoxShadow(color: Colors.blue),growable: false)),
                                    controller: controller,
                                    placeholder: 'ENTER NEW PRICE : ',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 100,
                          ),
                        ],
                      );
                    },
                  ));}),),














          Row(mainAxisAlignment: MainAxisAlignment.center ,children: [

            GestureDetector(onTap: (){Navigator.push(
                context,
                PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => FirestoreApp(),)
            );},child:
            Container(
                height: height/15,
                width: width/6,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.red),


                child: Center(child: Text("CANCEL",style: TextStyle(color: Colors.white),),
                )
            ),),]),
        ],
      ),);
  }
}

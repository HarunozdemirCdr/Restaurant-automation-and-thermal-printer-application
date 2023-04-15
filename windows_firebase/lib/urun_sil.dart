
import 'package:fluent_ui/fluent_ui.dart';
import 'package:firedart/firedart.dart';
import 'package:windows_firebase/main.dart';

class urun_sil_sayfasi extends StatefulWidget {
  const urun_sil_sayfasi({Key? key}) : super(key: key);

  @override
  State<urun_sil_sayfasi> createState() => _urun_sil_sayfasiState();
}

class _urun_sil_sayfasiState extends State<urun_sil_sayfasi> {

  Future<void> _deleteCustomer(String documentId) async {
    try {
      await product_collection.document(documentId).delete();
    } catch (e) {
      print('Error deleting customer: $e');
    }
  }

  final product_collection = Firestore.instance.collection('product');

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


    return Container(color: Colors.blue,
      child: Column(
        children: [
          SizedBox(height: height/80,),
          Container(height: height/10,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
              margin: EdgeInsets.all(height/30),
              child: Center(child: Text("PRODUCT DELETE SECTION",style: TextStyle(color: Colors.black,fontSize: height/45)),)),
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

                  return ListView.builder(
                      primary: false,
                      itemCount: products.length,
                      itemBuilder: (context, index) {

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Container(

                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              height: height/8,
                              width:width,
                              child: Row(
                                children: [
                                  Button(
                                    style: ButtonStyle(backgroundColor: ButtonState.all(Colors.red)),
                                    child: Text("DELETE", style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      _deleteCustomer(products[index].id);
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => FirestoreApp(),)
                                      );
                                    },
                                  ),

                                  SizedBox(width: width/100,),
                                  Column(

                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Product Name : " + products[index]["name"].toString()),
                                      const SizedBox(height: 10),
                                      Text("Product Price :"+products[index]["price"].toString()),
                                      const SizedBox(height: 10),
                                      Text("Product Category :"+products[index]["category"].toString()),
                                    ],
                                  ),],
                              )),
                            SizedBox(height: height/100 ,)],);

                      });}),),














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


import 'package:fluent_ui/fluent_ui.dart';
import 'package:firedart/firedart.dart';
import 'package:windows_firebase/main.dart';

class msil_sayfasi extends StatefulWidget {
  const msil_sayfasi({Key? key}) : super(key: key);

  @override
  State<msil_sayfasi> createState() => _msil_sayfasiState();
}

class _msil_sayfasiState extends State<msil_sayfasi> {

  Future<void> _deleteCustomer(String documentId) async {
    try {
      await customer_collection.document(documentId).delete();
    } catch (e) {
      print('Error deleting customer: $e');
    }
  }

  final customer_collection = Firestore.instance.collection('customer');

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

          SizedBox(height: height/40,),
          Container(margin: EdgeInsets.all(10),height: height*0.8,width: width,color: Colors.transparent,
            child:     FutureBuilder<List<Document>>(


                future: customer_collection.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Document>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text("Loading..."));
                  }

                  final customers = snapshot.data!;
                  if (customers.isEmpty) {
                    return const Center(child: Text("No customer in list"));
                  }

                  return ListView.builder(
                      primary: false,
                      itemCount: customers.length,
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
                                      _deleteCustomer(customers[index].id);
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
                                      Text("CUSTOMER NAME : " + customers[index]["name"]),
                                      const SizedBox(height: 10),
                                      Text("CUSTOMER ADRESS :"+customers[index]["adress"]),
                                      const SizedBox(height: 10),
                                      Text("CUSTOMER PHONE : "+customers[index]["phone"]),
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


                child: Center(child: Text("İPTAL",style: TextStyle(color: Colors.white),),
                )
            ),),]),
        ],
      ),);
  }
}

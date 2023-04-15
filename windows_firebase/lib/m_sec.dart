
import 'package:fluent_ui/fluent_ui.dart';
import 'package:firedart/firedart.dart';
import 'package:windows_firebase/main.dart';

class msec_sayfasi extends StatefulWidget {
  const msec_sayfasi({Key? key}) : super(key: key);

  @override
  State<msec_sayfasi> createState() => _msec_sayfasiState();
}

class _msec_sayfasiState extends State<msec_sayfasi> {

  late Map<String, String> secilen_musteri = {
  };

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


    return Container(color: Colors.blue,
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
                                  Button(style: ButtonStyle(backgroundColor: ButtonState.all(Colors.red)),
                                    child:Text("CHOOSE",style: TextStyle(color: Colors.white),) , onPressed: () {

                                    secilen_musteri.addAll({
                                      "name" : customers[index]["name"],
                                      "phone" : customers[index]["phone"],
                                      "adress" : customers[index]["adress"],
                                    });

                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => FireStoreHome(secilen_musteri),)
                                    );
                                    }, ),

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


                child: Center(child: Text("CANCEL",style: TextStyle(color: Colors.white),),
                )
            ),),]),
        ],
      ),);
  }
}

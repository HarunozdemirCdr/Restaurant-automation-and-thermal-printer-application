
import 'package:fluent_ui/fluent_ui.dart';
import 'package:firedart/firedart.dart';
import 'package:windows_firebase/m_ekle.dart';
import 'package:windows_firebase/m_sec.dart';
import 'package:windows_firebase/m_sil.dart';
import 'package:windows_firebase/urun_ekle.dart';
import 'package:windows_firebase/urun_guncelle.dart';
import 'package:windows_firebase/urun_sil.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';

const project_id = 'project_id';
const api_key = 'api_key';

void main() {
  Firestore.initialize(project_id);
  runApp(FirestoreApp());
}

class FirestoreApp extends StatelessWidget {

  


  Map<String, String> secilen_musteri = {};

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: "Windows Firebase",
      debugShowCheckedModeBanner: false,
      home:  FireStoreHome(secilen_musteri),
    );
  }


}

class FireStoreHome extends StatefulWidget {

   Map<String, String> secilen_musteri;




  FireStoreHome(this.secilen_musteri);

  @override
  State<FireStoreHome> createState() => _FireStoreHomeState(false,secilen_musteri);
}

class _FireStoreHomeState extends State<FireStoreHome> {

  Map<String, String> secilen_musteri;
  Color sari = Colors.yellow;
  Color mavi = Colors.blue;

  _FireStoreHomeState(this._isPrinting,this.secilen_musteri);

  bool _isPrinting = false;

  int toplam_fiyat_fonksiyonu() {
    int toplam_fiyat = 0;
    for (var product in products) {
      toplam_fiyat += int.parse(product['price'].toString());
    }
    return toplam_fiyat;
  }



 late List<Map<String, dynamic>> products = [
 ];




  List<String> listem = [
    "ADD CUSTOMER",
    "SELECT CUSTOMER",
    "DELETE CUSTOMER",
    "ADD PRODUCT",
    "UPDATE PRODUCT",
    "DELETE PRODUCT",

  ];

  List<String> odeme_listem = [
    "CREDIT CARD",
    "CASH",
    "MULTINET",
    "SODEXO",
    "SETCARD",
    "TICKET",
  ];




  String fonksiyon_adi = "";
  ScrollController _scrollController = ScrollController();
  final category_collection = Firestore.instance.collection('categories');
  final product_collection = Firestore.instance.collection('product');
   late String odeme_seklim = "Unknown";
  Future<List<Document>> getcategories() async {
    List<Document> categorySnaphot =
        await category_collection.orderBy("name").get();
    return categorySnaphot;
  }

  Future<List<Document>> getProduct() async {
    List<Document> categorySnaphot =
        await product_collection.orderBy("name").get();
    return categorySnaphot;
  }

  String category_name = "Yiyecekler";
  final textController = TextEditingController();
  final _notController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.black,
      child: Row(
        children: [
          Container(
            color: sari,
            width: width * 0.15,
            child: Column(
              children: [Container(height: height*0.42,
              child: Column(
                children: [Expanded(child: GridView.builder(
                  primary: false,
                  padding: EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: listem.length,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 12,
                    mainAxisExtent: height/19,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: mavi),
                        child: ListTile(
                          title: Center(child: Text(listem[index],style: TextStyle(color: sari,fontSize: height/50),)),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          fonksiyon_adi = listem[index].toString();

                          if (fonksiyon_adi == "ADD CUSTOMER") {
                            Navigator.push(
                              context,
                              FluentDialogRoute(
                                  builder: (context) => mekle_sayfasi(),
                                  context: context),
                            );
                          }
                          if (fonksiyon_adi == "DELETE CUSTOMER") {
                            Navigator.push(
                              context,
                              FluentDialogRoute(
                                  builder: (context) => msil_sayfasi(),
                                  context: context),
                            );
                          }
                          if (fonksiyon_adi == "SELECT CUSTOMER") {
                            Navigator.push(
                              context,
                              FluentDialogRoute(
                                  builder: (context) => msec_sayfasi(),
                                  context: context),
                            );
                          }

                          if (fonksiyon_adi == "ADD PRODUCT") {
                            Navigator.push(
                              context,
                              FluentDialogRoute(
                                  builder: (context) => urun_ekle_sayfasi(),
                                  context: context),
                            );
                          }
                          if (fonksiyon_adi == "DELETE PRODUCT") {
                            Navigator.push(
                              context,
                              FluentDialogRoute(
                                  builder: (context) => urun_sil_sayfasi(),
                                  context: context),
                            );
                          }

                          if (fonksiyon_adi == "UPDATE PRODUCT") {
                            Navigator.push(
                              context,
                              FluentDialogRoute(
                                  builder: (context) => urun_guncelle_sayfasi(),
                                  context: context),
                            );
                          }
                        });
                      },
                    );
                  },
                ),
                ),],
              )),
            Flexible(child:     GridView.builder(
              primary: false,
              padding: EdgeInsets.all(10),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: odeme_listem.length,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8,
                mainAxisExtent: height/20,
              ),
              itemBuilder: (BuildContext context, int index) {
                return   Card(child: Row(
                    children: [
                      RadioButton(checked: true ,style: RadioButtonThemeData(), onChanged: (value) {
                        odeme_seklim = odeme_listem[index];

                      },),
                      SizedBox(width: width/200,),
                      Text(odeme_listem[index],style: TextStyle(fontSize: height/65),),]
                ));
              },
            ),),
            GestureDetector(onTap: () {
              setState(() {
                if(secilen_musteri["name"] == null )
                  {
                    secilen_musteri["name"] = "unknown";
                  };

                if(secilen_musteri["phone"] == null )
                {
                  secilen_musteri["phone"] = "unknown";
                };

                if(secilen_musteri["adress"] == null )
                {
                  secilen_musteri["adress"] = "unknown";
                };
                _isPrinting = true;
              });
              Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
                final doc = pw.Document();
                doc.addPage(
                    pw.MultiPage(
                    pageFormat: PdfPageFormat.a4,


                    build: (pw.Context context) {


                      return <pw.Widget>[ pw.Column(
                          children: [
                            pw.Text("INDUSTRIAL AUTOMATION",style: const pw.TextStyle(fontSize: 38)),
                            pw.SizedBox(height: 15),
                            pw.Text("--------------------------------------------------------------------------------",
                                style: const pw.TextStyle(fontSize: 17)),
                            pw.ListView.builder(itemBuilder: (context, index) {
                            return
                              pw.Text(products[index]["name"] +"   " + products[index]["price"] + "  TL",
                                 style: pw.TextStyle(
                                   fontSize: 35,)
                            );

                          }, itemCount: products.length),


                            pw.SizedBox(height: 8),
                            pw.Text("Note : " + _notController.text,style: const pw.TextStyle(fontSize: 35)),
                            pw.SizedBox(height: 10),
                            pw.Text("Total Cost :  " + toplam_fiyat_fonksiyonu().toString(),style: const pw.TextStyle(fontSize: 35)),
                            pw.Text("--------------------------------------------------------------------------------"),
                            pw.SizedBox(height: 7),
                            pw.Text("Payment method :  " + odeme_seklim,style: const pw.TextStyle(fontSize: 35)),
                            pw.SizedBox(height: 5),
                            pw.Text("Customer name :  " + secilen_musteri["name"].toString(),style: const pw.TextStyle(fontSize: 35)),
                            pw.SizedBox(height: 5),
                            pw.Text("Customer phone :  " + secilen_musteri["phone"].toString(),style: const pw.TextStyle(fontSize: 35)),
                            pw.SizedBox(height: 5),
                            pw.Center(child:  pw.Text("Customer adress :  " + secilen_musteri["adress"].toString(),style: const pw.TextStyle(fontSize: 35)),),
                            pw.Text("--------------------------------------------------------------------------------"),
                            pw.Text("ENJOY YOUR MEAL!  ",style: const pw.TextStyle(fontSize: 45)),
                          ])];
                    }));

                return doc.save();
              }).then((value) {
                setState(() {
                  _isPrinting = false;
                });
              });
            },child:  Container(margin: EdgeInsets.only(top: height/70,bottom: height/70),decoration: BoxDecoration
              (color: Colors.green,borderRadius: BorderRadius.circular(10)),
              height: height/11,width: width/7.2,
              child: Center(
                child: Text("PRINT",style: TextStyle(color: Colors.white,fontSize: height/35,fontWeight: FontWeight.bold)),
              ),),),
               GestureDetector(onTap: () {

                 Navigator.push(
                     context,
                     PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => FirestoreApp(),)
                 );
               },child:  Container(
                 margin: EdgeInsets.all(10),decoration: BoxDecoration
                 (color: Colors.red,borderRadius: BorderRadius.circular(10)),
                 height: height/11,width: width/7.2,
                 child: Center(
                   child: Text("REFRESH",style: TextStyle(color: Colors.white,fontSize: height/35,fontWeight: FontWeight.bold)),
                 ),),),

    ])
          ),
          Container(
            color: mavi,
            width: width * 0.29,
            child: Column(
              children: [Text("SELECTED PRODUCTS",style: TextStyle(color: Colors.black,fontSize: height/30),),
              SizedBox(height: height/90,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(opacity: 0.4,image: AssetImage("images/fblogo.jpg",
                  )),
                ),
                height: height*0.85,
                width: width*0.25 ,
                child: ListView.builder(
                itemCount: products.length,
                scrollDirection: Axis.vertical,
                primary: false,
                itemBuilder: (context, index) {

                  return Text(products[index]["name"] +"   " + products[index]["price"] + "  TL",style: TextStyle(fontSize: height/30),);
                },),
              ),
              SizedBox(height: height/40,),
              Text("TOTAL PRICE :  " + toplam_fiyat_fonksiyonu().toString() + " TL ",style: TextStyle(fontSize: height/30),),
                Text("DEVELOPED BY HARUN ÖZDEMİR",style: TextStyle(fontSize: height/60,color: sari),)],

            ),
          ),
          Container(
            width: width * 0.15,
            color: sari,
            child: Column(children: [
              FutureBuilder<List<Document>>(
                future: getcategories(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Document>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text("Loading..."));
                  }

                  final categories = snapshot.data!;
                  if (categories.isEmpty) {
                    return const Center(child: Text("No categories in list"));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Container(


                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  category_name = categories[index]["name"];
                                });
                              },
                              child: Container(
                                height: height / 8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: mavi),
                                child: ListTile(
                                  title: Center(
                                    child: Text(categories[index]["name"],
                                        style: TextStyle(fontSize: height/50,color: sari)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 99,
                            ),
                          ],
                        ),
                      );
                    },
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  );
                },
              ),
            ]),
          ),
          SizedBox(
            width: width / 100,
          ),
          Container(
            width: width * 0.39,

            color: mavi,
            child: Column(
              children: [
              Container(
                height: height*0.9,
                child: Column(
                  children: [  FutureBuilder<List<Document>>(
                    future: getProduct(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Document>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: Text("Loading..."));
                      }

                      final product = snapshot.data!;
                      final filteredProducts = product
                          .where(
                              (product) => product['category'] == category_name)
                          .toList();

                      if (filteredProducts.isEmpty) {
                        return Center(
                            child: Text('No products found in this category.'));
                      }

                      if (product.isEmpty) {
                        return const Center(child: Text("No categories in list"));
                      }

                      return Flexible(child:  GridView.builder(


                        primary: false,
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: filteredProducts.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                          mainAxisExtent: height/9,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final product = filteredProducts[index];
                          return Button(
                            style: ButtonStyle(backgroundColor: ButtonState.all(sari)),
                            child: ListTile(
                              title: Text(product['name'] + "  "  + product['price'].toString() + ' TL',style: TextStyle(fontWeight: FontWeight.bold,fontSize: height/40,color: mavi)),
                            ),


                            onPressed: () {

                              setState(() {
                                products.add(   {'name': product['name'].toString() , 'price': product['price'].toString()});
                              });

                            },
                          );
                        },
                      ));
                    },
                  ),],
                ),
              ),
              Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: height*0.09,
                margin: EdgeInsets.only(left:5 ,right: 5),
                child: Center(
                    child: TextBox(
                      decoration: BoxDecoration(color: Colors.white),
                      controller: _notController,
                      placeholder: 'NOTE : ',
                    ),
                  ),

              )

         ],
            ),
          ),
        ],
      ),
    );
  }
}

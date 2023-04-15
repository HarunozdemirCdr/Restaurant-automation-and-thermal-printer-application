import 'package:fluent_ui/fluent_ui.dart';
import 'package:firedart/firedart.dart';
import 'package:windows_firebase/main.dart';

class urun_ekle_sayfasi extends StatefulWidget {
  const urun_ekle_sayfasi({Key? key}) : super(key: key);

  @override
  State<urun_ekle_sayfasi> createState() => urun_ekle_sayfasiState();
}

class urun_ekle_sayfasiState extends State<urun_ekle_sayfasi> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _categorycontroller;

  @override
  void initState() {
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _categorycontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categorycontroller.dispose();
    super.dispose();
  }

  final product_collection = Firestore.instance.collection('product');

  Future<void> addNewCustomer(String name, String price,String category) async {
    // Yeni belge (doküman) için bir Map oluşturuyoruz
    Map<String, dynamic> newCustomer = {
      'name': name,
      'price': price,
      "category" : category
    };

    // customers koleksiyonuna yeni belge (doküman) ekliyoruz
    await product_collection.add(newCustomer);

    print('PRODUCT SUCCESFULLY ADDED!');
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
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          SizedBox(height: height/40,),
          Container(height: height/6,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
              margin: EdgeInsets.all(height/30),
              child: Center(child: Text("ADD PRODUCTS SECTION",style: TextStyle(color: Colors.black,fontSize: height/45)),)),
          SizedBox(height: height/40,),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
            height: height/10,
            child:   Center(child: TextBox(
              decoration: BoxDecoration(color: Colors.white),
              controller: _nameController,
              placeholder: 'ENTER PRODUCT NAME : ',
            ),),
          ),
          SizedBox(height: height/30,),
          Container(
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(15),

              height: height/10,
              child: Center(child:TextBox(
                decoration: BoxDecoration(color: Colors.white),
                controller: _priceController,
                placeholder: 'ENTER PRODUCT PRICE : ',
              ),)),
          SizedBox(height: height/30,),
          Container(
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(15),

              height: height/10,
              child: Center(child:TextBox(
                decoration: BoxDecoration(color: Colors.white),
                controller: _categorycontroller,
                placeholder: 'ENTER PRODUCT CATEGORY : ',
              ),)),


          SizedBox(height: height/20,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [         GestureDetector(onTap: (){  if(!_nameController.text.isEmpty  || !_priceController.text.isEmpty  || !_categorycontroller.text.isEmpty ){
                addNewCustomer(
                  _nameController.text,
                  _priceController.text,
                  _categorycontroller.text
                );

              };

              print("NO INFORMATION WAS ENTERED...");
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FirestoreApp(),
                ),
              );},child:
              Container(
                  height: height/15,
                  width: width/6,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.green),


                  child: Center(child: Text("SAVE",style: TextStyle(color: Colors.white),),
                  )
              ),),
                SizedBox(width: width/20 ,),
                GestureDetector(onTap: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FirestoreApp(),
                    ),
                  );},child:
                Container(
                    height: height/15,
                    width: width/6,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.red),


                    child: Center(child: Text("BACK",style: TextStyle(color: Colors.white),),
                    )
                ),),
              ]),
        ],
      ),
    );
  }
}

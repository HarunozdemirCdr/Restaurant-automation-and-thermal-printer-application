import 'package:fluent_ui/fluent_ui.dart';
import 'package:firedart/firedart.dart';
import 'package:windows_firebase/main.dart';

class mekle_sayfasi extends StatefulWidget {
  const mekle_sayfasi({Key? key}) : super(key: key);

  @override
  State<mekle_sayfasi> createState() => _mekle_sayfasiState();
}

class _mekle_sayfasiState extends State<mekle_sayfasi> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  final customer_collection = Firestore.instance.collection('customer');

  Future<void> addNewCustomer(String name, String adress, String phone) async {
    // Yeni belge (doküman) için bir Map oluşturuyoruz
    Map<String, dynamic> newCustomer = {
      'name': name,
      'adress': adress,
      'phone': phone,
    };

    // customers koleksiyonuna yeni belge (doküman) ekliyoruz
    await customer_collection.add(newCustomer);

    print('CUSTOMER SUCCESSFULLY ADDED !');
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

      child: Expanded(
        child: Column(
          children: [Container(
            height: height*0.9,
            color: Colors.yellow,
            child: Column(
              children: [
                SizedBox(height: height/40,),
                Container(height: height/10,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                    margin: EdgeInsets.all(height/30),
                    child: Center(child: Text("ADD CUSTOMER SECTION",style: TextStyle(color: Colors.black,fontSize: height/45)),)),
                SizedBox(height: height/40,),
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                  height: height/10,
                  child:   Center(child: TextBox(
                    decoration: BoxDecoration(color: Colors.white),
                    controller: _nameController,
                    placeholder: 'PLEASR ENTER CUSTOMER NAME : ',
                  ),),
                ),
                SizedBox(height: height/30,),
                Container(
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(15),

                    height: height/10,
                    child: Center(child:TextBox(
                      decoration: BoxDecoration(color: Colors.white),
                      controller: _addressController,
                      placeholder: 'PLEASE ENTER CUSTOMER ADRESS : ',
                    ),)),

                SizedBox(height: height/30,),
                Container(margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),

                    child:  Center(child: TextBox(
                      decoration: BoxDecoration(color: Colors.white),

                      controller: _phoneController,
                      placeholder: 'PLEASE ENTER CUSTOMER PHONE : ',
                    ),),height: height/10),
                SizedBox(height: height/20,),
                Flexible(child:     Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [         GestureDetector(onTap: (){  if(!_nameController.text.isEmpty  || !_phoneController.text.isEmpty || !_addressController.text.isEmpty){
                      addNewCustomer(
                        _nameController.text,
                        _addressController.text,
                        _phoneController.text,
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
                      SizedBox(width: width/30 ,),
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
                    ]),)
              ],
            ),
          )],
        ),
      ),
    );
  }
}

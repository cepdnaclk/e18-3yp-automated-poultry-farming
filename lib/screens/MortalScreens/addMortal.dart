import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_login/constants.dart';
import 'package:home_login/screens/griddashboard.dart';
import 'package:home_login/screens/reusable.dart';
import 'package:get/get.dart';
import 'package:home_login/screens/view_screen.dart';
//import 'drawerMenu.dart';

class AddMortal extends StatefulWidget {
  final String id_flock;

  AddMortal({
    Key? key,
    required this.id_flock,
  }) : super(key: key);

  @override
  State<AddMortal> createState() => _AddMortalState();
}

class _AddMortalState extends State<AddMortal> with TickerProviderStateMixin {
  List weightDataCobb500 = [];

  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _numcontroller = TextEditingController();

  double translateX = 0.0;
  double translateY = 0.0;
  double scale = 1;
  bool toggle = false;
  late AnimationController _animationController;


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Mortality".tr,
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: mPrimaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Farmers")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('flock')
                      .doc(widget.id_flock)
                      .collection('Mortality')
                      .where(FieldPath.documentId,
                          isEqualTo: date.toString().substring(0, 10))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    num amount = -1;
                    try {
                      amount = snapshot.data?.docs[0]['Amount'];
                    } catch (e) {
                      amount = -1;
                    }
                    if (amount == -1 || amount == 0) {
                      return Center(
                        // height: 60.0,
                        child: Text(
                          "You haven't recorded mortalities for " +
                              date.toString().substring(0, 10),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 20, color: mPrimaryTextColor),
                        ),
                      );
                    } else {
                      return Center(
                        //height: 60.0,
                        child: Text(
                          "You have already recorded ${snapshot.data?.docs[0]['Amount']} mortalities for ${date.toString().substring(0, 10)}",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 20, color: mPrimaryTextColor),
                        ),
                      );
                    }
                  }),

              //reuseTextField("Mortality"),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
                //child: reuseTextField1("Number of chicks"),

                child: reusableTextField2("Enter Number of chicks".tr,
                    Icons.numbers, false, _numcontroller, null, ""),
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 15.0),
                      child: reusableTextField3(
                          date.toString().substring(0, 10),
                          Icons.date_range,
                          false,
                          _datecontroller,
                          null,
                          false),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 15.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          DateTime? ndate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2022),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: mNewColor,
                                    onPrimary: Colors.white, // <-- SEE HERE
                                    onSurface: mSecondColor, // <-- SEE HERE
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary:
                                          mPrimaryColor, // button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (ndate == null) return;
                          setState(() => date = ndate);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(180, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                width: 2.0,
                                color: mPrimaryColor,
                              )),
                          primary: mBackgroundColor,
                          elevation: 20,
                          shadowColor: Colors.transparent,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text(
                          "pickDate".tr,
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 40,
              ),
              Center(
                child: Image.asset(
                  "assets/images/dead.png",
                  fit: BoxFit.fitWidth,
                  width: context.width * 0.4,
                  // height: 420,
                  //color: Colors.purple,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // print(args.flockID);
                    // print(_numcontroller.text);
                    // print(date);
                    await addMortality(widget.id_flock, _numcontroller.text,
                        date.toString().substring(0, 10));
                    _numcontroller.clear();
                    setState(() {});
                    //Navigator.of(context).pop();

                    ///displayFCRdialog();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    primary: mPrimaryColor,
                    elevation: 20,
                    shadowColor: mSecondColor,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text("add".tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addMortality(String id, String amount, String date) async {
    num current = 0;
    num value = int.parse(amount);
    try {

      DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance
              .collection('Farmers')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('flock')
              .doc(id)
              .collection('Mortality')
              .doc(date);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(documentReference);

        if (!snapshot.exists) {
          documentReference.set({'Amount': value});


        } else {
          try {

            num n = snapshot.data()!['Amount'];
            num newAmount = n + value;
            transaction.update(documentReference, {'Amount': newAmount});


          } catch (e) {

          }
        }
      });

    } catch (e) {
      // return false;
    }
    try {

      DocumentReference<Map<String, dynamic>> documentReference2 =
          FirebaseFirestore.instance
              .collection('Farmers')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('flock')
              .doc(id);

      FirebaseFirestore.instance.runTransaction((transaction2) async {
        DocumentSnapshot<Map<String, dynamic>> snapshot2 =
            await transaction2.get(documentReference2);
        print(documentReference2);
        if (!snapshot2.exists) {

          documentReference2.update({'Mortal': value});


        } else {
          try {

            num n = snapshot2.data()!['Mortal'];
            num newAmount = n + value;

            transaction2.update(documentReference2, {'Mortal': newAmount});

          } catch (e) {

          }
        }
      });
    } catch (e) {
      //
    }
  }
}

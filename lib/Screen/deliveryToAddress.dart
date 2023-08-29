import 'dart:convert';

import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class DeliverToPage extends StatefulWidget {
  const DeliverToPage({Key? key}) : super(key: key);

  @override
  State<DeliverToPage> createState() => _DeliverToPageState();
}

class _DeliverToPageState extends State<DeliverToPage> {
  // TextEditingController nameController = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  // TextEditingController mobileController1 = TextEditingController();

  // TextEditingController landmarkController = TextEditingController();
  // TextEditingController cityController = TextEditingController();
  // TextEditingController pincodeController = TextEditingController();
  String addressType = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController2 = TextEditingController();

  int currentIndex = 1;

  Future<void> setReceiverAddress() async {

    var data = {MOBILE: mobileController2.text.toString(), NAME: nameController.text.toString(), "user_id": CUR_USERID};
    print(data);
    Response response =
    await post(setReceiverAddressApi, body: data, headers: headers)
        .timeout(Duration(seconds: timeOut));
    var getdata = json.decode(response.body);

    bool error = getdata["error"];
    String? msg = getdata["message"];
    if (!error) {

      String receiverId = getdata['data']['insert_id'];
      print("this si my receiver id $receiverId");
      Navigator.pop(context,{
        "name":nameController.text,
        "mobile1":mobileController2.text,
        "id": receiverId.toString()
      });
      Navigator.pop(context, receiverId);
      //setSnackbar(msg!, context);
    } else {
     // setSnackbar(msg!, context);

    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: colors.primary,
          title: Text("Sender Address",style: TextStyle(color: Colors.white),),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
            children: [
              TextFormField(
                validator: (v){
                  if(v!.isEmpty){
                    return "Enter Name";
                  }
                },
                controller: nameController,decoration: InputDecoration(
                hintText: "Sender Name",
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey),
                )
              ),),
              SizedBox(height: 10,),
              // TextFormField(
              //   validator: (v){
              //     if(v!.isEmpty){
              //       return "Enter Address";
              //     }
              //   },
              //   controller: addressController,
              //   decoration: InputDecoration(
              //     hintText: "Recipient's Address",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(6),
              //       borderSide: BorderSide(color: Colors.grey),
              //     )
              // ),),
              // SizedBox(height: 10,),
              // TextFormField(
              //   validator: (v){
              //     if(v!.length != 10){
              //       return "Enter correct number";
              //     }
              //   },
              //   keyboardType: TextInputType.number,
              //   maxLength: 10,
              //   controller: mobileController1,decoration: InputDecoration(
              //     hintText: "Recipient's Mobile",
              //     counterText: "",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(6),
              //       borderSide: BorderSide(color: Colors.grey),
              //     )
              // ),),
              // SizedBox(height: 10,),
              TextFormField(
                validator: (v){
                  if(v!.length != 10){
                    return "Enter mobile";
                  }
                },
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: mobileController2,decoration: InputDecoration(
                  hintText: "Sender mobile",
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey),
                  )
              ),),
              // SizedBox(height: 10,),
              // TextFormField(
              //   // validator: (v){
              //   //   if(v!.isEmpty || !v.contains('@')){
              //   //     return "Enter landmark";
              //   //   }
              //   // },
              //   controller: landmarkController,decoration: InputDecoration(
              //     hintText: "Landmark",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(6),
              //       borderSide: BorderSide(color: Colors.grey),
              //     )
              // ),),
              // SizedBox(height: 10,),
              // TextFormField(
              //   // validator: (v){
              //   //   if(v!.isEmpty || !v.contains('@')){
              //   //     return "Enter city";
              //   //   }
              //   // },
              //   controller: cityController,decoration: InputDecoration(
              //     hintText: "City",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(6),
              //       borderSide: BorderSide(color: Colors.grey),
              //     )
              // ),),
              // SizedBox(height: 10,),
              // TextFormField(
              //   maxLength: 6,
              //   keyboardType: TextInputType.number,
              //   // validator: (v){
              //   //   if(v!.isEmpty || !v.contains('@')){
              //   //     return "Enter pincode";
              //   //   }
              //   // },
              //   controller: pincodeController,decoration: InputDecoration(
              //   counterText: "",
              //     hintText: "pincode",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(6),
              //       borderSide: BorderSide(color: Colors.grey),
              //     )
              // ),),
              // SizedBox(height: 10,),
              // Text("Address Type",style: TextStyle(fontSize: 15),),
              // SizedBox(height: 10,),
            //   Container(
            //     width: MediaQuery.of(context).size.width,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //
            //         InkWell(
            //           onTap: (){
            //             setState(() {
            //               currentIndex = 1;
            //             });
            //           },
            //           child: Container(
            //             child: Row(
            //               children: [
            //                 Container(
            //                   height: 20,
            //                   width: 20,
            //                   padding: EdgeInsets.all(3),
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(100),
            //                     border: Border.all(color: currentIndex == 1  ?colors.primary : Colors.grey,width: 2)
            //                   ),
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(100),
            //                       color: currentIndex == 1 ? colors.primary : Colors.transparent
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(width: 10,),
            //                 Text('Home',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
            //               ],
            //             ),
            //           ),
            //         ),
            //         InkWell(
            //           onTap: (){
            //             setState(() {
            //               currentIndex =2;
            //             });
            //           },
            //           child: Container(
            //             child: Row(
            //               children: [
            //                 Container(
            //                   height: 20,
            //                   width: 20,
            //                   padding: EdgeInsets.all(3),
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(100),
            //                       border: Border.all(color: currentIndex == 2 ? colors.primary : Colors.grey,width: 2)
            //                   ),
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(100),
            //                         color: currentIndex == 2 ? colors.primary : Colors.transparent
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(width: 10,),
            //                 Text('Office',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
            //               ],
            //             ),
            //           ),
            //         ),
            //         InkWell(
            //           onTap: (){
            //             setState(() {
            //               setState(() {
            //                 currentIndex = 3;
            //               });
            //             });
            //           },
            //           child: Container(
            //             child: Row(
            //               children: [
            //                 Container(
            //                   height: 20,
            //                   width: 20,
            //                   padding: EdgeInsets.all(3),
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(100),
            //                       border: Border.all(color: currentIndex == 3 ? colors.primary : Colors.grey,width: 2)
            //                   ),
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(100),
            //                         color: currentIndex == 3 ? colors.primary : Colors.transparent
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(width: 10,),
            //                 Text('Other',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
             SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  if(_formKey.currentState!.validate()){
                    setReceiverAddress();

                  }
                  else{
                    Fluttertoast.showToast(msg: "All Fields are required");
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: colors.primary
                  ),
                  child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),),
                ),
              )
            ],
          ),
        ),
      );
  }
}

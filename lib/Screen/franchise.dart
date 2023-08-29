import 'dart:convert';

import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Helper/Color.dart';
import 'package:http/http.dart'as http;


class Franchise extends StatefulWidget {
   Franchise({Key? key}) : super(key: key);

  @override
  State<Franchise> createState() => _FranchiseState();

}

class _FranchiseState extends State<Franchise> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController queryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // void initState() {
  //   franchise();
  // }

  franchise() async {
    var headers = {
      'Cookie': 'ci_session=c8f26096a8b1729a49dc87e2e1c846ad4eb40605'
    };
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/add_franchise'));
    request.fields.addAll({
          'name': nameController.text,
          'email': emailController.text,
          'mobile': mobileController.text,
          'city': cityController.text,
          'query': queryController.text
    });
    print("###############################${request.fields}");

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      final result = await response.stream.bytesToString();
      var finalData = json.decode(result);

      Fluttertoast.showToast(msg: "${finalData['message']}");
      setState(() {
        nameController.clear();
        emailController.clear();
        mobileController.clear();
        cityController.clear();
        queryController.clear();
      });

    }
    else {
    print(response.reasonPhrase);
    }

  }

  // async {
  //   var headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //     'Cookie': 'ci_session=c13997d059acc14fca89f5881609f05d9cc1a911'
  //   };
  //   var request = http.Request('POST', Uri.parse('$baseUrl/add_franchise'));
  //   request.bodyFields = {
  //     'name': ' ${nameController}',
  //     'email': ' ${emailController}',
  //     'mobile': '${mobileController}',
  //     'city': ' ${cityController}',
  //     'query': ' ${queryController}'
  //
  //   };
  //
  //   request.headers.addAll(headers);
  //
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   }
  //   else {
  //
  //   }
  //
  //
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text('REQUEST A CALLBACK',style: TextStyle(color: colors.blackTemp),),
        centerTitle: true,
      ),
      backgroundColor: colors.whiteTemp,
      body: Form(
        key: _formKey,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 32.0),
              child: Column(
                children: [
                  TextFormField(
                    validator: (v){
                      if(v!.isEmpty){
                        return "Name is required";
                      }
                    },
                    controller: nameController,decoration: InputDecoration(
                        hintText: "Name ",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (v){
                      if(v!.isEmpty){
                        return "Email Id is required";
                      }
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Email Id",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (v){
                      if(v!.isEmpty){
                        return "Mobile No is required";
                      }
                    },
                    controller: mobileController,
                    decoration: InputDecoration(
                        hintText: "Mobile",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (v){
                      if(v!.isEmpty){
                        return "City is required";
                      }
                    },
                    controller: cityController,
                    decoration: InputDecoration(
                        hintText: "City",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (v){
                      if(v!.isEmpty){
                        return "Query is required";
                      }
                    },
                    controller: queryController,
                    decoration: InputDecoration(
                        hintText: "Your Query",
                    ),
                  ),
                  SizedBox(height: 5,),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children:
                  [
                    InkWell(
                  onTap: (){
                    if(_formKey.currentState!.validate()){
                      Navigator.pop(context,{
                        'name': nameController.text,
                        'email': emailController.text,
                        'mobile': mobileController.text,
                        'city': cityController.text,
                        'query': queryController.text

                      });
                      franchise();
                    }
                    else{
                      Fluttertoast.showToast(msg: "All Fields are required");
                    }

                  },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),

                              border: Border.all(color: colors.blackTemp),color: colors.primary

                          ),
                          height: 40,
                          width: 80,
                          child: Center(child: Text('Submit',style: TextStyle(color: colors.blackTemp),)),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                          border: Border.all(color: colors.blackTemp)
                      ),

                      height: 40,
                      width: 80,
                      child: Center(child: Text('Reset',style: TextStyle(color: colors.blackTemp),)),
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

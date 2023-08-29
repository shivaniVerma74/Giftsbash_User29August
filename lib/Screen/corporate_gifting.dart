import 'dart:convert';

import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Helper/Color.dart';
import 'package:http/http.dart'as http;


class CorporateGifting extends StatefulWidget {
  const CorporateGifting({Key? key}) : super(key: key);

  @override
  State<CorporateGifting> createState() => _CorporateGiftingState();
}

class _CorporateGiftingState extends State<CorporateGifting> {
  TextEditingController FirstnameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController CompanyController = TextEditingController();
  TextEditingController RequirementTypeController = TextEditingController();
  TextEditingController EmployeeController = TextEditingController();
  TextEditingController MobileController = TextEditingController();
  TextEditingController BussinessController = TextEditingController();
  TextEditingController CityController = TextEditingController();



  final _formKey = GlobalKey<FormState>();
  // void initState() {
  //   corporategift();
  //
  // }

  corporategift() async {
    var headers = {
      'Cookie': 'ci_session=e65804ba24eb1d512711746455d70950c97eed1c'
    };
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/add_corporate_gifting'));
    request.fields.addAll({
      'first_name': FirstnameController.text,
      'last_name': lastNameController.text,
      'company_name': CompanyController.text,
      'requirement': RequirementTypeController.text,
      'employee': EmployeeController.text,
      'mobile': MobileController.text,
      'business_email':BussinessController.text,
      'city': CityController.text

    });
    print("Siiiiiiiiiiiiiiiiiiiiiiiii${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var finalData = json.decode(result);
      print("ppppppppppppppp=============${finalData}");

      Fluttertoast.showToast(msg: "${finalData['message']}");
      setState(() {
        FirstnameController.clear();
        lastNameController.clear();
        CompanyController.clear();
        RequirementTypeController.clear();
        EmployeeController.clear();
        MobileController.clear();
        BussinessController.clear();
        CityController.clear();
      });


    }
    else {
      print(response.reasonPhrase);
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text('Talk to our specialist Sales team now.',style: TextStyle(color: colors.blackTemp,fontSize: 15),),
      ),
      backgroundColor: colors.whiteTemp,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
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
                     controller:FirstnameController,
                      decoration: InputDecoration(
                          hintText: "First Name",
                          labelText: 'First Name'
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      validator: (v){
                        if(v!.isEmpty){
                          return "last name is required";
                        }
                      },
                      controller: lastNameController,
                      decoration: InputDecoration(
                          hintText: "Last Name",
                          labelText: 'Last Name'
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      validator: (v){
                        if(v!.isEmpty){
                          return "Company name is required";
                        }
                      },
                      controller: CompanyController,
                      decoration: InputDecoration(
                          hintText: "Company Name",
                          labelText: 'Company Name'
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      validator: (v){
                        if(v!.isEmpty){
                          return " Requirement type is required";
                        }
                      },
                      controller:RequirementTypeController ,

                      decoration: InputDecoration(
                          hintText: "Requirement Type",
                          labelText: 'Requirement Type'
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      validator: (v){
                        if(v!.isEmpty){
                          return " Employee Count is required";
                        }
                      },
                      controller: EmployeeController,

                      decoration: InputDecoration(
                          hintText: "Employee Count",
                          labelText: 'Employee Count'
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      keyboardType:TextInputType.number,
                      maxLength: 10,
                      validator: (v){
                        if(v!.isEmpty){
                          return "Mobile No is required";
                        }
                      },
                      controller: MobileController,

                      decoration: InputDecoration(
                        counterText: "",
                          hintText: "Mobile Number",
                          labelText: 'Mobile Number'
                      ),
                    ),
                    SizedBox(height: 10,),

                    TextFormField(
                      keyboardType:TextInputType.emailAddress,
                      validator: (v){
                        if(v!.isEmpty){
                          return "Bussiness Email is required";
                        }
                      },
                      controller: BussinessController,

                      decoration: InputDecoration(
                          hintText: "Bussiness Email",
                          labelText: 'Bussiness Email'
                      ),
                    ),
                    SizedBox(height: 10,),

                    TextFormField(
                      validator: (v){
                        if(v!.isEmpty){
                          return "City is required";
                        }
                      },
                      controller: CityController,

                      decoration: InputDecoration(
                          hintText: "City",
                          labelText: 'City'
                      ),
                    ),
                    SizedBox(height: 5,),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        if(_formKey.currentState!.validate()){
                          Navigator.pop(context,{
                            'first_name': FirstnameController.text,
                            'last_name': lastNameController.text,
                            'company_name': CompanyController.text,
                            'requirement': RequirementTypeController.text,
                            'employee': EmployeeController.text,
                            'mobile': MobileController.text,
                            'business_email':BussinessController.text,
                            'city': CityController.text
                          });
                          corporategift();
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

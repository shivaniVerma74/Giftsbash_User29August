// import 'dart:io';
// import 'dart:math';
//
// import 'package:eshop_multivendor/Helper/Color.dart';
// import 'package:eshop_multivendor/Helper/Constant.dart';
// import 'package:eshop_multivendor/Helper/Public%20Api/api.dart';
// import 'package:eshop_multivendor/Helper/widgets.dart';
// import 'package:eshop_multivendor/Model/UpdateUserModels.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
//
// class EditProfile extends StatefulWidget {
//   const EditProfile({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   bool edit = true;
//   DateTime selectedDate = DateTime.now();
//
//   var userNameController = TextEditingController();
//   var emailController = TextEditingController();
//   var dob;
//
//   String? newDob;
//   //image
//
//   File? _image;
//   final picker = ImagePicker();
//
//   String? typeImage;
//
//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _cropImage(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future<Null> _cropImage(image) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//         sourcePath: image,
//         aspectRatioPresets: Platform.isAndroid
//             ? [
//           CropAspectRatioPreset.square,
//         ]
//             : [
//           CropAspectRatioPreset.square,
//         ],
//        /* androidUiSettings: AndroidUiSettings(
//             toolbarTitle: 'ZuqZuq',
//             toolbarColor: colors.primary,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         iosUiSettings: IOSUiSettings(
//           title: 'Cropper',
//         )*/
//     );
//     if (croppedFile != null) {
//       showToast("Uploading Image");
//       _image = File(croppedFile.path);
//       setState(() {
//       });
//       UpdateUserModels? model =await uploadImage(typeImage == "pro"?"image":"bank_pass", _image!.path);
//        if(model!.error == false){
//          setState(() {
//            showToast(model.message);
//          });
//        }
//
//     }
//   }
//
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//       return false;
//       },
//       child: Scaffold(
//         body: FutureBuilder(
//             future: userDetails(),
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               if (snapshot.hasData) {
//                 var user = snapshot.data;
//                 return Scaffold(
//                   appBar: AppBar(
//                     leading: IconButton(onPressed: (){
//                       Navigator.pop(context , true);
//                     }, icon: Icon(Icons.arrow_back)),
//                     backgroundColor: Colors.white,
//                     iconTheme: IconThemeData(color: colors.primary),
//                     actions: [
//                       edit
//                           ? TextButton(
//                               onPressed: () {
//                                 setState(() {
//                                   edit = false;
//                                   userNameController.text =
//                                       user!.date![0].username;
//                                   emailController.text = user!.date![0].email;
//                                   dob = user!.date![0].dob;
//                                 });
//                               },
//                               child: Text("Edit", style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14 , color: colors.primary)))
//                           : TextButton(
//                               onPressed: () async {
//                                 if (dob != null) {
//                                   DateTime date = selectedDate;
//                                   var userName = userNameController.text;
//                                   var email = emailController.text;
//                                   var updateDOB = dob == null
//                                       ? "${date.day}-${date.month}-${date.year}"
//                                       : dob;
//                                   UpdateUserModels? model =
//                                       await updateUserDetails(
//                                           userName, email, updateDOB);
//                                   if (model!.error == false) {
//                                     setState(() {
//                                       showToast(model.message);
//                                       edit = true;
//                                     });
//                                   } else {
//                                     showToast(model.message);
//                                   }
//                                 }else{
//                                   showToast("Select Date");
//                                 }
//                               },
//                               child: Text("Save" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 , color: colors.primary),))
//                     ],
//                     title: Text(
//                       "Profile",
//                       style: TextStyle(color: colors.primary),
//                     ),
//                   ),
//                   body: ListView(
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       edit
//                           ? Column(
//                               children: [
//                                 Stack(
//                                   alignment: Alignment.bottomRight,
//                                   children: [
//                                     user!.date![0].proPic != ""
//                                         ? CircleAvatar(
//                                             backgroundColor: Colors.white,
//                                             radius: 50,
//                                             backgroundImage: NetworkImage(
//                                                 "$imageUrl${user!.date![0].proPic}"),
//                                           )
//                                         : CircleAvatar(
//                                             radius: 50,
//                                             child: Icon(
//                                               Icons.person,
//                                               color: Colors.white,
//                                               size: 40,
//                                             ),
//                                           ),
//                                     CircleAvatar(
//                                         radius: 15,
//                                         backgroundColor: Colors.white,
//                                         child: IconButton(
//                                             onPressed: () {
//                                               typeImage = "pro";
//                                               getImage();
//                                             },
//                                             icon: Icon(
//                                               Icons.edit,
//                                               color: colors.primary,
//                                               size: 15,
//                                             )))
//                                   ],
//                                 ),
//                                 ListTile(
//                                   leading: Icon(Icons.person),
//                                   title: Text("User Name"),
//                                   trailing: Text("${user!.date![0].username}"),
//                                 ),
//                                 ListTile(
//                                   leading: Icon(Icons.email),
//                                   title: Text("Email Id"),
//                                   trailing: Text("${user!.date![0].email}"),
//                                 ),
//                                 ListTile(
//                                   leading: Icon(Icons.call),
//                                   title: Text("Phone Number"),
//                                   trailing: Text("${user!.date![0].mobile}"),
//                                 ),
//                                 ListTile(
//                                   leading: Icon(Icons.accessibility),
//                                   title: Text("Gender"),
//                                   trailing: Text("${user!.date![0].gender}"),
//                                 ),
//                                 ListTile(
//                                   leading: Icon(Icons.date_range),
//                                   title: Text("Date Of Birth"),
//                                   trailing: user!.date![0].dob != null
//                                       ? Text("${user!.date![0].dob}")
//                                       : TextButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               edit = false;
//                                               userNameController.text =
//                                                   user!.date![0].username;
//                                               emailController.text =
//                                                   user!.date![0].email;
//                                               dob = user!.date![0].dob;
//                                             });
//                                           },
//                                           child: Text("Update")),
//                                 ),
//                                 SizedBox(height: 10,),
//
//                                 Row(
//                                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 20),
//                                       child: Icon(Icons.document_scanner,color: colors.blackTemp.withOpacity(0.4)),
//                                     ),
//                                     SizedBox(width: 30,),
//                                     Text("Upload Passbook",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 15),),
//                                     SizedBox(width: 80,),
//                                     InkWell(
//                                         onTap: (){
//                                           typeImage ="pas";
//                                           getImage();
//                                     },
//                                         child: Text("Upload",style: TextStyle(color: colors.red))),
//
//                                   ],
//                                 ),
//
//                                 ListTile(
//                                   // leading:  Icon(Icons.document_scanner),
//                                   // title: Text("Upload Passbook"),
//                                   // trailing: TextButton(
//                                   //         onPressed: () {
//                                   //           typeImage ="pas";
//                                   //           getImage();
//                                   //         },
//                                   //     child: Text("Upload"),
//                                   // ),
//                                   subtitle: user!.date![0].bankPass != ""
//                                       ? Padding(
//                                         padding: const EdgeInsets.only(top: 10),
//                                         child: Container(
//                                     height: 170,
//                                           width: 150,
//                                           child: Image.network(
//                                               "$imageUrl${user!.date![0].bankPass}",),
//                                         ),
//                                       )
//                                       : Text(""),
//                                 )
//                               ],
//                             )
//                           : Card(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Column(
//                                   children: [
//                                     TextField(
//                                       controller: userNameController,
//                                       decoration: InputDecoration(
//                                           label: Text("User Name")),
//                                     ),
//                                     TextField(
//                                       controller: emailController,
//                                       decoration:
//                                           InputDecoration(label: Text("Email")),
//                                     ),
//                                     getDob(),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),
//                 );
//               } else if (snapshot.hasError) {
//                 return Icon(Icons.error_outline);
//               } else {
//                 return Center(child: CircularProgressIndicator());
//               }
//             }),
//       ),
//     );
//   }
//
//   getDob() {
//     DateTime date = selectedDate;
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(),
//       onTap: () {
//         _selectDate(context);
//       },
//       title: Align(
//           alignment: Alignment.topLeft,
//           child: Text("Select Date Of Birth")),
//       subtitle: dob != null
//           ? Text(dob)
//           : Text("dd-mm-yy"),
//       trailing: Icon(Icons.calendar_today_outlined),
//     );
//   }
//
//   _selectDate(BuildContext context) async {
//     final DateTime? selected = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(1970),
//         lastDate: DateTime.now(),
//         builder: (context, child) {
//           return Theme(
//             data: Theme.of(context).copyWith(
//               colorScheme: ColorScheme.light(
//                 primary: Color(0xffFF00FF), // header background color
//                 onPrimary: Colors.black, // header text color
//                 onSurface: Colors.black, // body text color
//               ),
//               textButtonTheme: TextButtonThemeData(
//                 style: TextButton.styleFrom(
//                   primary: Colors.black, // button text color
//                 ),
//               ),
//             ),
//             child: child!,
//           );
//         });
//     if (selected != null && selected != selectedDate)
//       setState(() {
//         selectedDate = selected;
//         DateTime date = selectedDate;
//         dob = "${date.day}-${date.month}-${date.year}";
//       });
//   }
// }


import 'dart:io';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/Public%20Api/api.dart';
import 'package:eshop_multivendor/Helper/widgets.dart';
import 'package:eshop_multivendor/Model/UpdateUserModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool edit = true;
  DateTime selectedDate = DateTime.now();

  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var dob;

  String? newDob;
  //image

  File? _image;
  final picker = ImagePicker();


  File? typeImage;

  imagePickerOption(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Pick-up Image'),
              content:  Container(
                color: Colors.white,
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Pic Image From",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          pickImage(ImageSource.camera);
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text("CAMERA"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          pickImage(ImageSource.gallery);
                        },
                        icon: const Icon(Icons.image),
                        label: const Text("GALLERY"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        label: const Text("CANCEL"),
                      ),
                    ],
                  ),
                ),
              )

          );
        });
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        typeImage = tempImage;
        print('image----------------file-----------${typeImage}');
        uploadImage(typeImage!);
      });

      Navigator.pop(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }



  // Future getImage() async {
  //
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.mediaLibrary,
  //   ].request();
  //
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _cropImage(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }
  // Future<Null> _cropImage(image) async {
  //   CroppedFile? croppedFile = await ImageCropper().cropImage(
  //       sourcePath: image,
  //       aspectRatioPresets: Platform.isAndroid
  //           ? [
  //         CropAspectRatioPreset.square,
  //       ]
  //           : [
  //         CropAspectRatioPreset.square,
  //       ],
  //      /* androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'ZuqZuq',
  //           toolbarColor: colors.primary,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         title: 'Cropper',
  //       )*/
  //   );
  //   if (croppedFile != null) {
  //     showToast("Uploading Image");
  //     _image = File(croppedFile.path);
  //     setState(() {
  //     });
  //     UpdateUserModels? model =await uploadImage(typeImage == "pro"?"image":"bank_pass", _image!.path);
  //      if(model!.error == false){
  //        setState(() {
  //          showToast(model.message);
  //        });
  //      }
  //
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
            future: userDetails(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var user = snapshot.data;
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(onPressed: (){
                      Navigator.pop(context , true);
                    }, icon: Icon(Icons.arrow_back)),
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: colors.primary),
                    actions: [
                      edit
                          ? TextButton(
                          onPressed: () {
                            setState(() {
                              edit = false;
                              userNameController.text =
                                  user!.date![0].username;
                              emailController.text = user!.date![0].email;
                              dob = user!.date![0].dob;
                            });
                          },
                          child: Text("Edit", style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14 , color: colors.primary)))
                          : TextButton(
                          onPressed: () async {
                            if (dob != null) {
                              DateTime date = selectedDate;
                              var userName = userNameController.text;
                              var email = emailController.text;
                              var updateDOB = dob == null
                                  ? "${date.day}-${date.month}-${date.year}"
                                  : dob;
                              UpdateUserModels? model =
                              await updateUserDetails(
                                  userName, email, updateDOB);
                              if (model!.error == false) {
                                setState(() {
                                  showToast(model.message);
                                  edit = true;
                                });
                              } else {
                                showToast(model.message);
                              }
                            }else{
                              showToast("Select Date");
                            }
                          },
                          child: Text("Save" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 , color: colors.primary),))
                    ],
                    title: Text(
                      "Profile",
                      style: TextStyle(color: colors.primary),
                    ),
                  ),
                  body: ListView(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      edit
                          ? Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              user!.date![0].proPic != ""
                                  ? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    "$imageUrl${user!.date![0].proPic}"),
                              )
                                  : CircleAvatar(
                                  radius: 50,
                                  child: typeImage != null
                                      ? Image.file(
                                    File(typeImage!.path),
                                    width: 170,
                                    height: 170,
                                    fit: BoxFit.cover,
                                  ):SizedBox()
                              ),
                              CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                      onPressed: () {
                                        typeImage ;
                                        // getImage();
                                        imagePickerOption(context);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: colors.primary,
                                        size: 15,
                                      )))
                            ],
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text("User Name",style:Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Theme.of(context).colorScheme.fontColor),),
                            trailing: Text("${user!.date![0].username}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text("Email Id",style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Theme.of(context).colorScheme.fontColor),),
                            trailing: Text("${user!.date![0].email}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.call),
                            title: Text("Phone Number",style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Theme.of(context).colorScheme.fontColor),),
                            trailing: Text("${user!.date![0].mobile}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.accessibility),
                            title: Text("Gender",style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Theme.of(context).colorScheme.fontColor),),
                            trailing: Text("${user!.date![0].gender}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.date_range),
                            title: Text("Date Of Birth",style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Theme.of(context).colorScheme.fontColor),),
                            trailing: user!.date![0].dob != null
                                ? Text("${user!.date![0].dob}")
                                : TextButton(
                                onPressed: () {
                                  setState(() {
                                    edit = false;
                                    userNameController.text =
                                        user!.date![0].username;
                                    emailController.text =
                                        user!.date![0].email;
                                    dob = user!.date![0].dob;
                                  });
                                },
                                child: Text("Update")),
                          ),
                          ListTile(
                            leading: Icon(Icons.document_scanner),
                            title: Text("Upload Passbook",style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Theme.of(context).colorScheme.fontColor),),
                            trailing: TextButton(
                              onPressed: () {
                                typeImage ;
                                // getImage();
                                imagePickerOption(context);
                              },
                              child: Text("Upload"),
                            ),
                            subtitle: user!.date![0].bankPass != ""
                                ? Container(
                              height: 170,
                              width: 150,
                              child: Image.network(
                                "$imageUrl${user!.date![0].bankPass}",),
                            )
                                : Text(""),
                          )
                        ],
                      )
                          : Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: userNameController,
                                decoration: InputDecoration(
                                    label: Text("User Name")),
                              ),
                              TextField(
                                controller: emailController,
                                decoration:
                                InputDecoration(label: Text("Email")),
                              ),
                              getDob(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.error_outline);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  getDob() {
    DateTime date = selectedDate;
    return Padding(
      padding: const EdgeInsets.only(left: 13),
      child: ListTile(
        onTap: () {
          _selectDate(context);
        },
        title: Text("Select Date Of Birth"),
        subtitle: dob != null
            ? Text(dob)
            : Text("dd-mm-yy"),
        trailing: Icon(Icons.calendar_today_outlined),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary:colors.primary, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        DateTime date = selectedDate;
        dob = "${date.day}-${date.month}-${date.year}";
      });
  }
}

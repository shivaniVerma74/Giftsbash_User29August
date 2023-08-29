// import 'dart:io';
//
// import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
// import 'package:eshop_multivendor/Model/UserDetails.dart';
// import 'package:eshop_multivendor/Screen/Dashboard2.dart';
// import 'package:eshop_multivendor/Screen/HomePage.dart';
// import 'package:eshop_multivendor/Screen/MyOrder.dart';
// import 'package:eshop_multivendor/Screen/MyProfile.dart';
// import 'package:eshop_multivendor/Screen/My_Wallet.dart';
// import 'package:eshop_multivendor/Screen/SendOtp.dart';
// import 'package:eshop_multivendor/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:share/share.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../Provider/SettingProvider.dart';
// import '../Provider/Theme.dart';
// import '../Provider/UserProvider.dart';
// import '../Screen/Customer_Support.dart';
// import '../Screen/Edit_Profile.dart';
// import '../Screen/Faqs.dart';
// import '../Screen/Login.dart';
// import '../Screen/Manage_Address.dart';
// import '../Screen/MyTransactions.dart';
// import '../Screen/Privacy_Policy.dart';
// import '../Screen/ReferEarn.dart';
// import '../Screen/Setting.dart';
// import 'Color.dart';
// import 'Constant.dart';
// import 'Public Api/api.dart';
// import 'Session.dart';
// import 'String.dart';
//
// class MyDrawer extends StatefulWidget {
//
//   @override
//   State<MyDrawer> createState() => _MyDrawerState();
// }
//
// class _MyDrawerState extends State<MyDrawer> {
//   late ThemeNotifier themeNotifier;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   final GlobalKey<FormState> _changePwdKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _changeUserDetailsKey = GlobalKey<FormState>();
//   bool isDark = false;
//   List<String?> languageList = [];
//   List<String> langCode = ["en", "hi", "zh", "es", "ar", "ru", "ja", "de"];
//   final confirmpassController = TextEditingController();
//   final newpassController = TextEditingController();
//   final passwordController = TextEditingController();
//   String? currentPwd, newPwd, confirmPwd;
//   FocusNode confirmPwdFocus = FocusNode();
//
//   Availability _availability = Availability.loading;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       try {
//         setState(() {
//           // This plugin cannot be tested on Android by installing your app
//           // locally. See https://github.com/britannio/in_app_review#testing for
//           // more information.
//           _availability =  !Platform.isAndroid
//               ? Availability.available
//               : Availability.unavailable;
//         });
//       } catch (e) {
//         setState(() => _availability = Availability.unavailable);
//       }
//     });
//     //getUserDetails();
//     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
//     // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     //   statusBarColor: Colors.transparent,
//     //   statusBarIconBrightness: Brightness.light,
//     // ));
//     new Future.delayed(Duration.zero, () {
//       languageList = [
//         getTranslated(context, 'ENGLISH_LAN'),
//         getTranslated(context, 'HINDI_LAN'),
//         // getTranslated(context, 'CHINESE_LAN'),
//         // getTranslated(context, 'SPANISH_LAN'),
//         //
//         // getTranslated(context, 'ARABIC_LAN'),
//         // getTranslated(context, 'RUSSIAN_LAN'),
//         // getTranslated(context, 'JAPANISE_LAN'),
//         // getTranslated(context, 'GERMAN_LAN')
//       ];
//
//       themeList = [
//         getTranslated(context, 'SYSTEM_DEFAULT'),
//         getTranslated(context, 'LIGHT_THEME'),
//         getTranslated(context, 'DARK_THEME')
//       ];
//
//       _getSaved();
//     });
//   }
//
//   _getSaved() async {
//     SettingProvider settingsProvider =
//     Provider.of<SettingProvider>(this.context, listen: false);
//
//     //String get = await settingsProvider.getPrefrence(APP_THEME) ?? '';
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? get = prefs.getString(APP_THEME);
//
//     curTheme = themeList.indexOf(get == '' || get == DEFAULT_SYSTEM
//         ? getTranslated(context, 'SYSTEM_DEFAULT')
//         : get == LIGHT
//         ? getTranslated(context, 'LIGHT_THEME')
//         : getTranslated(context, 'DARK_THEME'));
//
//     String getlng = await settingsProvider.getPrefrence(LAGUAGE_CODE) ?? '';
//
//     selectLan = langCode.indexOf(getlng == '' ? "en" : getlng);
//
//     if (mounted) setState(() {});
//   }
//
//
//   Widget getUserImage(String profileImage) {
//     var user = Provider.of<UserProvider>(context, listen: false);
//     return Stack(
//       children: <Widget>[
//         Container(
//           margin: EdgeInsetsDirectional.only(end: 20),
//           height: 45,
//           width: 45,
//           decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               border: Border.all(
//                   width: 1.0, color: Theme.of(context).colorScheme.white)),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(100.0),
//             child: Consumer<UserProvider>(builder: (context, userProvider, _) {
//               return CUR_USERID != null
//                   ? FutureBuilder(
//                   future: userDetails(),
//                   builder: (BuildContext context, AsyncSnapshot snapshot) {
//                     if (snapshot.hasData) {
//                       UserDetails? data = snapshot.data;
//                       // user.setEmail("${data!.date![0].email}");
//                       // user.setName("${data.date![0].username}");
//                       print("Profile Data ========================> ${data!.date![0].proPic}");
//                       return data.date![0].proPic != null
//                           ? Image.network("$imageUrl${data.date![0].proPic}")
//                           : Image.asset("assets/images/placeholder.png");
//                     } else if (snapshot.hasError) {
//                       return Icon(Icons.error_outline);
//                     } else {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                   })
//                   : imagePlaceHolder(62, context);
//             }),
//           ),
//         ),
//         /*CircleAvatar(
//       radius: 40,
//       backgroundColor: colors.primary,
//       child: profileImage != ""
//           ? ClipRRect(
//               borderRadius: BorderRadius.circular(40),
//               child: FadeInImage(
//                 fadeInDuration: Duration(milliseconds: 150),
//                 image: NetworkImage(profileImage),
//                 height: 100.0,
//                 width: 100.0,
//                 fit: BoxFit.cover,
//                 placeholder: placeHolder(100),
//                 imageErrorBuilder: (context, error, stackTrace) =>
//                     erroWidget(100),
//               ))
//           : Icon(
//               Icons.account_circle,
//               size: 80,
//               color: Theme.of(context).colorScheme.white,
//             ),
//     ),*/
//         // if (CUR_USERID != null)
//         //   Positioned.directional(
//         //       textDirection: Directionality.of(context),
//         //       end: 20,
//         //       bottom: 5,
//         //       child: Container(
//         //         height: 20,
//         //         width: 20,
//         //         child: InkWell(
//         //           child: Icon(
//         //             Icons.edit,
//         //             color: Theme.of(context).colorScheme.white,
//         //             size: 10,
//         //           ),
//         //           onTap: () {
//         //             if (mounted) {
//         //               onBtnSelected!();
//         //             }
//         //           },
//         //         ),
//         //         decoration: BoxDecoration(
//         //             color: colors.primary,
//         //             borderRadius: const BorderRadius.all(
//         //               Radius.circular(20),
//         //             ),
//         //             border: Border.all(color: colors.primary)),
//         //       )),
//       ],
//     );
//   }
//
//   // void openChangeUserDetailsBottomSheet() {
//   //   showModalBottomSheet(
//   //     shape: const RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.only(
//   //             topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))),
//   //     isScrollControlled: true,
//   //     context: context,
//   //     builder: (context) {
//   //       return Wrap(
//   //         children: [
//   //           Padding(
//   //             padding: EdgeInsets.only(
//   //                 bottom: MediaQuery.of(context).viewInsets.bottom),
//   //             child: Form(
//   //               key: _changeUserDetailsKey,
//   //               child: Column(
//   //                 mainAxisSize: MainAxisSize.max,
//   //                 children: [
//   //                   // bottomSheetHandle(),
//   //                   // bottomsheetLabel("EDIT_PROFILE_LBL"),
//   //                   Selector<UserProvider, String>(
//   //                       selector: (_, provider) => provider.profilePic,
//   //                       builder: (context, profileImage, child) {
//   //                         return Padding(
//   //                           padding: const EdgeInsets.symmetric(vertical: 10.0),
//   //                           child: getUserImage(profileImage, _imgFromGallery),
//   //                         );
//   //                       }),
//   //                   Selector<UserProvider, String>(
//   //                       selector: (_, provider) => provider.curUserName,
//   //                       builder: (context, userName, child) {
//   //                         return setNameField(userName);
//   //                       }),
//   //                   Selector<UserProvider, String>(
//   //                       selector: (_, provider) => provider.email,
//   //                       builder: (context, userEmail, child) {
//   //                         return setEmailField(userEmail);
//   //                       }),
//   //                   Container(
//   //                     child: InkWell(
//   //                         onTap: () => getImage(ImgSource.Both),
//   //                         child: bankPass != null
//   //                             ? SizedBox(
//   //                           height: 30,
//   //                           width:
//   //                           MediaQuery.of(context).size.width * 0.9,
//   //                           child: Image.file(
//   //                             File(bankPass.path),
//   //                             fit: BoxFit.cover,
//   //                             height: 30,
//   //                             width:
//   //                             MediaQuery.of(context).size.width * 0.9,
//   //                           ),
//   //                         )
//   //                             : Container(
//   //                             height: 50,
//   //                             width:
//   //                             MediaQuery.of(context).size.width * 0.6,
//   //                             color: colors.primary,
//   //                             alignment: Alignment.center,
//   //                             child: Text("Edit Bank passBook"))),
//   //                   ),
//   //                   saveButton(getTranslated(context, "SAVE_LBL")!, () {
//   //                     validateAndSave(_changeUserDetailsKey);
//   //                   }),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//   _getHeader() {
//     return Container(
//       color: colors.primary,
//       padding: EdgeInsetsDirectional.only(
//         start: 10.0,
//         top: 10,bottom: 10
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Selector<UserProvider, String>(
//               selector: (_, provider) => provider.profilePic,
//               builder: (context, profileImage, child) {
//                 return getUserImage(
//                     profileImage);
//               }),
//           Expanded(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Selector<UserProvider, String>(
//                     selector: (_, provider) => provider.curUserName,
//                     builder: (context, userName, child) {
//                       nameController = TextEditingController(text: userName);
//                       return Padding(
//                         padding: EdgeInsets.only(top: 15),
//                         child: Text(
//                           userName == ""
//                               ? getTranslated(context, 'GUEST')!
//                               : userName,
//                           style: Theme.of(context)
//                               .textTheme
//                               .subtitle1!
//                               .copyWith(
//                             color: Theme.of(context).colorScheme.white,
//                           ),
//                         ),
//                       );
//                     }),
//                 Selector<UserProvider, String>(
//                     selector: (_, provider) => provider.mob,
//                     builder: (context, userMobile, child) {
//                       return userMobile != ""
//                           ? Text(
//                         userMobile,
//                         style: Theme.of(context)
//                             .textTheme
//                             .subtitle2!
//                             .copyWith(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .white,
//                             fontWeight: FontWeight.normal),
//                       )
//                           : Container(
//                         height: 0,
//                       );
//                     }),
//                 Selector<UserProvider, String>(
//                     selector: (_, provider) => provider.email,
//                     builder: (context, userEmail, child) {
//                       emailController =
//                           TextEditingController(text: userEmail);
//                       return userEmail != ""
//                           ? Text(
//                         userEmail,
//                         style: Theme.of(context)
//                             .textTheme
//                             .subtitle2!
//                             .copyWith(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .white,
//                             fontWeight: FontWeight.normal),
//                       )
//                           : Container(
//                         height: 0,
//                       );
//                     }),
//
//                 /* Consumer<UserProvider>(builder: (context, userProvider, _) {
//                   print("mobb**${userProvider.profilePic}");
//                   return (userProvider.mob != "")
//                       ? Text(
//                           userProvider.mob,
//                           style: Theme.of(context)
//                               .textTheme
//                               .subtitle2!
//                               .copyWith(color: Theme.of(context).colorScheme.fontColor),
//                         )
//                       : Container(
//                           height: 0,
//                         );
//                 }),*/
//                 Consumer<UserProvider>(builder: (context, userProvider, _) {
//                   return userProvider.curUserName == ""
//                       ? Padding(
//                       padding: const EdgeInsetsDirectional.only(top: 7),
//                       child: InkWell(
//                         child: Text(
//                             getTranslated(context, 'LOGIN_REGISTER_LBL')!,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .caption!
//                                 .copyWith(
//                               color: colors.primary,
//                               decoration: TextDecoration.underline,
//                             )),
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => Login(),
//                               ));
//                         },
//                       ))
//                       : Container();
//                 }),
//               ],
//             ),
//           ),
//           CUR_USERID != null ? IconButton(
//               onPressed: () async {
//                 var data = await Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => EditProfile()));
//                 if (data == true) {
//                   setState(() {
//                   });
//                 }
//               },
//               icon: Icon(Icons.edit,color: Colors.white,)
//           ) : Container()
//         ],
//       ),
//     );
//   }
//   _launchURLBrowser() async {
//     const url = 'https://play.google.com/store/apps/details?id=com.ZuqZuq';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//   int? selectLan, curTheme;
//
//   Widget bottomSheetHandle() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//             color: Theme.of(context).colorScheme.lightBlack),
//         height: 5,
//         width: MediaQuery.of(context).size.width * 0.3,
//       ),
//     );
//   }
//   Widget getHeading(String title) {
//     return Text(
//       getTranslated(context, title)!,
//       style: Theme.of(context).textTheme.headline6!.copyWith(
//           fontWeight: FontWeight.bold,
//           color: Theme.of(context).colorScheme.fontColor),
//     );
//   }
//   Widget bottomsheetLabel(String labelName) => Padding(
//     padding: const EdgeInsets.only(top: 30.0, bottom: 20),
//     child: getHeading(labelName),
//   );
//   logOutDailog() async {
//     await dialogAnimate(context,
//         StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
//           return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setStater) {
//                 return AlertDialog(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                   content: Text(
//                     getTranslated(context, 'LOGOUTTXT')!,
//                     style: Theme.of(this.context)
//                         .textTheme
//                         .subtitle1!
//                         .copyWith(color: Theme.of(context).colorScheme.fontColor),
//                   ),
//                   actions: <Widget>[
//                     new TextButton(
//                         child: Text(
//                           getTranslated(context, 'NO')!,
//                           style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
//                               color: Theme.of(context).colorScheme.lightBlack,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         onPressed: () {
//                           Navigator.of(context).pop(false);
//                         }),
//                     new TextButton(
//                         child: Text(
//                           getTranslated(context, 'YES')!,
//                           style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
//                               color: Theme.of(context).colorScheme.fontColor,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         onPressed: () {
//                           SettingProvider settingProvider =
//                           Provider.of<SettingProvider>(context, listen: false);
//                           settingProvider.clearUserSession(context);
//                           //favList.clear();
//                           Navigator.of(context).pushNamedAndRemoveUntil(
//                               '/home', (Route<dynamic> route) => false);
//                         })
//                   ],
//                 );
//               });
//         }));
//   }
//   List<String?> themeList = [];
//   Widget setCurrentPasswordField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.white,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//           child: TextFormField(
//             controller: passwordController,
//             obscureText: true,
//             obscuringCharacter: "*",
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.fontColor,
//             ),
//             decoration: InputDecoration(
//                 label: Text(getTranslated(context, "CUR_PASS_LBL")!),
//                 fillColor: Theme.of(context).colorScheme.white,
//                 border: InputBorder.none),
//             onSaved: (String? value) {
//               currentPwd = value;
//             },
//             validator: (val) => validatePass(
//                 val!,
//                 getTranslated(context, 'PWD_REQUIRED'),
//                 getTranslated(context, 'PWD_LENGTH')),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget setForgotPwdLable() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: InkWell(
//           child: Text(getTranslated(context, "FORGOT_PASSWORD_LBL")!),
//           onTap: () {
//             Navigator.of(context)
//                 .push(MaterialPageRoute(builder: (context) => SendOtp()));
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget newPwdField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.white,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//           child: TextFormField(
//             controller: newpassController,
//             obscureText: true,
//             obscuringCharacter: "*",
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.fontColor,
//             ),
//             decoration: InputDecoration(
//                 label: Text(getTranslated(context, "NEW_PASS_LBL")!),
//                 fillColor: Theme.of(context).colorScheme.white,
//                 border: InputBorder.none),
//             onSaved: (String? value) {
//               newPwd = value;
//             },
//             validator: (val) => validatePass(
//                 val!,
//                 getTranslated(context, 'PWD_REQUIRED'),
//                 getTranslated(context, 'PWD_LENGTH')),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget confirmPwdField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.white,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//           child: TextFormField(
//             controller: confirmpassController,
//             focusNode: confirmPwdFocus,
//             obscureText: true,
//             obscuringCharacter: "*",
//             style: TextStyle(
//                 color: Theme.of(context).colorScheme.fontColor,
//                 fontWeight: FontWeight.bold),
//             decoration: InputDecoration(
//                 label: Text(getTranslated(context, "CONFIRMPASSHINT_LBL")!),
//                 fillColor: Theme.of(context).colorScheme.white,
//                 border: InputBorder.none),
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return getTranslated(context, 'CON_PASS_REQUIRED_MSG');
//               }
//               if (value != newPwd) {
//                 confirmpassController.text = "";
//                 confirmPwdFocus.requestFocus();
//                 return getTranslated(context, 'CON_PASS_NOT_MATCH_MSG');
//               } else {
//                 return null;
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//   void openChangeThemeBottomSheet() {
//     themeList = [
//       getTranslated(context, 'SYSTEM_DEFAULT'),
//       getTranslated(context, 'LIGHT_THEME'),
//       getTranslated(context, 'DARK_THEME')
//     ];
//
//     showModalBottomSheet(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(40.0),
//                 topRight: Radius.circular(40.0))),
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Wrap(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom),
//                 child: Form(
//                   key: _changePwdKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       bottomSheetHandle(),
//                       bottomsheetLabel("CHOOSE_THEME_LBL"),
//                       SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: themeListView(context),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   }
//   _updateState(int position, BuildContext ctx) {
//     curTheme = position;
//
//     onThemeChanged(themeList[position]!, ctx);
//   }
//   void onThemeChanged(
//       String value,
//       BuildContext ctx,
//       ) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (value == getTranslated(ctx, 'SYSTEM_DEFAULT')) {
//       themeNotifier.setThemeMode(ThemeMode.system);
//       prefs.setString(APP_THEME, DEFAULT_SYSTEM);
//
//       var brightness = SchedulerBinding.instance!.window.platformBrightness;
//       if (mounted)
//         setState(() {
//           isDark = brightness == Brightness.dark;
//           if (isDark)
//             SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//           else
//             SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//         });
//     } else if (value == getTranslated(ctx, 'LIGHT_THEME')) {
//       themeNotifier.setThemeMode(ThemeMode.light);
//       prefs.setString(APP_THEME, LIGHT);
//       if (mounted)
//         setState(() {
//           isDark = false;
//           SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//         });
//     } else if (value == getTranslated(ctx, 'DARK_THEME')) {
//       themeNotifier.setThemeMode(ThemeMode.dark);
//       prefs.setString(APP_THEME, DARK);
//       if (mounted)
//         setState(() {
//           isDark = true;
//           SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//         });
//     }
//     ISDARK = isDark.toString();
//
//     //Provider.of<SettingProvider>(context,listen: false).setPrefrence(APP_THEME, value);
//   }
//   List<Widget> themeListView(BuildContext ctx) {
//     return themeList
//         .asMap()
//         .map(
//           (index, element) => MapEntry(
//           index,
//           InkWell(
//             onTap: () {
//               _updateState(index, ctx);
//             },
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         height: 25.0,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: curTheme == index
//                               ? colors.grad2Color
//                               : Theme.of(context).colorScheme.white,
//                           border: Border.all(color: colors.grad2Color),
//                         ),
//                         child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: curTheme == index
//                                 ? Icon(
//                               Icons.check,
//                               size: 17.0,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .fontColor,
//                             )
//                                 : Icon(
//                               Icons.check_box_outline_blank,
//                               size: 15.0,
//                               color:
//                               Theme.of(context).colorScheme.white,
//                             )),
//                       ),
//                       Padding(
//                           padding: EdgeInsetsDirectional.only(
//                             start: 15.0,
//                           ),
//                           child: Text(
//                             themeList[index]!,
//                             style: Theme.of(ctx)
//                                 .textTheme
//                                 .subtitle1!
//                                 .copyWith(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .lightBlack),
//                           ))
//                     ],
//                   ),
//                   // index == themeList.length - 1
//                   //     ? Container(
//                   //         margin: EdgeInsetsDirectional.only(
//                   //           bottom: 10,
//                   //         ),
//                   //       )
//                   //     : Divider(
//                   //         color: Theme.of(context).colorScheme.lightBlack,
//                   //       )
//                 ],
//               ),
//             ),
//           )),
//     )
//         .values
//         .toList();
//   }
//
//   Widget saveButton(String title, VoidCallback? onBtnSelected) {
//     return Row(
//       children: [
//         Expanded(
//           child: Padding(
//             padding:
//             const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
//             child: MaterialButton(
//               height: 45.0,
//               textColor: Theme.of(context).colorScheme.white,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0)),
//               onPressed: onBtnSelected,
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.fontColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               color: colors.primary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _changeLan(String language, BuildContext ctx) async {
//     Locale _locale = await setLocale(language);
//
//     MyApp.setLocale(ctx, _locale);
//   }
//
//   List<Widget> getLngList(BuildContext ctx, StateSetter setModalState) {
//     return languageList
//         .asMap()
//         .map(
//           (index, element) => MapEntry(
//           index,
//           InkWell(
//             onTap: () {
//               if (mounted)
//                 setState(() {
//                   selectLan = index;
//                   _changeLan(langCode[index], ctx);
//                 });
//               setModalState(() {});
//             },
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         height: 25.0,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: selectLan == index
//                                 ? colors.grad2Color
//                                 : Theme.of(context).colorScheme.white,
//                             border: Border.all(color: colors.grad2Color)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: selectLan == index
//                               ? Icon(
//                             Icons.check,
//                             size: 17.0,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .fontColor,
//                           )
//                               : Icon(
//                             Icons.check_box_outline_blank,
//                             size: 15.0,
//                             color:
//                             Theme.of(context).colorScheme.white,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                           padding: EdgeInsetsDirectional.only(
//                             start: 15.0,
//                           ),
//                           child: Text(
//                             languageList[index]!,
//                             style: Theme.of(this.context)
//                                 .textTheme
//                                 .subtitle1!
//                                 .copyWith(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .lightBlack),
//                           ))
//                     ],
//                   ),
//                   // index == languageList.length - 1
//                   //     ? Container(
//                   //         margin: EdgeInsetsDirectional.only(
//                   //           bottom: 10,
//                   //         ),
//                   //       )
//                   //     : Divider(
//                   //         color: Theme.of(context).colorScheme.lightBlack,
//                   //       ),
//                 ],
//               ),
//             ),
//           )),
//     )
//         .values
//         .toList();
//   }
//
//   Future<void> setUpdateUser(String userID,
//       [oldPwd, newPwd, username, userEmail]) async {
//     var apiBaseHelper = ApiBaseHelper();
//     var data = {USER_ID: userID};
//     if ((oldPwd != "") && (newPwd != "")) {
//       data[OLDPASS] = oldPwd;
//       data[NEWPASS] = newPwd;
//     } else if ((username != "") && (userEmail != "")) {
//       data[USERNAME] = username;
//       data[EMAIL] = userEmail;
//     }
//     print(data);
//     print("==========");
//     print(getUpdateUserApi);
//     final result = await apiBaseHelper.postAPICall(getUpdateUserApi, data);
//
//     bool error = result["error"];
//     String? msg = result["message"];
//
//     Navigator.of(context).pop();
//     if (!error) {
//       var settingProvider =
//       Provider.of<SettingProvider>(context, listen: false);
//       var userProvider = Provider.of<UserProvider>(context, listen: false);
//
//       if ((username != "") && (userEmail != "")) {
//         settingProvider.setPrefrence(USERNAME, username);
//         userProvider.setName(username);
//         userProvider.setBankPic(result["data"][0]["bank_pass"]);
//         settingProvider.setPrefrence(EMAIL, userEmail);
//         userProvider.setEmail(userEmail);
//       }
//
//       setSnackbar(getTranslated(context, 'USER_UPDATE_MSG')!, context);
//     } else {
//       setSnackbar(msg!,context);
//     }
//   }
//
//   Future<bool> validateAndSave(GlobalKey<FormState> key) async {
//     final form = key.currentState!;
//     form.save();
//     if (form.validate()) {
//       if (key == _changePwdKey) {
//         await setUpdateUser(
//           CUR_USERID!,
//           passwordController.text,
//           newpassController.text,
//           "",
//           "",
//         );
//         passwordController.clear();
//         newpassController.clear();
//         passwordController.clear();
//         confirmpassController.clear();
//       } else if (key == _changeUserDetailsKey) {
//         setUpdateUser(
//             CUR_USERID!, "", "", nameController.text, emailController.text);
//       }
//       return true;
//     }
//     return false;
//   }
//   void openChangePasswordBottomSheet() {
//     showModalBottomSheet(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(40.0),
//                 topRight: Radius.circular(40.0))),
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Wrap(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom),
//                 child: Form(
//                   key: _changePwdKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       bottomSheetHandle(),
//                       bottomsheetLabel("CHANGE_PASS_LBL"),
//                       setCurrentPasswordField(),
//                       setForgotPwdLable(),
//                       newPwdField(),
//                       confirmPwdField(),
//                       saveButton(getTranslated(context, "SAVE_LBL")!, () {
//                         validateAndSave(_changePwdKey);
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   }
//
//   void openChangeLanguageBottomSheet() {
//     showModalBottomSheet(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(40.0),
//                 topRight: Radius.circular(40.0))),
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Wrap(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom),
//                 child: Form(
//                   key: _changePwdKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       bottomSheetHandle(),
//                       bottomsheetLabel("CHOOSE_LANGUAGE_LBL"),
//                       StatefulBuilder(
//                         builder:
//                             (BuildContext context, StateSetter setModalState) {
//                           return SingleChildScrollView(
//                             child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: getLngList(context, setModalState)),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   }
//
//
//   _getDrawerItem(String title, String img) {
//     return Card(
//       elevation: 0,
//       child: ListTile(
//         trailing: Icon(
//           Icons.navigate_next,
//           color: colors.primary,
//         ),
//         leading: SvgPicture.asset(
//           img,
//           height: 25,
//           width: 25,
//           color: colors.primary,
//         ),
//         dense: true,
//         title: Text(
//           title,
//           style: TextStyle(
//               color: Theme.of(context).colorScheme.lightBlack, fontSize: 15),
//         ),
//         onTap: () async{
//           if (title == getTranslated(context, 'MY_ORDERS_LBL')) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MyOrder(),
//               ),
//             );
//
//             //sendAndRetrieveMessage();
//           } else if (title == getTranslated(context, 'MYTRANSACTION')) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TransactionHistory(),
//                 ));
//           } else if (title == getTranslated(context, 'MYWALLET')) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MyWallet(),
//                 ));
//           } else if (title == getTranslated(context, 'SETTING')) {
//             CUR_USERID == null
//                 ? Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Login(),
//                 ))
//                 : Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Setting(),
//                 ));
//           } else if (title == getTranslated(context, 'MANAGE_ADD_LBL')) {
//             CUR_USERID == null
//                 ? Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Login(),
//                 ))
//                 : Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ManageAddress(
//                     home: true,
//                   ),
//                 ));
//           } else if (title == getTranslated(context, 'REFEREARN')) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ReferEarn(),
//                 ));
//           } else if (title == getTranslated(context, 'CONTACT_LBL')) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PrivacyPolicy(
//                     title: getTranslated(context, 'CONTACT_LBL'),
//                   ),
//                 ));
//           } else if (title == getTranslated(context, 'CUSTOMER_SUPPORT')) {
//             CUR_USERID == null
//                 ? Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Login(),
//                 ))
//                 : Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => CustomerSupport()));
//           } else if (title == getTranslated(context, 'TERM')) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PrivacyPolicy(
//                     title: getTranslated(context, 'TERM'),
//                   ),
//                 ));
//           } else if (title == getTranslated(context, 'PRIVACY')) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PrivacyPolicy(
//                     title: getTranslated(context, 'PRIVACY'),
//                   ),
//                 ));
//           } else if (title == getTranslated(context, 'RATE_US')) {
//             _launchURLBrowser();
//
//             // _openStoreListing();
//           } else if (title == getTranslated(context, 'SHARE_APP')) {
//             var str =
//                 "$appName\n\n${getTranslated(context, 'APPFIND')}$androidLink$packageName\n\n ${getTranslated(context, 'IOSLBL')}\n$iosLink";
//
//             Share.share(str);
//           } else if (title == getTranslated(context, 'ABOUT_LBL')) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PrivacyPolicy(
//                     title: getTranslated(context, 'ABOUT_LBL'),
//                   ),
//                 ));
//           } else if (title == getTranslated(context, 'FAQS')) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Faqs(
//                     title: getTranslated(context, 'FAQS'),
//                   ),
//                 ));
//           // } else if (title == getTranslated(context, 'CHANGE_THEME_LBL')) {
//           //   openChangeThemeBottomSheet();
//           } else if (title == getTranslated(context, 'LOGOUT')) {
//             logOutDailog();
//           } else if (title == getTranslated(context, 'CHANGE_PASS_LBL')) {
//             openChangePasswordBottomSheet();
//           } else if (title == getTranslated(context, 'CHANGE_LANGUAGE_LBL')) {
//             openChangeLanguageBottomSheet();
//           }
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     themeNotifier = Provider.of<ThemeNotifier>(context);
//     return Drawer(
//       child: Container(
//         color: Colors.white,
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//               Container(
//                 color: colors.primary,
//                 child: Column(
//                   children: [
//                     _getHeader(),
//                     Divider(color: Colors.white,thickness: 1,height: 0,),
//                     IntrinsicHeight(
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                        children: [
//                          Container(
//                            height:45,
//                            child: CUR_USERID == null ? InkWell(
//                               onTap: (){
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
//                               },
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                children: [
//                                  Icon(Icons.login_outlined,color: Colors.white,),
//                                  SizedBox(width: 5,),
//                                  Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
//                                ],
//                              ),
//                            ):
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                              children: [
//                                Icon(Icons.person,color: Colors.white,),
//                                SizedBox(width: 5,),
//                                Text("My Account",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
//                              ],
//                            ),
//                          ),
//                          VerticalDivider(
//                            color: Colors.white,
//                            thickness: 2,
//                          ),
//                          InkWell(
//                            onTap: (){
//                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrder()));
//                            },
//                            child: Container(  height:45,
//                              child: Row(
//                                children: [
//                                  Icon(Icons.fire_truck,color: Colors.white,),
//                                  SizedBox(width: 5,),
//                                  Text("Track Order",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
//                                ],
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                   ],
//                 ),
//               ),
//             // InkWell(
//             //   onTap: (){
//             //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
//             //   },
//             //   child: ListTile(
//             //     leading: Icon(CupertinoIcons.home, color: Colors.black,),
//             //     title: Text('Home', style: TextStyle(color: Colors.black),textScaleFactor: 1.2,),
//             //   ),
//             // ),
//             //
//             // ListTile(
//             //   leading: Icon(Icons.logout, color: Colors.black,),
//             //   title: Text('Logout', style: TextStyle(color: Colors.black),textScaleFactor: 1.2,),
//             // ),
//             CUR_USERID == "" || CUR_USERID == null
//                 ? Container()
//                 : _getDrawerItem(getTranslated(context, 'MY_ORDERS_LBL')!,
//                 'assets/images/pro_myorder.svg'),
//             // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
//             CUR_USERID == "" || CUR_USERID == null
//                 ? Container()
//                 : _getDrawerItem(getTranslated(context, 'MANAGE_ADD_LBL')!,
//                 'assets/images/pro_address.svg'),
//             //CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
//             CUR_USERID == "" || CUR_USERID == null
//                 ? Container()
//                 : _getDrawerItem(getTranslated(context, 'MYWALLET')!,
//                 'assets/images/pro_wh.svg'),
//             // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
//             CUR_USERID == "" || CUR_USERID == null
//                 ? Container()
//                 : _getDrawerItem(getTranslated(context, 'MYTRANSACTION')!,
//                 'assets/images/pro_th.svg'),
//             // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
//             // _getDrawerItem(getTranslated(context, 'CHANGE_THEME_LBL')!,
//             //     'assets/images/pro_theme.svg'),
//             // _getDivider(),
//             _getDrawerItem(getTranslated(context, 'CHANGE_LANGUAGE_LBL')!,
//                 'assets/images/pro_language.svg'),
//             //  CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
//             CUR_USERID == "" || CUR_USERID == null
//                 ? Container()
//                 : _getDrawerItem(getTranslated(context, 'CHANGE_PASS_LBL')!,
//                 'assets/images/pro_pass.svg'),
//             // _getDivider(),
//             CUR_USERID == "" || CUR_USERID == null || !refer
//                 ? Container()
//                 : _getDrawerItem(getTranslated(context, 'REFEREARN')!,
//                 'assets/images/pro_referral.svg'),
//             // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
//             _getDrawerItem(getTranslated(context, 'CUSTOMER_SUPPORT')!,
//                 'assets/images/pro_customersupport.svg'),
//             // _getDivider(),
//             _getDrawerItem(getTranslated(context, 'ABOUT_LBL')!,
//                 'assets/images/pro_aboutus.svg'),
//             // _getDivider(),
//             _getDrawerItem(getTranslated(context, 'CONTACT_LBL')!,
//                 'assets/images/pro_aboutus.svg'),
//             // _getDivider(),
//             _getDrawerItem(
//                 getTranslated(context, 'FAQS')!, 'assets/images/pro_faq.svg'),
//             // _getDivider(),
//             _getDrawerItem(
//                 getTranslated(context, 'PRIVACY')!, 'assets/images/pro_pp.svg'),
//             // _getDivider(),
//             _getDrawerItem(
//                 getTranslated(context, 'TERM')!, 'assets/images/pro_tc.svg'),
//             // _getDivider(),
//             _getDrawerItem(
//                 getTranslated(context, 'RATE_US')!, 'assets/images/pro_rateus.svg'),
//             // _getDivider(),
//             _getDrawerItem(getTranslated(context, 'SHARE_APP')!,
//                 'assets/images/pro_share.svg'),
//             // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
//             CUR_USERID == "" || CUR_USERID == null
//                 ? Container()
//                 : _getDrawerItem(getTranslated(context, 'LOGOUT')!,
//                 'assets/images/pro_logout.svg'),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
import 'package:eshop_multivendor/Model/UserDetails.dart';

import 'package:eshop_multivendor/Screen/MyOrder.dart';
import 'package:eshop_multivendor/Screen/MyProfile.dart';
import 'package:eshop_multivendor/Screen/My_Wallet.dart';
import 'package:eshop_multivendor/Screen/SendOtp.dart';
import 'package:eshop_multivendor/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Provider/SettingProvider.dart';
import '../Provider/Theme.dart';
import '../Provider/UserProvider.dart';
import '../Screen/Customer_Support.dart';
import '../Screen/Edit_Profile.dart';
import '../Screen/Faqs.dart';
import '../Screen/Login.dart';
import '../Screen/Manage_Address.dart';
import '../Screen/MyTransactions.dart';
import '../Screen/Privacy_Policy.dart';
import '../Screen/ReferEarn.dart';
import '../Screen/Setting.dart';
import '../Screen/corporate_gifting.dart';
import '../Screen/franchise.dart';
import 'Color.dart';
import 'Constant.dart';
import 'Public Api/api.dart';
import 'Session.dart';
import 'String.dart';

class MyDrawer extends StatefulWidget {

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late ThemeNotifier themeNotifier;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _changePwdKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _changeUserDetailsKey = GlobalKey<FormState>();
  bool isDark = false;
  List<String?> languageList = [];
  List<String> langCode = ["en", "hi", "zh", "es", "ar", "ru", "ja", "de"];
  final confirmpassController = TextEditingController();
  final newpassController = TextEditingController();
  final passwordController = TextEditingController();
  String? currentPwd, newPwd, confirmPwd;
  FocusNode confirmPwdFocus = FocusNode();

  Availability _availability = Availability.loading;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          // This plugin cannot be tested on Android by installing your app
          // locally. See https://github.com/britannio/in_app_review#testing for
          // more information.
          _availability =  !Platform.isAndroid
              ? Availability.available
              : Availability.unavailable;
        });
      } catch (e) {
        setState(() => _availability = Availability.unavailable);
      }
    });
    //getUserDetails();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.light,
    // ));
    new Future.delayed(Duration.zero, () {
      languageList = [
        getTranslated(context, 'ENGLISH_LAN'),
        getTranslated(context, 'HINDI_LAN'),
        // getTranslated(context, 'CHINESE_LAN'),
        // getTranslated(context, 'SPANISH_LAN'),
        //
        // getTranslated(context, 'ARABIC_LAN'),
        // getTranslated(context, 'RUSSIAN_LAN'),
        // getTranslated(context, 'JAPANISE_LAN'),
        // getTranslated(context, 'GERMAN_LAN')
      ];

      themeList = [
        getTranslated(context, 'SYSTEM_DEFAULT'),
        getTranslated(context, 'LIGHT_THEME'),
        getTranslated(context, 'DARK_THEME')
      ];

      _getSaved();
    });
  }

  _getSaved() async {
    SettingProvider settingsProvider =
    Provider.of<SettingProvider>(this.context, listen: false);

    //String get = await settingsProvider.getPrefrence(APP_THEME) ?? '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? get = prefs.getString(APP_THEME);

    curTheme = themeList.indexOf(get == '' || get == DEFAULT_SYSTEM
        ? getTranslated(context, 'SYSTEM_DEFAULT')
        : get == LIGHT
        ? getTranslated(context, 'LIGHT_THEME')
        : getTranslated(context, 'DARK_THEME'));

    String getlng = await settingsProvider.getPrefrence(LAGUAGE_CODE) ?? '';

    selectLan = langCode.indexOf(getlng == '' ? "en" : getlng);

    if (mounted) setState(() {});
  }


  Widget getUserImage(String profileImage) {
    var user = Provider.of<UserProvider>(context, listen: false);
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsetsDirectional.only(end: 20),
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                  width: 1.0, color: Theme.of(context).colorScheme.white)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Consumer<UserProvider>(builder: (context, userProvider, _) {
              return CUR_USERID != null
                  ? FutureBuilder(
                  future: userDetails(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      UserDetails? data = snapshot.data;
                      // user.setEmail("${data!.date![0].email}");
                      // user.setName("${data.date![0].username}");
                      print("Profile Data ========================> ${data!.date![0].proPic}");
                      return data.date![0].proPic != null
                          ? Image.network("$imageUrl${data.date![0].proPic}")
                          : Image.asset("assets/images/placeholder.png");
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error_outline);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })
                  : imagePlaceHolder(62, context);
            }),
          ),
        ),
        /*CircleAvatar(
      radius: 40,
      backgroundColor: colors.primary,
      child: profileImage != ""
          ? ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: FadeInImage(
                fadeInDuration: Duration(milliseconds: 150),
                image: NetworkImage(profileImage),
                height: 100.0,
                width: 100.0,
                fit: BoxFit.cover,
                placeholder: placeHolder(100),
                imageErrorBuilder: (context, error, stackTrace) =>
                    erroWidget(100),
              ))
          : Icon(
              Icons.account_circle,
              size: 80,
              color: Theme.of(context).colorScheme.white,
            ),
    ),*/
        // if (CUR_USERID != null)
        //   Positioned.directional(
        //       textDirection: Directionality.of(context),
        //       end: 20,
        //       bottom: 5,
        //       child: Container(
        //         height: 20,
        //         width: 20,
        //         child: InkWell(
        //           child: Icon(
        //             Icons.edit,
        //             color: Theme.of(context).colorScheme.white,
        //             size: 10,
        //           ),
        //           onTap: () {
        //             if (mounted) {
        //               onBtnSelected!();
        //             }
        //           },
        //         ),
        //         decoration: BoxDecoration(
        //             color: colors.primary,
        //             borderRadius: const BorderRadius.all(
        //               Radius.circular(20),
        //             ),
        //             border: Border.all(color: colors.primary)),
        //       )),
      ],
    );
  }

  // void openChangeUserDetailsBottomSheet() {
  //   showModalBottomSheet(
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))),
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (context) {
  //       return Wrap(
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(
  //                 bottom: MediaQuery.of(context).viewInsets.bottom),
  //             child: Form(
  //               key: _changeUserDetailsKey,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.max,
  //                 children: [
  //                   // bottomSheetHandle(),
  //                   // bottomsheetLabel("EDIT_PROFILE_LBL"),
  //                   Selector<UserProvider, String>(
  //                       selector: (_, provider) => provider.profilePic,
  //                       builder: (context, profileImage, child) {
  //                         return Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 10.0),
  //                           child: getUserImage(profileImage, _imgFromGallery),
  //                         );
  //                       }),
  //                   Selector<UserProvider, String>(
  //                       selector: (_, provider) => provider.curUserName,
  //                       builder: (context, userName, child) {
  //                         return setNameField(userName);
  //                       }),
  //                   Selector<UserProvider, String>(
  //                       selector: (_, provider) => provider.email,
  //                       builder: (context, userEmail, child) {
  //                         return setEmailField(userEmail);
  //                       }),
  //                   Container(
  //                     child: InkWell(
  //                         onTap: () => getImage(ImgSource.Both),
  //                         child: bankPass != null
  //                             ? SizedBox(
  //                           height: 30,
  //                           width:
  //                           MediaQuery.of(context).size.width * 0.9,
  //                           child: Image.file(
  //                             File(bankPass.path),
  //                             fit: BoxFit.cover,
  //                             height: 30,
  //                             width:
  //                             MediaQuery.of(context).size.width * 0.9,
  //                           ),
  //                         )
  //                             : Container(
  //                             height: 50,
  //                             width:
  //                             MediaQuery.of(context).size.width * 0.6,
  //                             color: colors.primary,
  //                             alignment: Alignment.center,
  //                             child: Text("Edit Bank passBook"))),
  //                   ),
  //                   saveButton(getTranslated(context, "SAVE_LBL")!, () {
  //                     validateAndSave(_changeUserDetailsKey);
  //                   }),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  _getHeader() {
    return Container(
      color: colors.primary,
      padding: EdgeInsetsDirectional.only(
          start: 10.0,
          top: 10,bottom: 10
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Selector<UserProvider, String>(
              selector: (_, provider) => provider.profilePic,
              builder: (context, profileImage, child) {
                return getUserImage(
                    profileImage);
              }),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Selector<UserProvider, String>(
                    selector: (_, provider) => provider.curUserName,
                    builder: (context, userName, child) {
                      nameController = TextEditingController(text: userName);
                      return Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userName == ""
                              ? getTranslated(context, 'GUEST')!
                              : userName,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                            color: Theme.of(context).colorScheme.white,
                          ),
                        ),
                      );
                    }),
                Selector<UserProvider, String>(
                    selector: (_, provider) => provider.mob,
                    builder: (context, userMobile, child) {
                      return userMobile != ""
                          ? Text(
                        userMobile,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .white,
                            fontWeight: FontWeight.normal),
                      )
                          : Container(
                        height: 0,
                      );
                    }),
                Selector<UserProvider, String>(
                    selector: (_, provider) => provider.email,
                    builder: (context, userEmail, child) {
                      emailController =
                          TextEditingController(text: userEmail);
                      return userEmail != ""
                          ? Text(
                        userEmail,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .white,
                            fontWeight: FontWeight.normal),
                      )
                          : Container(
                        height: 0,
                      );
                    }),

                /* Consumer<UserProvider>(builder: (context, userProvider, _) {
                  print("mobb**${userProvider.profilePic}");
                  return (userProvider.mob != "")
                      ? Text(
                          userProvider.mob,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: Theme.of(context).colorScheme.fontColor),
                        )
                      : Container(
                          height: 0,
                        );
                }),*/
                Consumer<UserProvider>(builder: (context, userProvider, _) {
                  return userProvider.curUserName == ""
                      ? Padding(
                      padding: const EdgeInsetsDirectional.only(top: 7),
                      child: InkWell(
                        child: Text(
                            getTranslated(context, 'LOGIN_REGISTER_LBL')!,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                              color: colors.primary,
                              decoration: TextDecoration.underline,
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ));
                        },
                      ))
                      : Container();
                }),
              ],
            ),
          ),
          CUR_USERID != null ? IconButton(
              onPressed: () async {
                var data = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfile()));
                if (data == true) {
                  setState(() {
                  });
                }
              },
              icon: Icon(Icons.edit,color: Colors.white,)
          ) : Container()
        ],
      ),
    );
  }
  _launchURLBrowser() async {
    const url = 'https://play.google.com/store/apps/details?id=com.giftbash.user&hl=en-IN';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  int? selectLan, curTheme;

  Widget bottomSheetHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).colorScheme.lightBlack),
        height: 5,
        width: MediaQuery.of(context).size.width * 0.3,
      ),
    );
  }
  Widget getHeading(String title) {
    return Text(
      getTranslated(context, title)!,
      style: Theme.of(context).textTheme.headline6!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.fontColor),
    );
  }
  Widget bottomsheetLabel(String labelName) => Padding(
    padding: const EdgeInsets.only(top: 30.0, bottom: 20),
    child: getHeading(labelName),
  );
  logOutDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  content: Text(
                    getTranslated(context, 'LOGOUTTXT')!,
                    style: Theme.of(this.context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Theme.of(context).colorScheme.fontColor),
                  ),
                  actions: <Widget>[
                    new TextButton(
                        child: Text(
                          getTranslated(context, 'NO')!,
                          style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                              color: Theme.of(context).colorScheme.lightBlack,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }),
                    new TextButton(
                        child: Text(
                          getTranslated(context, 'YES')!,
                          style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                              color: Theme.of(context).colorScheme.fontColor,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          SettingProvider settingProvider =
                          Provider.of<SettingProvider>(context, listen: false);
                          settingProvider.clearUserSession(context);
                          //favList.clear();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home', (Route<dynamic> route) => false);
                        })
                  ],
                );
              });
        }));
  }
  List<String?> themeList = [];
  Widget setCurrentPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            obscuringCharacter: "*",
            style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor,
            ),
            decoration: InputDecoration(
                label: Text(getTranslated(context, "CUR_PASS_LBL")!),
                fillColor: Theme.of(context).colorScheme.white,
                border: InputBorder.none),
            onSaved: (String? value) {
              currentPwd = value;
            },
            validator: (val) => validatePass(
                val!,
                getTranslated(context, 'PWD_REQUIRED'),
                getTranslated(context, 'PWD_LENGTH')),
          ),
        ),
      ),
    );
  }

  Widget setForgotPwdLable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          child: Text(getTranslated(context, "FORGOT_PASSWORD_LBL")!),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SendOtp()));
          },
        ),
      ),
    );
  }

  Widget newPwdField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: TextFormField(
            controller: newpassController,
            obscureText: true,
            obscuringCharacter: "*",
            style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor,
            ),
            decoration: InputDecoration(
                label: Text(getTranslated(context, "NEW_PASS_LBL")!),
                fillColor: Theme.of(context).colorScheme.white,
                border: InputBorder.none),
            onSaved: (String? value) {
              newPwd = value;
            },
            validator: (val) => validatePass(
                val!,
                getTranslated(context, 'PWD_REQUIRED'),
                getTranslated(context, 'PWD_LENGTH')),
          ),
        ),
      ),
    );
  }

  Widget confirmPwdField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: TextFormField(
            controller: confirmpassController,
            focusNode: confirmPwdFocus,
            obscureText: true,
            obscuringCharacter: "*",
            style: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                label: Text(getTranslated(context, "CONFIRMPASSHINT_LBL")!),
                fillColor: Theme.of(context).colorScheme.white,
                border: InputBorder.none),
            validator: (value) {
              if (value!.isEmpty) {
                return getTranslated(context, 'CON_PASS_REQUIRED_MSG');
              }
              if (value != newPwd) {
                confirmpassController.text = "";
                confirmPwdFocus.requestFocus();
                return getTranslated(context, 'CON_PASS_NOT_MATCH_MSG');
              } else {
                return null;
              }
            },
          ),
        ),
      ),
    );
  }
  void openChangeThemeBottomSheet() {
    themeList = [
      getTranslated(context, 'SYSTEM_DEFAULT'),
      getTranslated(context, 'LIGHT_THEME'),
      getTranslated(context, 'DARK_THEME')
    ];

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _changePwdKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetHandle(),
                      bottomsheetLabel("CHOOSE_THEME_LBL"),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: themeListView(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
  _updateState(int position, BuildContext ctx) {
    curTheme = position;

    onThemeChanged(themeList[position]!, ctx);
  }
  void onThemeChanged(
      String value,
      BuildContext ctx,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == getTranslated(ctx, 'SYSTEM_DEFAULT')) {
      themeNotifier.setThemeMode(ThemeMode.system);
      prefs.setString(APP_THEME, DEFAULT_SYSTEM);

      var brightness = SchedulerBinding.instance!.window.platformBrightness;
      if (mounted)
        setState(() {
          isDark = brightness == Brightness.dark;
          if (isDark)
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          else
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        });
    } else if (value == getTranslated(ctx, 'LIGHT_THEME')) {
      themeNotifier.setThemeMode(ThemeMode.light);
      prefs.setString(APP_THEME, LIGHT);
      if (mounted)
        setState(() {
          isDark = false;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        });
    } else if (value == getTranslated(ctx, 'DARK_THEME')) {
      themeNotifier.setThemeMode(ThemeMode.dark);
      prefs.setString(APP_THEME, DARK);
      if (mounted)
        setState(() {
          isDark = true;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        });
    }
    ISDARK = isDark.toString();

    //Provider.of<SettingProvider>(context,listen: false).setPrefrence(APP_THEME, value);
  }
  List<Widget> themeListView(BuildContext ctx) {
    return themeList
        .asMap()
        .map(
          (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              _updateState(index, ctx);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 25.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: curTheme == index
                              ? colors.grad2Color
                              : Theme.of(context).colorScheme.white,
                          border: Border.all(color: colors.grad2Color),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: curTheme == index
                                ? Icon(
                              Icons.check,
                              size: 17.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .fontColor,
                            )
                                : Icon(
                              Icons.check_box_outline_blank,
                              size: 15.0,
                              color:
                              Theme.of(context).colorScheme.white,
                            )),
                      ),
                      Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 15.0,
                          ),
                          child: Text(
                            themeList[index]!,
                            style: Theme.of(ctx)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .lightBlack),
                          ))
                    ],
                  ),
                  // index == themeList.length - 1
                  //     ? Container(
                  //         margin: EdgeInsetsDirectional.only(
                  //           bottom: 10,
                  //         ),
                  //       )
                  //     : Divider(
                  //         color: Theme.of(context).colorScheme.lightBlack,
                  //       )
                ],
              ),
            ),
          )),
    )
        .values
        .toList();
  }

  Widget saveButton(String title, VoidCallback? onBtnSelected) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: MaterialButton(
              height: 45.0,
              textColor: Theme.of(context).colorScheme.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: onBtnSelected,
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              color: colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  void _changeLan(String language, BuildContext ctx) async {
    Locale _locale = await setLocale(language);

    MyApp.setLocale(ctx, _locale);
  }

  List<Widget> getLngList(BuildContext ctx, StateSetter setModalState) {
    return languageList
        .asMap()
        .map(
          (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              if (mounted)
                setState(() {
                  selectLan = index;
                  _changeLan(langCode[index], ctx);
                });
              setModalState(() {});
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 25.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectLan == index
                                ? colors.grad2Color
                                : Theme.of(context).colorScheme.white,
                            border: Border.all(color: colors.grad2Color)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: selectLan == index
                              ? Icon(
                            Icons.check,
                            size: 17.0,
                            color: Theme.of(context)
                                .colorScheme
                                .fontColor,
                          )
                              : Icon(
                            Icons.check_box_outline_blank,
                            size: 15.0,
                            color:
                            Theme.of(context).colorScheme.white,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 15.0,
                          ),
                          child: Text(
                            languageList[index]!,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .lightBlack),
                          ))
                    ],
                  ),
                  // index == languageList.length - 1
                  //     ? Container(
                  //         margin: EdgeInsetsDirectional.only(
                  //           bottom: 10,
                  //         ),
                  //       )
                  //     : Divider(
                  //         color: Theme.of(context).colorScheme.lightBlack,
                  //       ),
                ],
              ),
            ),
          )),
    )
        .values
        .toList();
  }

  Future<void> setUpdateUser(String userID,
      [oldPwd, newPwd, username, userEmail]) async {
    var apiBaseHelper = ApiBaseHelper();
    var data = {USER_ID: userID};
    if ((oldPwd != "") && (newPwd != "")) {
      data[OLDPASS] = oldPwd;
      data[NEWPASS] = newPwd;
    } else if ((username != "") && (userEmail != "")) {
      data[USERNAME] = username;
      data[EMAIL] = userEmail;
    }
    print(data);
    print("==========");
    print(getUpdateUserApi);
    final result = await apiBaseHelper.postAPICall(getUpdateUserApi, data);

    bool error = result["error"];
    String? msg = result["message"];

    Navigator.of(context).pop();
    if (!error) {
      var settingProvider =
      Provider.of<SettingProvider>(context, listen: false);
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      if ((username != "") && (userEmail != "")) {
        settingProvider.setPrefrence(USERNAME, username);
        userProvider.setName(username);
        userProvider.setBankPic(result["data"][0]["bank_pass"]);
        settingProvider.setPrefrence(EMAIL, userEmail);
        userProvider.setEmail(userEmail);
      }

      setSnackbar(getTranslated(context, 'USER_UPDATE_MSG')!, context);
    } else {
      setSnackbar(msg!,context);
    }
  }

  Future<bool> validateAndSave(GlobalKey<FormState> key) async {
    final form = key.currentState!;
    form.save();
    if (form.validate()) {
      if (key == _changePwdKey) {
        await setUpdateUser(
          CUR_USERID!,
          passwordController.text,
          newpassController.text,
          "",
          "",
        );
        passwordController.clear();
        newpassController.clear();
        passwordController.clear();
        confirmpassController.clear();
      } else if (key == _changeUserDetailsKey) {
        setUpdateUser(
            CUR_USERID!, "", "", nameController.text, emailController.text);
      }
      return true;
    }
    return false;
  }
  void openChangePasswordBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _changePwdKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetHandle(),
                      bottomsheetLabel("CHANGE_PASS_LBL"),
                      setCurrentPasswordField(),
                      setForgotPwdLable(),
                      newPwdField(),
                      confirmPwdField(),
                      saveButton(getTranslated(context, "SAVE_LBL")!, () {
                        validateAndSave(_changePwdKey);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  void openChangeLanguageBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _changePwdKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetHandle(),
                      bottomsheetLabel("CHOOSE_LANGUAGE_LBL"),
                      StatefulBuilder(
                        builder:
                            (BuildContext context, StateSetter setModalState) {
                          return SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: getLngList(context, setModalState)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }


  _getDrawerItem(String title, String img) {
    return Card(
      elevation: 0,
      child: ListTile(
        trailing: Icon(
          Icons.navigate_next,
          color: colors.primary,
        ),
        leading: SvgPicture.asset(
          img,
          height: 25,
          width: 25,
          color: colors.primary,
        ),
        dense: true,
        title: Text(
          title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.lightBlack, fontSize: 15),
        ),
        onTap: () async{
          if (title == getTranslated(context, 'MY_ORDERS_LBL')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyOrder(),
              ),
            );

            //sendAndRetrieveMessage();
          } else if (title == getTranslated(context, 'MYTRANSACTION')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionHistory(),
                ));
          } else if (title == getTranslated(context, 'MYWALLET')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyWallet(),
                ));
          } else if (title == getTranslated(context, 'SETTING')) {
            CUR_USERID == null
                ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ))
                : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Setting(),
                ));
          } else if (title == getTranslated(context, 'MANAGE_ADD_LBL')) {
            CUR_USERID == null
                ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ))
                : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageAddress(
                    home: true,
                  ),
                ));
          } else if (title == getTranslated(context, 'REFEREARN')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReferEarn(),
                ));
          } else if (title == getTranslated(context, 'CONTACT_LBL')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(
                    title: getTranslated(context, 'CONTACT_LBL'),
                  ),
                ));
          } else if (title == getTranslated(context, 'CUSTOMER_SUPPORT')) {
            CUR_USERID == null
                ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ))
                : Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomerSupport()));
          }
          else if (title == getTranslated(context, 'TERM')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(
                    title: getTranslated(context, 'TERM'),
                  ),
                ));
          }


          else if (title == getTranslated(context, 'CORPORATE_GIFT')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CorporateGifting(
                    // title: getTranslated(context, 'TERM'),
                  ),
                ));
          }

          else if (title == getTranslated(context, 'FRANCHISE')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Franchise(
                    // title: getTranslated(context, 'TERM'),
                  ),
                ));
          }


          else if (title == getTranslated(context, 'PRIVACY'))
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(
                    title: getTranslated(context, 'PRIVACY'),
                  ),
                ));

          } else if (title == getTranslated(context, 'RATE_US')) {
            _launchURLBrowser();

            // _openStoreListing();
          }
          else if (title == getTranslated(context, 'SHARE_APP')) {
            var str =
                "$appName\n\n${getTranslated(context, 'APPFIND')}$androidLink$packageName\n\n ${getTranslated(context, 'IOSLBL')}\n$iosLink";

            Share.share(str);
          } else if (title == getTranslated(context, 'ABOUT_LBL')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(
                    title: getTranslated(context, 'ABOUT_LBL'),
                  ),
                ));
          } else if (title == getTranslated(context, 'FAQS')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Faqs(
                    title: getTranslated(context, 'FAQS'),
                  ),
                ));
            // } else if (title == getTranslated(context, 'CHANGE_THEME_LBL')) {
            //   openChangeThemeBottomSheet();
          } else if (title == getTranslated(context, 'LOGOUT')) {
            logOutDailog();
          } else if (title == getTranslated(context, 'CHANGE_PASS_LBL')) {
            openChangePasswordBottomSheet();
          } else if (title == getTranslated(context, 'CHANGE_LANGUAGE_LBL')) {
            openChangeLanguageBottomSheet();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeNotifier = Provider.of<ThemeNotifier>(context);
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: colors.primary,
              child: Column(
                children: [
                  _getHeader(),
                  Divider(color: Colors.white,thickness: 1,height: 0,),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height:45,
                          child: CUR_USERID == null ? InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.login_outlined,color: Colors.white,),
                                SizedBox(width: 5,),
                                Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
                              ],
                            ),
                          ):
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.person,color: Colors.white,),
                              SizedBox(width: 5,),
                              Text("My Account",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrder()));
                          },
                          child: Container(  height:45,
                            child: Row(
                              children: [
                                Icon(Icons.fire_truck,color: Colors.white,),
                                SizedBox(width: 5,),
                                Text("Track Order",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // InkWell(
            //   onTap: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
            //   },
            //   child: ListTile(
            //     leading: Icon(CupertinoIcons.home, color: Colors.black,),
            //     title: Text('Home', style: TextStyle(color: Colors.black),textScaleFactor: 1.2,),
            //   ),
            // ),
            //
            // ListTile(
            //   leading: Icon(Icons.logout, color: Colors.black,),
            //   title: Text('Logout', style: TextStyle(color: Colors.black),textScaleFactor: 1.2,),
            // ),
            CUR_USERID == "" || CUR_USERID == null
                ? Container()
                : _getDrawerItem(getTranslated(context, 'MY_ORDERS_LBL')!,
                'assets/images/pro_myorder.svg'),
            // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
            CUR_USERID == "" || CUR_USERID == null
                ? Container()
                : _getDrawerItem(getTranslated(context, 'MANAGE_ADD_LBL')!,
                'assets/images/pro_address.svg'),
            //CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
            CUR_USERID == "" || CUR_USERID == null
                ? Container()
                : _getDrawerItem(getTranslated(context, 'MYWALLET')!,
                'assets/images/pro_wh.svg'),
            // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
            CUR_USERID == "" || CUR_USERID == null
                ? Container()
                : _getDrawerItem(getTranslated(context, 'MYTRANSACTION')!,
                'assets/images/pro_th.svg'),
            // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
            // _getDrawerItem(getTranslated(context, 'CHANGE_THEME_LBL')!,
            //     'assets/images/pro_theme.svg'),
            // _getDivider(),
            _getDrawerItem(getTranslated(context, 'CHANGE_LANGUAGE_LBL')!,
                'assets/images/pro_language.svg'),
            //  CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
            CUR_USERID == "" || CUR_USERID == null
                ? Container()
                : _getDrawerItem(getTranslated(context, 'CHANGE_PASS_LBL')!,
                'assets/images/pro_pass.svg'),
            // _getDivider(),
            CUR_USERID == "" || CUR_USERID == null || !refer
                ? Container()
                : _getDrawerItem(getTranslated(context, 'REFEREARN')!,
                'assets/images/pro_referral.svg'),
            // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),
            _getDrawerItem(getTranslated(context, 'CUSTOMER_SUPPORT')!,
                'assets/images/pro_customersupport.svg'),
            // _getDivider(),
            _getDrawerItem(getTranslated(context, 'ABOUT_LBL')!,
                'assets/images/pro_aboutus.svg'),
            // _getDivider(),
            _getDrawerItem(getTranslated(context, 'CONTACT_LBL')!,
                'assets/images/pro_aboutus.svg'),
            // _getDivider(),
            _getDrawerItem(
                getTranslated(context, 'FAQS')!, 'assets/images/pro_faq.svg'),
            // _getDivider(),
            _getDrawerItem(
                getTranslated(context, 'PRIVACY')!, 'assets/images/pro_pp.svg'),
            // _getDivider(),
            _getDrawerItem(
                getTranslated(context, 'TERM')!, 'assets/images/pro_tc.svg'),
            // _getDivider(),
            _getDrawerItem(
                getTranslated(context, 'RATE_US')!, 'assets/images/pro_rateus.svg'),
            // _getDivider(),
            _getDrawerItem(getTranslated(context, 'SHARE_APP')!,
                'assets/images/pro_share.svg'),
            _getDrawerItem(getTranslated(context, 'FRANCHISE')!,
                'assets/images/franchiseicon.svg'),
            _getDrawerItem(getTranslated(context, 'CORPORATE_GIFT')!,
                'assets/images/corporategiftingicon.svg'),
            // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),

            CUR_USERID == "" || CUR_USERID == null
                ? Container()
                : _getDrawerItem(getTranslated(context, 'LOGOUT')!,
                'assets/images/pro_logout.svg'),
          ],
        ),
      ),
    );
  }
}


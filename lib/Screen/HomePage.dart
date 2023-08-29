import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
import 'package:eshop_multivendor/Helper/AppBtn.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Helper/SimBtn.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/widgets.dart';
import 'package:eshop_multivendor/Model/Model.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
import 'package:eshop_multivendor/Provider/FavoriteProvider.dart';
import 'package:eshop_multivendor/Provider/HomeProvider.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Screen/SellerList.dart';
import 'package:eshop_multivendor/Screen/Seller_Details.dart';
import 'package:eshop_multivendor/Screen/SubCategory.dart';
import 'package:eshop_multivendor/Screen/viewAllSubCategoryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import '../Helper/drawer.dart';
import '../Model/GetSubCatModel.dart';
import 'All_Category.dart';
import 'Favorite.dart';
import 'Login.dart';
import 'NotificationLIst.dart';
import 'ProductList.dart';
import 'Product_Detail.dart';
import 'Search.dart';
import 'SectionList.dart';
import 'package:http/http.dart'as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<SectionModel> sectionList = [];
List<Product> catList = [];
List<Product> popularList = [];
ApiBaseHelper apiBaseHelper = ApiBaseHelper();
List<String> tagList = [];
List<Product> sellerList = [];
int count = 1;
List<Model> homeSliderList = [];
List<Widget> pages = [];
int currentindex = 0;

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, TickerProviderStateMixin {
  bool _isNetworkAvail = true;

  final _controller = PageController();
  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<Model> offerImages = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  //String? curPin;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    callApi();
   //getScbCate();

    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) => _animateSlider());
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.blackTemp,
         drawer: MyDrawer(),
        appBar: AppBar(
          centerTitle: true,
          shape: ContinuousRectangleBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(100.0),
              topRight: Radius.circular(100.0)
            ),),
          // scrolledUnderElevation: ,
          title: Container(
            height: 70,
              child: Image.asset("assets/images/splashlogo.png",)),
          elevation: 0,
          backgroundColor: colors.primary,
          actions: [
            Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    imagePath + "desel_notification.svg",
                    color: Colors.white,
                  ),
                  onPressed: () {
                    CUR_USERID != null
                        ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationList(),
                        ))
                        : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ));
                  },
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: SvgPicture.asset(
                    imagePath + "desel_fav.svg",
                    color: Colors.white,
                  ),
                  onPressed: () {
                    CUR_USERID != null
                        ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Favorite(),
                        ))
                        : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ));
                  },
                ),
              ],
            )
          ],
        ),
      body: _isNetworkAvail
          ? RefreshIndicator(
        color: colors.primary,
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Container(
          color: Color(0xffF3F3F3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Search(),
                            ));
                      } ,
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        color: colors.primary,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              height: 40,
                              width: MediaQuery.of(context).size.width*.90,
                              child: Center(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Icon(Icons.search_rounded, color: Colors.black,),
                                          SizedBox(width: 5,),
                                          Text("Search"),
                                        ],
                                      ))),
                            ),
                            SizedBox(height: 5,)
                          ],
                        ),
                      ),
                    ),
                    _deliverPincode(),
                  ],
                ),
              ),
               Expanded(
                 child: Container(
                   child: ListView(
                     shrinkWrap: true,
                     physics: ScrollPhysics(),
                     children: [
                    _catList(),
                       Container(
                         margin: EdgeInsets.only(left: 10,right: 10,),
                           child: _slider()),
                        catList == null ? Center(child: CircularProgressIndicator(),) : allcate(),
                         _section(),
                         SizedBox(height: 10,),
                         // subCatText(),
                       getSubcat(),
                      SizedBox(height: 10,),
                      // _seller(),
                     ],
                   ),
                 ),
               )

            ],
          ),
        ),
      )
          : noInternet(context),
      );
  }
  Future<Null> _refresh() {
    context.read<HomeProvider>().setCatLoading(true);
    context.read<HomeProvider>().setSecLoading(true);
    context.read<HomeProvider>().setSliderLoading(true);
    context.read<CategoryProvider>().setSubList(popularList);
    return callApi();
  }

  // subCategory() async {
  //   var headers = {
  //     'Cookie': 'ci_session=b71c2ab400d168dbc9aea0f72a9ace75e1df5def'
  //   };
  //   var request = http.Request('POST', Uri.parse('$baseUrl/get_categories'));
  //
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     final result = await response.stream.bytesToString();
  //     var finalData = GetSubCatModel.fromJson(jsonDecode(result));
  //     print("===============>>>>>>${finalData.data}");
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  // }
  GetSubCatModel?  GetSub;
  getScbCate() async {
    print("Surendra");
    var headers = {
      'Cookie': 'ci_session=f3ab87fa85047cc5aa1f207c980f2d7d1c2b3c68'
    };
    var request = http.Request('GET', Uri.parse('$baseUrl/get_subcategories'));
    request.headers.addAll(headers);
      print("get subcategories here ${baseUrl}/get_subcategories");
      print("get subcategories here ${request}/get_subcategories");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
          var finalData = GetSubCatModel.fromJson(jsonDecode(result));
          print("FinalData==============>>>>>>>>${finalData}");
          print("FinalData==============11111111>>>>>>>>${finalData}");
         setState(() {
           GetSub = finalData;
         });
    }
    else {
    print(response.reasonPhrase);
    }

  }


  // Widget _slider() {
  //   double height = deviceWidth! / 2.2;
  //   return Selector<HomeProvider, bool>(
  //     builder: (context, data, child) {
  //       return data
  //           ? sliderLoading()
  //           : Stack(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Container(
  //                     // decoration: BoxDecoration(
  //                     //   borderRadius: BorderRadius.circular(20)
  //                     // ),
  //                     height: height,
  //                     width: double.infinity,
  //                     // margin: EdgeInsetsDirectional.only(top: 10),
  //                     child: PageView.builder(
  //                       itemCount: homeSliderList.length,
  //                       scrollDirection: Axis.horizontal,
  //                       controller: _controller,
  //                       physics: AlwaysScrollableScrollPhysics(),
  //                       onPageChanged: (index) {
  //                         context.read<HomeProvider>().setCurSlider(index);
  //                       },
  //                       itemBuilder: (BuildContext context, int index) {
  //                         return pages[index];
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: 0,
  //                   height: 40,
  //                   left: 0,
  //                   width: deviceWidth,
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.max,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: map<Widget>(
  //                       homeSliderList,
  //                       (index, url) {
  //                         return Container(
  //                           width: 8.0,
  //                           height: 8.0,
  //                           margin: EdgeInsets.symmetric(
  //                               vertical: 10.0, horizontal: 2.0),
  //                           // decoration: BoxDecoration(
  //                           //   // shape: BoxShape.circle,
  //                           //   color: context.read<HomeProvider>().curSlider ==
  //                           //           index
  //                           //       ? Theme.of(context).colorScheme.fontColor
  //                           //       : Theme.of(context).colorScheme.lightBlack,
  //                           // ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //     },
  //     selector: (_, homeProvider) => homeProvider.sliderLoading,
  //   );
  // }

  Widget _slider() {
    double height = deviceWidth! / 1.0;
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? sliderLoading()
            : ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/5.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(6)
                ),
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 2.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration:
                    Duration(milliseconds: 300),
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                    height: height,
                    onPageChanged: (position, reason) {
                      setState(() {
                        currentindex = position;
                      });
                      print(reason);
                      print(CarouselPageChangedReason.controller);
                    },
                  ),
                  items: homeSliderList.map((val) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList(
                           name: catList[0].name,
                          id: catList[0].categoryId,
                          tag: false,
                          fromSeller: false,

                        )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height:120,
                        padding: EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              "${val.image}",
                              fit: BoxFit.fill,
                            )),
                      ),
                    );
                  }).toList(),
                ),
                // margin: EdgeInsetsDirectional.only(top: 10),
                // child: PageView.builder(
                //   itemCount: homeSliderList.length,
                //   scrollDirection: Axis.horizontal,
                //   controller: _controller,
                //   pageSnapping: true,
                //   physics: AlwaysScrollableScrollPhysics(),
                //   onPageChanged: (index) {
                //     context.read<HomeProvider>().setCurSlider(index);
                //   },
                //   itemBuilder: (BuildContext context, int index) {
                //     return pages[index];
                //   },
                // ),
              ),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: homeSliderList.map((e) {
                    int index = homeSliderList.indexOf(e);
                    return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentindex == index
                              ? Theme.of(context).colorScheme.fontColor
                              : Theme.of(context).colorScheme.lightBlack,
                        ));
                  }).toList()),
            ],
          ),
        );
      },
      selector: (_, homeProvider) => homeProvider.sliderLoading,
    );
  }

  Widget catNew(){
    print("checking new cat here ${catList.length}");
    return catList == null ? CircularProgressIndicator():
      Padding(
      padding: const EdgeInsets.all(15.0),
      child: catList.length   ==  0 ? Center(child: CircularProgressIndicator(),) :GridView.count(
        padding: EdgeInsetsDirectional.only(top: 5),
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: 0.72,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(
          catList.length > 5 ? 6 : catList.length,
              (index) {
            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubCategory(
                      title: catList[index].name!,
                      subList: catList[index].subList,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: colors.whiteTemp,
                  borderRadius: BorderRadius.circular(3.0)
                ),
                child: Column(
                  children: [
                    catList[index].image == null || catList[index].image == " " ? Image.asset("assets/images/placeholder.png"):
                    Container(
                      height: 105,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3)),
                        child: Image.network("${catList[index].image}",fit: BoxFit.fill,),
                      ),
                    ),

                    Center(child: Text("${catList[index].name}",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 13,overflow:TextOverflow.ellipsis)))

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget productList1(){
    return InkWell(
      onTap: (){

        Navigator.push(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProductDetail(

              )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: sectionList.length>0?sectionList == null || sectionList == "" ? Text("Lodding....") : ListView.builder(
          // shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount:sectionList[0].productList!.length,
            itemBuilder: (BuildContext context, int index) {
            // print("VSSSSSSSSSSS------${sectionList.length}");
              return Container(
                height: 150,
                width: 150,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(3.0)
                ),
                child: Column(
                  children: [
                    sectionList[0].productList![index].image == null || sectionList[0].productList![index].image == " " ? Image.asset("assets/images/placeholder.png"):
                    Expanded(
                      child: Container(
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3)),
                          child: Image.network("${sectionList[0].productList![index].image}",fit: BoxFit.fill,),
                        ),
                      ),
                    ),
                        Text("${sectionList[0].productList![index].name}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("$CUR_CURRENCY ""${sectionList[0].productList![index].prVarientList![0].disPrice!}",style: TextStyle(
                                decoration: TextDecoration.lineThrough
                              ),),
                              Text("$CUR_CURRENCY ""${sectionList[0].productList![index].prVarientList![0].price!}"),
                            ],
                        )

                        // Text(sectionList[index].productList![0].prVarientList![index].price!),

                  ],
                ),
              );


              //   Container(
              //   height: 150,
              //   decoration: BoxDecoration(
              //       color: colors.whiteTemp,
              //       borderRadius: BorderRadius.circular(3.0)),
              //   child: Column(
              //     children: [
              //      Image.network("${sectionList[0].productList![index].image}")
              //     ],
              //   ),
              // );
            }):SizedBox(),
      ),
    );
  }

  Widget _catText(){
    return ListTile(
      leading: Text("CATEGORIES",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),),
      trailing: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllCategory()
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: colors.whiteTemp,
              borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text("MORE"),
            )),
      ),
    );

  }
  Widget _productText(){
    return ListTile(
      leading: Text("PRODUCTS",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),),
      trailing: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductList(
                  name: catList[0].name,
                  id: catList[0].id,
                  tag: false,
                  fromSeller: false,
                ),
            ),
          );
        },
        child: Container(
            decoration: BoxDecoration(
                color: colors.whiteTemp,
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text("MORE"),
            )),
      ),
    );

  }

  Widget subCatText(){
    return ListTile(
      leading: Text("SUBCATEGORIES",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),),
      trailing: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductList(
                name: catList[0].name,
                id: catList[0].id,
                tag: false,
                fromSeller: false,
              ),
            ),
          );
        },
        child: SizedBox()
      ),
    );

  }

  void _animateSlider() {
    Future.delayed(Duration(seconds: 30)).then(
      (_) {
        if (mounted) {
          int nextPage = _controller.hasClients
              ? _controller.page!.round() + 1
              : _controller.initialPage;

          if (nextPage == homeSliderList.length) {
            nextPage = 0;
          }
          if (_controller.hasClients)
            _controller
                .animateToPage(nextPage,
                    duration: Duration(milliseconds: 200), curve: Curves.linear)
                .then((_) => _animateSlider());
        }
      },
    );
  }

  // _singleSection(int index) {
  //   Color back;
  //   int pos = index % 5;
  //   if (pos == 0)
  //     back = Theme.of(context).colorScheme.back1;
  //   else if (pos == 1)
  //     back = Theme.of(context).colorScheme.back2;
  //   else if (pos == 2)
  //     back = Theme.of(context).colorScheme.back3;
  //   else if (pos == 3)
  //     back = Theme.of(context).colorScheme.back4;
  //   else
  //     back = Theme.of(context).colorScheme.back5;
  //
  //   return sectionList[index].productList!.length > 0
  //       ? Container(
  //     height: 200,
  //         child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 8.0),
  //                 child: Column(
  //                   // mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     _getHeading(sectionList[index].title ?? "", index),
  //                     _getSection(index),
  //                     // Container(
  //                     //   height: 200,
  //                     //   child: Expanded(
  //                     //     child: ListView.builder(
  //                     //         shrinkWrap: true,
  //                     //         physics: AlwaysScrollableScrollPhysics(),
  //                     //         scrollDirection: Axis.horizontal,
  //                     //         itemCount: sectionList[0].productList!.length,
  //                     //         itemBuilder: (context, index ){
  //                     //           return productItem(0, index, index % 2 == 0 ? true : false);
  //                     //         }),
  //                     //   ),
  //                     // ),
  //                     // _getSection(index),
  //                   ],
  //                 ),
  //               ),
  //
  //               offerImages.length > index ? _getOfferImage(index) : Container(),
  //             ],
  //           ),
  //       )
  //       : Container();
  // }

  _singleSection(int index) {
    Color back;
    int pos = index % 5;
    if (pos == 0)
      back = Theme.of(context).colorScheme.back1;
    else if (pos == 1)
      back = Theme.of(context).colorScheme.back2;
    else if (pos == 2)
      back = Theme.of(context).colorScheme.back3;
    else if (pos == 3)
      back = Theme.of(context).colorScheme.back4;
    else
      back = Theme.of(context).colorScheme.back5;

    return sectionList[index].productList!.length > 0
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _getHeading(sectionList[index].title ?? "", index),
              _getSection(index),
            ],
          ),
        ),
        offerImages.length > index ? _getOfferImage(index) : Container(),
      ],
    )
        : Container();
  }
  _getHeading(String title, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(right: 20.0),
        //   child: Stack(
        //     clipBehavior: Clip.none,
        //     alignment: Alignment.centerRight,
        //     children: <Widget>[
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Container(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.only(
        //               topLeft: Radius.circular(20),
        //               topRight: Radius.circular(20),
        //             ),
        //             color: colors.yellow,
        //           ),
        //           padding: EdgeInsetsDirectional.only(
        //               start: 10, bottom: 3, top: 3, end: 10),
        //           child: Text(
        //             title,
        //             style: Theme.of(context)
        //                 .textTheme
        //                 .subtitle2!
        //                 .copyWith(color: colors.blackTemp),
        //             maxLines: 1,
        //             overflow: TextOverflow.ellipsis,
        //           ),
        //         ),
        //       ),
        //       /*   Positioned(
        //           // clipBehavior: Clip.hardEdge,
        //           // margin: EdgeInsets.symmetric(horizontal: 20),
        //
        //           right: -14,
        //           child: SvgPicture.asset("assets/images/eshop.svg"))*/
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(sectionList[index].shortDesc ?? "",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.fontColor)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size.zero, // <
                    backgroundColor: colors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                child: Text(
                  getTranslated(context, 'VIEW_ALL')!,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context).colorScheme.white,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  SectionModel model = sectionList[index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SectionList(
                        index: index,
                        section_model: model,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _getOfferImage(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: FadeInImage(
            fit: BoxFit.contain,
            fadeInDuration: Duration(milliseconds: 150),
            image: CachedNetworkImageProvider(offerImages[index].image!),
            width: double.maxFinite,
            imageErrorBuilder: (context, error, stackTrace) => erroWidget(50),

            // errorWidget: (context, url, e) => placeHolder(50),
            placeholder: AssetImage(
              "assets/images/sliderph.png",
            ),
          ),
        ),
        onTap: () {
          if (offerImages[index].type == "products") {
            Product? item = offerImages[index].list;

            Navigator.push(
              context,
              PageRouteBuilder(
                //transitionDuration: Duration(seconds: 1),
                pageBuilder: (_, __, ___) =>
                    ProductDetail(model: item, secPos: 0, index: 0, list: true
                        //  title: sectionList[secPos].title,
                        ),
              ),
            );
          } else if (offerImages[index].type == "categories") {
            Product item = offerImages[index].list;
            if (item.subList == null || item.subList!.length == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    name: item.name,
                    id: item.id,
                    tag: false,
                    fromSeller: false,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategory(
                    title: item.name!,
                    subList: item.subList,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  // _getSection(int i) {
  //    //var orient = MediaQuery.of(context).orientation;
  //
  //   return sectionList[i].style == DEFAULT
  //       ? Container(
  //         height: 200,
  //         child: ListView.builder(
  //           shrinkWrap: true,
  //           physics: AlwaysScrollableScrollPhysics(),
  //           scrollDirection: Axis.horizontal,
  //           itemCount: sectionList[i].productList!.length,
  //             itemBuilder: (context, index ){
  //           return productItem(i, index, index % 2 == 0 ? true : false);
  //         }),
  //       )
  //       // : sectionList[i].style == STYLE1
  //       //     ? sectionList[i].productList!.length > 0
  //       //         ? Padding(
  //       //             padding: const EdgeInsets.all(15.0),
  //       //             child: Row(
  //       //               children: [
  //       //                 Flexible(
  //       //                   flex: 3,
  //       //                   fit: FlexFit.loose,
  //       //                   child: Container(
  //       //                     height: orient == Orientation.portrait
  //       //                         ? deviceHeight! * 0.4
  //       //                         : deviceHeight!,
  //       //                     child: productItem(i, 0, true),
  //       //                   ),
  //       //                 ),
  //       //                 Flexible(
  //       //                   flex: 2,
  //       //                   fit: FlexFit.loose,
  //       //                   child: Column(
  //       //                     mainAxisSize: MainAxisSize.min,
  //       //                     children: [
  //       //                       Container(
  //       //                         height: orient == Orientation.portrait
  //       //                             ? deviceHeight! * 0.2
  //       //                             : deviceHeight! * 0.5,
  //       //                         child: productItem(i, 1, false),
  //       //                       ),
  //       //                       Container(
  //       //                         height: orient == Orientation.portrait
  //       //                             ? deviceHeight! * 0.2
  //       //                             : deviceHeight! * 0.5,
  //       //                         child: productItem(i, 2, false),
  //       //                       ),
  //       //                     ],
  //       //                   ),
  //       //                 ),
  //       //               ],
  //       //             ),
  //       //           )
  //       //         : Container()
  //       //     : sectionList[i].style == STYLE2
  //       //         ? Padding(
  //       //             padding: const EdgeInsets.all(15.0),
  //       //             child: Row(
  //       //               children: [
  //       //                 Flexible(
  //       //                   flex: 2,
  //       //                   fit: FlexFit.loose,
  //       //                   child: Column(
  //       //                     mainAxisSize: MainAxisSize.min,
  //       //                     children: [
  //       //                       Container(
  //       //                           height: orient == Orientation.portrait
  //       //                               ? deviceHeight! * 0.2
  //       //                               : deviceHeight! * 0.5,
  //       //                           child: productItem(i, 0, true)),
  //       //                       Container(
  //       //                         height: orient == Orientation.portrait
  //       //                             ? deviceHeight! * 0.2
  //       //                             : deviceHeight! * 0.5,
  //       //                         child: productItem(i, 1, true),
  //       //                       ),
  //       //                     ],
  //       //                   ),
  //       //                 ),
  //       //                 Flexible(
  //       //                   flex: 3,
  //       //                   fit: FlexFit.loose,
  //       //                   child: Container(
  //       //                     height: orient == Orientation.portrait
  //       //                         ? deviceHeight! * 0.4
  //       //                         : deviceHeight,
  //       //                     child: productItem(i, 2, false),
  //       //                   ),
  //       //                 ),
  //       //               ],
  //       //             ),
  //       //           )
  //       //         : sectionList[i].style == STYLE3
  //       //             ? Padding(
  //       //                 padding: const EdgeInsets.all(15.0),
  //       //                 child: Column(
  //       //                   mainAxisSize: MainAxisSize.min,
  //       //                   children: [
  //       //                     Flexible(
  //       //                       flex: 1,
  //       //                       fit: FlexFit.loose,
  //       //                       child: Container(
  //       //                         height: orient == Orientation.portrait
  //       //                             ? deviceHeight! * 0.3
  //       //                             : deviceHeight! * 0.6,
  //       //                         child: productItem(i, 0, false),
  //       //                       ),
  //       //                     ),
  //       //                     Container(
  //       //                       height: orient == Orientation.portrait
  //       //                           ? deviceHeight! * 0.2
  //       //                           : deviceHeight! * 0.5,
  //       //                       child: Row(
  //       //                         children: [
  //       //                           Flexible(
  //       //                             flex: 1,
  //       //                             fit: FlexFit.loose,
  //       //                             child: productItem(i, 1, true),
  //       //                           ),
  //       //                           Flexible(
  //       //                             flex: 1,
  //       //                             fit: FlexFit.loose,
  //       //                             child: productItem(i, 2, true),
  //       //                           ),
  //       //                           Flexible(
  //       //                             flex: 1,
  //       //                             fit: FlexFit.loose,
  //       //                             child: productItem(i, 3, false),
  //       //                           ),
  //       //                         ],
  //       //                       ),
  //       //                     ),
  //       //                   ],
  //       //                 ),
  //       //               )
  //       //             : sectionList[i].style == STYLE4
  //       //                 ? Padding(
  //       //                     padding: const EdgeInsets.all(15.0),
  //       //                     child: Column(
  //       //                       mainAxisSize: MainAxisSize.min,
  //       //                       children: [
  //       //                         Flexible(
  //       //                             flex: 1,
  //       //                             fit: FlexFit.loose,
  //       //                             child: Container(
  //       //                                 height: orient == Orientation.portrait
  //       //                                     ? deviceHeight! * 0.25
  //       //                                     : deviceHeight! * 0.5,
  //       //                                 child: productItem(i, 0, false))),
  //       //                         Container(
  //       //                           height: orient == Orientation.portrait
  //       //                               ? deviceHeight! * 0.2
  //       //                               : deviceHeight! * 0.5,
  //       //                           child: Row(
  //       //                             children: [
  //       //                               Flexible(
  //       //                                 flex: 1,
  //       //                                 fit: FlexFit.loose,
  //       //                                 child: productItem(i, 1, true),
  //       //                               ),
  //       //                               Flexible(
  //       //                                 flex: 1,
  //       //                                 fit: FlexFit.loose,
  //       //                                 child: productItem(i, 2, false),
  //       //                               ),
  //       //                             ],
  //       //                           ),
  //       //                         ),
  //       //                       ],
  //       //                     ),
  //       //                   )
  //                       : Padding(
  //                           padding: const EdgeInsets.all(15.0),
  //                           child: GridView.count(
  //                             padding: EdgeInsetsDirectional.only(top: 5),
  //                             crossAxisCount: 2,
  //                             shrinkWrap: true,
  //                             childAspectRatio: 1.2,
  //                             physics: NeverScrollableScrollPhysics(),
  //                             mainAxisSpacing: 0,
  //                             crossAxisSpacing: 0,
  //                             children: List.generate(
  //                               sectionList[i].productList!.length < 6
  //                                   ? sectionList[i].productList!.length
  //                                   : 6,
  //                               (index) {
  //                                 return productItem(
  //                                     i, index, index % 2 == 0 ? true : false);
  //                               },
  //                             ),
  //                           ),
  //                         );
  // }

  _getSection(int i) {
    var orient = MediaQuery.of(context).orientation;

    return sectionList[i].style == DEFAULT
        ? Padding(
      padding: const EdgeInsets.all(15.0),
      child:
      GridView.count(
        // mainAxisSpacing: 12,
        // crossAxisSpacing: 12,
        padding: EdgeInsetsDirectional.only(top: 5),
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 0.750,
        //  childAspectRatio: 1.0,
        physics: NeverScrollableScrollPhysics(),
        children:
        //  [
        //   Container(height: 500, width: 1200, color: Colors.red),
        //   Text("hello"),
        //   Container(height: 10, width: 50, color: Colors.green),
        // ]
        List.generate(
          sectionList[i].productList!.length < 4
              ? sectionList[i].productList!.length
              : 4,
              (index) {
            // return Container(
            //   width: 600,
            //   height: 50,
            //   color: Colors.red,
            // );
            return productItem(i, index, index % 2 == 0 ? true : false);
          },
        ),
      ),

    )
        : sectionList[i].style == STYLE1
        ? sectionList[i].productList!.length > 0
        ? Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: Container(
              height: orient == Orientation.portrait
                  ? deviceHeight! * 0.4
                  : deviceHeight!,
              child: productItem(i, 0, true),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: orient == Orientation.portrait
                      ? deviceHeight! * 0.2
                      : deviceHeight! * 0.5,
                  child: productItem(i, 1, false),
                ),
                Container(
                  height: orient == Orientation.portrait
                      ? deviceHeight! * 0.2
                      : deviceHeight! * 0.5,
                  child: productItem(i, 2, false),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        : Container()
        : sectionList[i].style == STYLE2
        ? Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: orient == Orientation.portrait
                        ? deviceHeight! * 0.2
                        : deviceHeight! * 0.5,
                    child: productItem(i, 0, true)),
                Container(
                  height: orient == Orientation.portrait
                      ? deviceHeight! * 0.2
                      : deviceHeight! * 0.5,
                  child: productItem(i, 1, true),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: Container(
              height: orient == Orientation.portrait
                  ? deviceHeight! * 0.4
                  : deviceHeight,
              child: productItem(i, 2, false),
            ),
          ),
        ],
      ),
    )
        : sectionList[i].style == STYLE3
        ? Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
              height: orient == Orientation.portrait
                  ? deviceHeight! * 0.3
                  : deviceHeight! * 0.6,
              child: productItem(i, 0, false),
            ),
          ),
          Container(
            height: orient == Orientation.portrait
                ? deviceHeight! * 0.2
                : deviceHeight! * 0.5,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: productItem(i, 1, true),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: productItem(i, 2, true),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: productItem(i, 3, false),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        : sectionList[i].style == STYLE4
        ? Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Container(
                  height: orient == Orientation.portrait
                      ? deviceHeight! * 0.25
                      : deviceHeight! * 0.5,
                  child: productItem(i, 0, false))),
          Container(
            height: orient == Orientation.portrait
                ? deviceHeight! * 0.2
                : deviceHeight! * 0.5,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: productItem(i, 1, true),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: productItem(i, 2, false),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        : Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.count(
        padding: EdgeInsetsDirectional.only(top: 5),
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 1.2,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        children: List.generate(
          sectionList[i].productList!.length < 6
              ? sectionList[i].productList!.length
              : 6,
              (index) {
            return productItem(
                i, index, index % 2 == 0 ? true : false);
          },
        ),
      ),
    );
  }

  // Widget productItem(int secPos, int index, bool pad) {
  //   if (sectionList[secPos].productList!.length > index) {
  //     String? offPer;
  //     double price = double.parse(
  //         sectionList[secPos].productList![index].prVarientList![0].disPrice!);
  //     if (price == 0) {
  //       price = double.parse(
  //           sectionList[secPos].productList![index].prVarientList![0].price!);
  //     } else {
  //       double off = double.parse(sectionList[secPos]
  //               .productList![index]
  //               .prVarientList![0]
  //               .price!) -
  //           price;
  //       offPer = ((off * 100) /
  //               double.parse(sectionList[secPos]
  //                   .productList![index]
  //                   .prVarientList![0]
  //                   .price!))
  //           .toStringAsFixed(2);
  //     }
  //
  //     double width = deviceWidth! * 0.5;
  //
  //     return Card(
  //       elevation: 0.0,
  //
  //       margin: EdgeInsetsDirectional.only(bottom: 2, end: 2),
  //       //end: pad ? 5 : 0),
  //       child: InkWell(
  //         borderRadius: BorderRadius.circular(4),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Expanded(
  //               /*       child: ClipRRect(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(5),
  //                       topRight: Radius.circular(5)),
  //                   child: Hero(
  //                     tag:
  //                     "${sectionList[secPos].productList![index].id}$secPos$index",
  //                     child: FadeInImage(
  //                       fadeInDuration: Duration(milliseconds: 150),
  //                       image: NetworkImage(
  //                           sectionList[secPos].productList![index].image!),
  //                       height: double.maxFinite,
  //                       width: double.maxFinite,
  //                       fit: extendImg ? BoxFit.fill : BoxFit.contain,
  //                       imageErrorBuilder: (context, error, stackTrace) =>
  //                           erroWidget(width),
  //
  //                       // errorWidget: (context, url, e) => placeHolder(width),
  //                       placeholder: placeHolder(width),
  //                     ),
  //                   )),*/
  //               child: Stack(
  //                 alignment: Alignment.topRight,
  //                 children: [
  //                   ClipRRect(
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(5),
  //                         topRight: Radius.circular(5)),
  //                     child: Hero(
  //                       transitionOnUserGestures: true,
  //                       tag:
  //                           "${sectionList[secPos].productList![index].id}$secPos$index",
  //                       child: FadeInImage(
  //                         fadeInDuration: Duration(milliseconds: 150),
  //                         image: CachedNetworkImageProvider(
  //                             sectionList[secPos].productList![index].image!),
  //                         height: double.maxFinite,
  //                         width: double.maxFinite,
  //                         imageErrorBuilder: (context, error, stackTrace) =>
  //                             erroWidget(double.maxFinite),
  //                         fit: BoxFit.contain,
  //                         placeholder: placeHolder(width),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsetsDirectional.only(
  //                 start: 5.0,
  //                 top: 3,
  //               ),
  //               child: Text(
  //                 sectionList[secPos].productList![index].name!,
  //                 style: Theme.of(context).textTheme.caption!.copyWith(
  //                     color: Theme.of(context).colorScheme.lightBlack),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //             Text(
  //               " " + CUR_CURRENCY! + " " + price.toString(),
  //               style: TextStyle(
  //                   color: Theme.of(context).colorScheme.fontColor,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 15),
  //             ),
  //             Padding(
  //               padding: const EdgeInsetsDirectional.only(
  //                   start: 5.0, bottom: 5, top: 3),
  //               child: double.parse(sectionList[secPos]
  //                           .productList![index]
  //                           .prVarientList![0]
  //                           .disPrice!) !=
  //                       0
  //                   ? Row(
  //                       children: <Widget>[
  //                         Text(
  //                           double.parse(sectionList[secPos]
  //                                       .productList![index]
  //                                       .prVarientList![0]
  //                                       .disPrice!) !=
  //                                   0
  //                               ? CUR_CURRENCY! +
  //                                   "" +
  //                                   sectionList[secPos]
  //                                       .productList![index]
  //                                       .prVarientList![0]
  //                                       .price!
  //                               : "",
  //                           style: Theme.of(context)
  //                               .textTheme
  //                               .overline!
  //                               .copyWith(
  //                                   decoration: TextDecoration.lineThrough,
  //                                   letterSpacing: 0,
  //                                   fontSize: 15,
  //                                   fontWeight: FontWeight.bold),
  //                         ),
  //                         Flexible(
  //                           child: Text(
  //                             " | " + "$offPer%",
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .overline!
  //                                 .copyWith(
  //                                     color: colors.primary,
  //                                     letterSpacing: 0,
  //                                     fontSize: 15,
  //                                     fontWeight: FontWeight.bold),
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                   : Container(
  //                       height: 5,
  //                     ),
  //             ),
  //           ],
  //         ),
  //         onTap: () {
  //           Product model = sectionList[secPos].productList![index];
  //           Navigator.push(
  //             context,
  //             PageRouteBuilder(
  //               // transitionDuration: Duration(milliseconds: 150),
  //               pageBuilder: (_, __, ___) => ProductDetail(
  //                   model: model, secPos: secPos, index: index, list: false
  //                   //  title: sectionList[secPos].title,
  //                   ),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   } else
  //     return Container();
  // }

  // _section() {
  //   return Selector<HomeProvider, bool>(
  //     builder: (context, data, child) {
  //       return data
  //           ? Container(
  //               width: double.infinity,
  //               child: Shimmer.fromColors(
  //                 baseColor: Theme.of(context).colorScheme.simmerBase,
  //                 highlightColor: Theme.of(context).colorScheme.simmerHigh,
  //                 child: sectionLoading(),
  //               ),
  //             )
  //           : Container(
  //         height: 200,
  //             child: ListView.builder(
  //                 padding: EdgeInsets.all(0),
  //                 itemCount: sectionList.length,
  //                 shrinkWrap: true,
  //                 physics: NeverScrollableScrollPhysics(),
  //                 itemBuilder: (context, index) {
  //                   print("here");
  //                   return _singleSection(index);
  //                 },
  //               ),
  //           );
  //     },
  //     selector: (_, homeProvider) => homeProvider.secLoading,
  //   );
  // }
  Widget productItem(int secPos, int index, bool pad) {
    if (sectionList[secPos].productList!.length > index) {
      String? offPer;
      double price = double.parse(
          sectionList[secPos].productList![index].prVarientList![0].disPrice!);
      if (price == 0) {
        price = double.parse(
            sectionList[secPos].productList![index].prVarientList![0].price!);
      } else {
        double off = double.parse(sectionList[secPos]
            .productList![index]
            .prVarientList![0]
            .price!) -
            price;
        offPer = ((off * 100) /
            double.parse(sectionList[secPos]
                .productList![index]
                .prVarientList![0]
                .price!))
            .toStringAsFixed(2);
      }

      double width = deviceWidth! * 0.5;

      return Card(
        elevation: 0.0,

        margin: EdgeInsetsDirectional.only(bottom: 2, end: 2),
        //end: pad ? 5 : 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                /*       child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Hero(
                      tag:
                      "${sectionList[secPos].productList![index].id}$secPos$index",
                      child: FadeInImage(
                        fadeInDuration: Duration(milliseconds: 150),
                        image: NetworkImage(
                            sectionList[secPos].productList![index].image!),
                        height: double.maxFinite,
                        width: double.maxFinite,
                        fit: extendImg ? BoxFit.fill : BoxFit.contain,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            erroWidget(width),

                        // errorWidget: (context, url, e) => placeHolder(width),
                        placeholder: placeHolder(width),
                      ),
                    )),*/
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag:
                        "${sectionList[secPos].productList![index].id}$secPos$index",
                        child: FadeInImage(
                          fadeInDuration: Duration(milliseconds: 150),
                          image: CachedNetworkImageProvider(
                              sectionList[secPos].productList![index].image!),
                          height: double.maxFinite,
                          width: double.maxFinite,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              erroWidget(double.maxFinite),
                          fit: BoxFit.contain,
                          placeholder: placeHolder(width),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 5.0,
                  top: 3,
                ),
                child: Text(
                  sectionList[secPos].productList![index].name!,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context).colorScheme.lightBlack),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                " " + CUR_CURRENCY! + " " + price.toString(),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.fontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 5.0, bottom: 5, top: 3),
                child: double.parse(sectionList[secPos]
                    .productList![index]
                    .prVarientList![0]
                    .disPrice!) !=
                    0
                    ? Row(
                  children: <Widget>[
                    Text(
                      double.parse(sectionList[secPos]
                          .productList![index]
                          .prVarientList![0]
                          .disPrice!) !=
                          0
                          ? CUR_CURRENCY! +
                          "" +
                          sectionList[secPos]
                              .productList![index]
                              .prVarientList![0]
                              .price!
                          : "",
                      style: Theme.of(context)
                          .textTheme
                          .overline!
                          .copyWith(
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 0,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        " | " + "$offPer%",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .overline!
                            .copyWith(
                            color: colors.primary,
                            letterSpacing: 0,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
                    : Container(
                  height: 5,
                ),
              ),
            ],
          ),
          onTap: () {
            Product model = sectionList[secPos].productList![index];
            Navigator.push(
              context,
              PageRouteBuilder(
                // transitionDuration: Duration(milliseconds: 150),
                  pageBuilder: (_,__, ___) => ProductDetail(
                  model: model, secPos: secPos, index: index, list: false
                //  title: sectionList[secPos].title,
              ),
            ),
            );
          },
        ),
      );
    } else
      return Container();
  }

  allcate() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        if( catList.isEmpty ){
          return
          Center(child: CircularProgressIndicator());
        }
      else{
          return catList[0].image == null || catList[0].image == "" ? SizedBox.shrink():data
              ? Container(
              width: double.infinity,
              child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.simmerBase,
                  highlightColor: Theme.of(context).colorScheme.simmerHigh,
                  child: catLoading()))
              : Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5,top: 10),
            child: Container(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                // itemCount: catList.length < 10 ? catList.length : 10,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  childAspectRatio: 0.80,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 7,
                  crossAxisSpacing: 2,

                  // crossAxisSpacing: 1,
                  // mainAxisSpacing: 2,
                  // crossAxisCount: 2,
                  //


                  // childAspectRatio: 2,
                  // crossAxisCount: 4,
                  // crossAxisSpacing: 1,
                  children: List.generate(
                    catList.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 0),
                        child: GestureDetector(
                          onTap: () async {
                            if (catList[index].subList == null ||
                                catList[index].subList!.length == 0) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductList(
                                      name: catList[index].name,
                                      id: catList[index].id,
                                      tag: false,
                                      fromSeller: false,
                                    ),
                                  ));
                            } else {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubCategory(
                                      title: catList[index].name!,
                                      subList: catList[index].subList,
                                    ),
                                  ));
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                catList[index].image != null ?
                                Container(
                                    height: 100,
                                    width: double.infinity,
                                    child: Image.network("${catList[index].image}", fit: BoxFit.fill,))
                                    :
                                Container(
                                    height: 90,
                                    width: 140,
                                    child: Image.asset("assets/images/homelogo.png")
                                ),
                                // Image.network(
                                //   radius: 30,
                                //   backgroundImage: NetworkImage(
                                //     "${catList[index].image}",
                                //   ),
                                // ),
                                // CircleAvatar(
                                //   child: FadeInImage(
                                //     fadeInDuration: Duration(milliseconds: 150),
                                //     image: CachedNetworkImageProvider(
                                //       catList[index].image!,
                                //     ),
                                //     height: 50.0,
                                //     width: 50.0,
                                //     fit: BoxFit.contain,
                                //     imageErrorBuilder:
                                //         (context, error, stackTrace) =>
                                //         erroWidget(50),
                                //     placeholder: placeHolder(50),
                                //   ),
                                // ),
                                // Container(
                                //   child: Text(
                                //     catList[index].name!,
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .caption!
                                //         .copyWith(
                                //             color: Theme.of(context)
                                //                 .colorScheme
                                //                 .fontColor,
                                //             fontWeight: FontWeight.w600,
                                //             fontSize: 10),
                                //     overflow: TextOverflow.ellipsis,
                                //     textAlign: TextAlign.center,
                                //   ),
                                //   width: 50,
                                // ),
                                SizedBox(height: 10,),
                                Container(
                                  child: Text(
                                    catList[index].name!.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                  width: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      //subCatItem(data, index, context);
                    },
                  )
                // itemBuilder: (context, index) {
                //   if (index == 0)
                //     return Container();
                //   else
                //     return Padding(
                //       padding: const EdgeInsetsDirectional.only(end: 10),
                //       child: GestureDetector(
                //         onTap: () async {
                //           if (catList[index].subList == null ||
                //               catList[index].subList!.length == 0) {
                //             await Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => ProductList(
                //                     name: catList[index].name,
                //                     id: catList[index].id,
                //                     tag: false,
                //                     fromSeller: false,
                //                   ),
                //                 ));
                //           } else {
                //             await Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => SubCategory(
                //                     title: catList[index].name!,
                //                     subList: catList[index].subList,
                //                   ),
                //                 ));
                //           }
                //         },
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           mainAxisSize: MainAxisSize.min,
                //           children: <Widget>[
                //             CircleAvatar(
                //               radius: 30,
                //               backgroundImage: NetworkImage(
                //                 "${catList[index].image}",
                //
                //               ),
                //             ),
                //             // CircleAvatar(
                //             //   child: FadeInImage(
                //             //     fadeInDuration: Duration(milliseconds: 150),
                //             //     image: CachedNetworkImageProvider(
                //             //       catList[index].image!,
                //             //     ),
                //             //     height: 50.0,
                //             //     width: 50.0,
                //             //     fit: BoxFit.contain,
                //             //     imageErrorBuilder:
                //             //         (context, error, stackTrace) =>
                //             //         erroWidget(50),
                //             //     placeholder: placeHolder(50),
                //             //   ),
                //             // ),
                //             // Container(
                //             //   child: Text(
                //             //     catList[index].name!,
                //             //     style: Theme.of(context)
                //             //         .textTheme
                //             //         .caption!
                //             //         .copyWith(
                //             //             color: Theme.of(context)
                //             //                 .colorScheme
                //             //                 .fontColor,
                //             //             fontWeight: FontWeight.w600,
                //             //             fontSize: 10),
                //             //     overflow: TextOverflow.ellipsis,
                //             //     textAlign: TextAlign.center,
                //             //   ),
                //             //   width: 50,
                //             // ),
                //             Container(
                //               child: Text(
                //                 catList[index].name!.toUpperCase(),
                //                 style: Theme.of(context)
                //                     .textTheme
                //                     .caption!
                //                     .copyWith(
                //                     color: Theme.of(context)
                //                         .colorScheme
                //                         .fontColor,
                //                     fontWeight: FontWeight.w600,
                //                     fontSize: 11),
                //                 overflow: TextOverflow.ellipsis,
                //                 textAlign: TextAlign.center,
                //                 maxLines: 2,
                //               ),
                //               width: 70,
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                // },
              ),
            ),
          );
        }

      },
      selector: (_, homeProvider) => homeProvider.catLoading,
    );

    //   Selector<HomeProvider, bool>(
    //   builder: (context, data, child) {
    //     return data
    //         ? Container(
    //         width: double.infinity,
    //         child: Shimmer.fromColors(
    //             baseColor: Theme.of(context).colorScheme.simmerBase,
    //             highlightColor: Theme.of(context).colorScheme.simmerHigh,
    //             child: catLoading()))
    //         : Padding(
    //       padding: const EdgeInsets.only(left: 10.0, right: 0,top: 10),
    //       child:
    //     );
    //   },
    //   selector: (_, homeProvider) => homeProvider.catLoading,
    // );
  }
  _section() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? Container(
          width: double.infinity,
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.simmerBase,
            highlightColor: Theme.of(context).colorScheme.simmerHigh,
            child: sectionLoading(),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: sectionList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            print("here");
            if(sectionList[i].productList!.length == 0){
              return Container();
            }
            else{
              return  Column(
                children: [
                  _getHeading(sectionList[i].title ?? "", i),
                  Container(
                    height: 220,
                    child: ListView.builder(
                        itemCount: sectionList[i].productList!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (c,index){

                          if(sectionList[i].productList!.length > index){
                            String? offPer;
                            double price = double.parse(
                                sectionList[i].productList![index].prVarientList![0].disPrice!);
                            if (price == 0) {
                              price = double.parse(
                                  sectionList[i].productList![index].prVarientList![0].price!);
                            } else {
                              double off = double.parse(sectionList[i]
                                  .productList![index]
                                  .prVarientList![0]
                                  .price!) -
                                  price;
                              offPer = ((off * 100) /
                                  double.parse(sectionList[i]
                                      .productList![index]
                                      .prVarientList![0]
                                      .price!))
                                  .toStringAsFixed(2);
                            }
                            return InkWell(
                              onTap: () {
                                Product model = sectionList[i].productList![index];
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    // transitionDuration: Duration(milliseconds: 150),
                                    pageBuilder: (_,__, ___) => ProductDetail(
                                        model: model, secPos: i, index: index, list: false
                                      //  title: sectionList[secPos].title,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 160,
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height:135,
                                        width: 160,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)),
                                            child: Image.network("${sectionList[i].productList![index].image}",fit: BoxFit.fill,)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 4),
                                            Text("${sectionList[i].productList![index].name![0].toUpperCase() + sectionList[i].productList![index].name!.substring(1)}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                            SizedBox(height: 2,),
                                            Text(CUR_CURRENCY! + " " + price.toString(),style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              double.parse(sectionList[i]
                                                  .productList![index]
                                                  .prVarientList![0]
                                                  .disPrice!) !=
                                                  0
                                                  ? CUR_CURRENCY! +
                                                  "" +
                                                  sectionList[i]
                                                      .productList![index]
                                                      .prVarientList![0]
                                                      .price!
                                                  : "",
                                              style: TextStyle(decoration: TextDecoration.lineThrough),
                                            ),
                                            Text(
                                              " | " + "$offPer%",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline!
                                                  .copyWith(
                                                  color: colors.primary,
                                                  letterSpacing: 0,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          else{
                            return SizedBox.shrink();
                          }

                          //     if (sectionList[i].productList!.length > index) {
                          //       String? offPer;
                          //       double price = double.parse(
                          //           sectionList[i].productList![index].prVarientList![0].disPrice!);
                          //       if (price == 0) {
                          //         price = double.parse(
                          //             sectionList[i].productList![index].prVarientList![0].price!);
                          //       } else {
                          //         double off = double.parse(sectionList[i]
                          //             .productList![index]
                          //             .prVarientList![0]
                          //             .price!) -
                          //             price;
                          //         offPer = ((off * 100) /
                          //             double.parse(sectionList[i]
                          //                 .productList![index]
                          //                 .prVarientList![0]
                          //                 .price!))
                          //             .toStringAsFixed(2);
                          //       }
                          //
                          //       double width = deviceWidth! * 0.5;
                          //
                          //       return Card(
                          //         elevation: 0.0,
                          //         margin: EdgeInsetsDirectional.only(bottom: 2, end: 2),
                          //         //end: pad ? 5 : 0),
                          //         child: InkWell(
                          //           borderRadius: BorderRadius.circular(4),
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.min,
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: <Widget>[
                          //               Expanded(
                          //                 /*       child: ClipRRect(
                          // borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(5),
                          //     topRight: Radius.circular(5)),
                          // child: Hero(
                          //   tag:
                          //   "${sectionList[secPos].productList![index].id}$secPos$index",
                          //   child: FadeInImage(
                          //     fadeInDuration: Duration(milliseconds: 150),
                          //     image: NetworkImage(
                          //         sectionList[secPos].productList![index].image!),
                          //     height: double.maxFinite,
                          //     width: double.maxFinite,
                          //     fit: extendImg ? BoxFit.fill : BoxFit.contain,
                          //     imageErrorBuilder: (context, error, stackTrace) =>
                          //         erroWidget(width),
                          //
                          //     // errorWidget: (context, url, e) => placeHolder(width),
                          //     placeholder: placeHolder(width),
                          //   ),
                          // )),*/
                          //                 child: Stack(
                          //                   alignment: Alignment.topRight,
                          //                   children: [
                          //                     ClipRRect(
                          //                       borderRadius: BorderRadius.only(
                          //                           topLeft: Radius.circular(5),
                          //                           topRight: Radius.circular(5)),
                          //                       child: Hero(
                          //                         transitionOnUserGestures: true,
                          //                         tag:
                          //                         "${sectionList[i].productList![index].id}$i$index",
                          //                         child: FadeInImage(
                          //                           fadeInDuration: Duration(milliseconds: 150),
                          //                           image: CachedNetworkImageProvider(
                          //                               sectionList[i].productList![index].image!),
                          //                           height: double.maxFinite,
                          //                           width: double.maxFinite,
                          //                           imageErrorBuilder: (context, error, stackTrace) =>
                          //                               erroWidget(double.maxFinite),
                          //                           fit: BoxFit.contain,
                          //                           placeholder: placeHolder(width),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsetsDirectional.only(
                          //                   start: 5.0,
                          //                   top: 3,
                          //                 ),
                          //                 child: Text(
                          //                   sectionList[i].productList![index].name!,
                          //                   style: Theme.of(context).textTheme.caption!.copyWith(
                          //                       color: Theme.of(context).colorScheme.lightBlack),
                          //                   maxLines: 1,
                          //                   overflow: TextOverflow.ellipsis,
                          //                 ),
                          //               ),
                          //               Text(
                          //                 " " + CUR_CURRENCY! + " " + price.toString(),
                          //                 style: TextStyle(
                          //                     color: Theme.of(context).colorScheme.fontColor,
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: 15),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsetsDirectional.only(
                          //                     start: 5.0, bottom: 5, top: 3),
                          //                 child: double.parse(sectionList[i]
                          //                     .productList![index]
                          //                     .prVarientList![0]
                          //                     .disPrice!) !=
                          //                     0
                          //                     ? Row(
                          //                   children: <Widget>[
                          //                     Text(
                          //                       double.parse(sectionList[i]
                          //                           .productList![index]
                          //                           .prVarientList![0]
                          //                           .disPrice!) !=
                          //                           0
                          //                           ? CUR_CURRENCY! +
                          //                           "" +
                          //                           sectionList[i]
                          //                               .productList![index]
                          //                               .prVarientList![0]
                          //                               .price!
                          //                           : "",
                          //                       style: Theme.of(context)
                          //                           .textTheme
                          //                           .overline!
                          //                           .copyWith(
                          //                           decoration: TextDecoration.lineThrough,
                          //                           letterSpacing: 0,
                          //                           fontSize: 15,
                          //                           fontWeight: FontWeight.bold),
                          //                     ),
                          //                     Flexible(
                          //                       child: Text(
                          //                         " | " + "$offPer%",
                          //                         maxLines: 1,
                          //                         overflow: TextOverflow.ellipsis,
                          //                         style: Theme.of(context)
                          //                             .textTheme
                          //                             .overline!
                          //                             .copyWith(
                          //                             color: colors.primary,
                          //                             letterSpacing: 0,
                          //                             fontSize: 15,
                          //                             fontWeight: FontWeight.bold),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 )
                          //                     : Container(
                          //                   height: 5,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           onTap: () {
                          //             Product model = sectionList[i].productList![index];
                          //             Navigator.push(
                          //               context,
                          //               PageRouteBuilder(
                          //                 // transitionDuration: Duration(milliseconds: 150),
                          //                 pageBuilder: (_,__, ___) => ProductDetail(
                          //                     model: model, secPos: i, index: index, list: false
                          //                   //  title: sectionList[secPos].title,
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         ),
                          //       );
                          //     } else
                          //       return Container();
                          //productItem(i, index, index % 2 == 0 ? true : false);
                        }),
                  ),
                  SizedBox(height: 10,),
                  offerImages.length > i ? _getOfferImage(i) : Container(),
                ],
              );
            }

              //_singleSection(index);
          },
        );
      },
      selector: (_, homeProvider) => homeProvider.secLoading,
    );
  }

  getSubcat(){
    return  GetSub == null  ?CircularProgressIndicator(): Container(
      padding: const EdgeInsets.only(top: 10, left: 5,right: 5),
      child: ListView.builder(
        itemCount:GetSub!.data!.length,
        // scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
         shrinkWrap: true,
        itemBuilder: (context, i) {
          if (i == null)
            return Container();
          else
            return
               GetSub!.data![i].subcategories == null || GetSub!.data![i].subcategories!.length == 0? SizedBox.shrink():
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${GetSub!.data![i].name!.toUpperCase()}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    SizedBox(height: 10,),
                    Container(
                      child:   TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: Size.zero, //
                            backgroundColor: colors.primary,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                        child: Text(
                          getTranslated(context, 'VIEW_ALL')!.toUpperCase(),
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Theme.of(context).colorScheme.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllSubCategory(title: GetSub!.data![i].name,subCat: GetSub!.data![i].subcategories,)));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => SubCategory(
                          //         subList: GetSub!.data![i].,
                          //         title: GetSub!.data![i].name ?? "",
                          //       ),
                          //     ));
                          //Navigator.push(context,MaterialPageRoute(builder: (context) => SubCategory(title: title)));
                          // SectionModel model = sectionList[index];
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => SectionList(
                          //       index: index,
                          //       section_model: model,
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
                  InkWell(
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
                    },
                    child: Container(
                       height: GetSub!.data![i].subcategories!.length >3? 280:140,
                      child:
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 2,
                            crossAxisCount: 3,
                            childAspectRatio: 0.86
                          ),
                          itemCount:GetSub!.data![i].subcategories!.length > 6 ? 6 : GetSub!.data![i].subcategories!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return  GestureDetector(
                              onTap: () async {
                                {
                                  // print('_______this is id${ GetSub!.data![index].subcategories![index]?.id}');
                                  // print('_______this is name${ GetSub?.data![i].name}');
                                  print('_______this is name${GetSub!.data![i].subcategories![index].id}');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductList(
                                          name: GetSub!.data![i].subcategories![index].name.toString(),
                                          id: GetSub!.data![i].subcategories![index].id,
                                          tag: false,
                                          fromSeller: false,
                                        ),
                                      ));
                                }
                                // else {
                                //   await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => SubCategory(
                                //         title: catList[index].name!,
                                //         subList: catList[index].subList,
                                //       ),
                                //     ),
                                //   );
                                // }
                              },
                              child: Card(
                                child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 125,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                                height: 101,
                                              width: double.infinity,
                                              // decoration: BoxDecoration(
                                              //   borderRadius: BorderRadius.circular(10)
                                              // ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5)),
                                                  child: Image.network("${GetSub!.data![i].subcategories![index].image}",fit: BoxFit.fill,))),
                                          SizedBox(height: 5,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10,right: 10),
                                            child: Text(
                                              GetSub!.data![i].subcategories![index].name!.toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .fontColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),

                                    ),

                                    // CircleAvatar(
                                    //   child: FadeInImage(
                                    //     fadeInDuration: Duration(milliseconds: 150),
                                    //     image: CachedNetworkImageProvider(
                                    //       catList[index].image!,
                                    //     ),
                                    //     height: 50.0,
                                    //     width: 50.0,
                                    //     fit: BoxFit.contain,
                                    //     imageErrorBuilder:
                                    //         (context, error, stackTrace) =>
                                    //         erroWidget(50),
                                    //     placeholder: placeHolder(50),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   child: Text(
                                    //     catList[index].name!,
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .caption!
                                    //         .copyWith(
                                    //             color: Theme.of(context)
                                    //                 .colorScheme
                                    //                 .fontColor,
                                    //             fontWeight: FontWeight.w600,
                                    //             fontSize: 10),
                                    //     overflow: TextOverflow.ellipsis,
                                    //     textAlign: TextAlign.center,
                                    //   ),
                                    //   width: 50,
                                    // ),

                                  ],
                                ),
                              )


                            );
                          }
                      ),

                      // ListView.builder(
                      //   itemCount:GetSub!.data![index].subcategories!.length,
                      //   scrollDirection: Axis.horizontal,
                      //   shrinkWrap: true,
                      //   physics: AlwaysScrollableScrollPhysics(),
                      //   itemBuilder: (context, i) {
                      //     if (index == 0)
                      //       return Container();
                      //     else
                      //       return
                      //         // Text("${GetSub!.data![index].subcategories![i].name}");
                      //       Padding(
                      //       padding: const EdgeInsetsDirectional.only(end: 10),
                      //       child: GestureDetector(
                      //         onTap: () async {
                      //           {
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) => ProductList(
                      //                     name: GetSub!.data![index].subcategories![i].name.toString(),
                      //                     id: GetSub!.data![index].id.toString(),
                      //                     tag: false,
                      //                     fromSeller: false,
                      //                   ),
                      //                 ));
                      //           }
                      //           // else {
                      //           //   await Navigator.push(
                      //           //     context,
                      //           //     MaterialPageRoute(
                      //           //       builder: (context) => SubCategory(
                      //           //         title: catList[index].name!,
                      //           //         subList: catList[index].subList,
                      //           //       ),
                      //           //     ),
                      //           //   );
                      //           // }
                      //         },
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Container(
                      //               height: 150,
                      //               child: Column(
                      //                 children: [
                      //                   Image.network("${GetSub!.data![index].subcategories![i].image}")
                      //                 ],
                      //               ),
                      //
                      //             ),
                      //
                      //             // CircleAvatar(
                      //             //   child: FadeInImage(
                      //             //     fadeInDuration: Duration(milliseconds: 150),
                      //             //     image: CachedNetworkImageProvider(
                      //             //       catList[index].image!,
                      //             //     ),
                      //             //     height: 50.0,
                      //             //     width: 50.0,
                      //             //     fit: BoxFit.contain,
                      //             //     imageErrorBuilder:
                      //             //         (context, error, stackTrace) =>
                      //             //         erroWidget(50),
                      //             //     placeholder: placeHolder(50),
                      //             //   ),
                      //             // ),
                      //             // Container(
                      //             //   child: Text(
                      //             //     catList[index].name!,
                      //             //     style: Theme.of(context)
                      //             //         .textTheme
                      //             //         .caption!
                      //             //         .copyWith(
                      //             //             color: Theme.of(context)
                      //             //                 .colorScheme
                      //             //                 .fontColor,
                      //             //             fontWeight: FontWeight.w600,
                      //             //             fontSize: 10),
                      //             //     overflow: TextOverflow.ellipsis,
                      //             //     textAlign: TextAlign.center,
                      //             //   ),
                      //             //   width: 50,
                      //             // ),
                      //             Container(
                      //               child: Text(
                      //                   GetSub!.data![index].subcategories![i].name!.toUpperCase(),
                      //                 style: Theme.of(context)
                      //                     .textTheme
                      //                     .caption!
                      //                     .copyWith(
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .fontColor,
                      //                     fontWeight: FontWeight.w600,
                      //                     fontSize: 11),
                      //                 overflow: TextOverflow.ellipsis,
                      //                 textAlign: TextAlign.center,
                      //                 maxLines: 2,
                      //               ),
                      //               width: 70,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ),
                  ),
                ],
              ),
            );

              //   Padding(
            //   padding: const EdgeInsetsDirectional.only(end: 10),
            //   child: GestureDetector(
            //     // onTap: () async {
            //     //   if (catList[index].subList == null ||
            //     //       catList[index].subList!.length == 0) {
            //     //     await Navigator.push(
            //     //         context,
            //     //         MaterialPageRoute(
            //     //           builder: (context) => ProductList(
            //     //             name: catList[index].name,
            //     //             id: catList[index].id,
            //     //             tag: false,
            //     //             fromSeller: false,
            //     //           ),
            //     //         ));
            //     //   } else {
            //     //     await Navigator.push(
            //     //       context,
            //     //       MaterialPageRoute(
            //     //         builder: (context) => SubCategory(
            //     //           title: catList[index].name!,
            //     //           subList: catList[index].subList,
            //     //         ),
            //     //       ),
            //     //     );
            //     //   }
            //     // },
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       mainAxisSize: MainAxisSize.min,
            //       children: <Widget>[
            //         CircleAvatar(
            //           radius: 30,
            //           backgroundImage: NetworkImage(
            //             "${GetSub!.data![index].image}",
            //           ),
            //         ),
            //         // CircleAvatar(
            //         //   child: FadeInImage(
            //         //     fadeInDuration: Duration(milliseconds: 150),
            //         //     image: CachedNetworkImageProvider(
            //         //       catList[index].image!,
            //         //     ),
            //         //     height: 50.0,
            //         //     width: 50.0,
            //         //     fit: BoxFit.contain,
            //         //     imageErrorBuilder:
            //         //         (context, error, stackTrace) =>
            //         //         erroWidget(50),
            //         //     placeholder: placeHolder(50),
            //         //   ),
            //         // ),
            //         // Container(
            //         //   child: Text(
            //         //     catList[index].name!,
            //         //     style: Theme.of(context)
            //         //         .textTheme
            //         //         .caption!
            //         //         .copyWith(
            //         //             color: Theme.of(context)
            //         //                 .colorScheme
            //         //                 .fontColor,
            //         //             fontWeight: FontWeight.w600,
            //         //             fontSize: 10),
            //         //     overflow: TextOverflow.ellipsis,
            //         //     textAlign: TextAlign.center,
            //         //   ),
            //         //   width: 50,
            //         // ),
            //         Container(
            //           child: Text(
            //             GetSub!.data![index].name!.toUpperCase(),
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .caption!
            //                 .copyWith(
            //                 color: Theme.of(context)
            //                     .colorScheme
            //                     .fontColor,
            //                 fontWeight: FontWeight.w600,
            //                 fontSize: 11),
            //             overflow: TextOverflow.ellipsis,
            //             textAlign: TextAlign.center,
            //             maxLines: 2,
            //           ),
            //           width: 70,
            //         ),
            //       ],
            //     ),
            //   ),
            // );
        },
      ),
    );
  }
  _catList() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? Container(
                width: double.infinity,
                child: Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.simmerBase,
                    highlightColor: Theme.of(context).colorScheme.simmerHigh,
                    child: catLoading()))
            : Container(
                height: 100,
                padding: EdgeInsets.only(top: 10, left: 10),
                child: ListView.builder(
                  itemCount: catList.length < 10 ? catList.length : 10,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == null)
                      return Container();
                    else
                      return Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: GestureDetector(
                          onTap: () async {
                            if (catList[index].subList == null ||
                                catList[index].subList!.length == 0) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductList(
                                      name: catList[index].name,
                                      id: catList[index].id,
                                      tag: false,
                                      fromSeller: false,
                                    ),
                                  ));
                            } else {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubCategory(
                                    title: catList[index].name!,
                                    subList: catList[index].subList,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  "${catList[index].image}",
                                ),
                              ),
                              // CircleAvatar(
                              //   child: FadeInImage(
                              //     fadeInDuration: Duration(milliseconds: 150),
                              //     image: CachedNetworkImageProvider(
                              //       catList[index].image!,
                              //     ),
                              //     height: 50.0,
                              //     width: 50.0,
                              //     fit: BoxFit.contain,
                              //     imageErrorBuilder:
                              //         (context, error, stackTrace) =>
                              //         erroWidget(50),
                              //     placeholder: placeHolder(50),
                              //   ),
                              // ),
                              // Container(
                              //   child: Text(
                              //     catList[index].name!,
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .caption!
                              //         .copyWith(
                              //             color: Theme.of(context)
                              //                 .colorScheme
                              //                 .fontColor,
                              //             fontWeight: FontWeight.w600,
                              //             fontSize: 10),
                              //     overflow: TextOverflow.ellipsis,
                              //     textAlign: TextAlign.center,
                              //   ),
                              //   width: 50,
                              // ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text(
                                    catList[index].name!.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .fontColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                                width: 60,
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                ),
              );
      },
      selector: (_, homeProvider) => homeProvider.catLoading,
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  Future<Null> callApi() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    SettingProvider setting =
        Provider.of<SettingProvider>(context, listen: false);
    user.setUserId(setting.userId);
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getSetting();
      getSlider();
      getCat();
      //getSeller();
      getSection();
      getOfferImages();
      getScbCate();
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
    return null;
  }

  Future _getFav() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      if (CUR_USERID != null) {
        Map parameter = {
          USER_ID: CUR_USERID,
        };
        apiBaseHelper.postAPICall(getFavApi, parameter).then((getdata) {
          bool error = getdata["error"];
          String? msg = getdata["message"];
          if (!error) {
            var data = getdata["data"];

            List<Product> tempList = (data as List)
                .map((data) => new Product.fromJson(data))
                .toList();

            context.read<FavoriteProvider>().setFavlist(tempList);
          } else {
            if (msg != 'No Favourite(s) Product Are Added')
              setSnackbar(msg!, context);
          }

          context.read<FavoriteProvider>().setLoading(false);
        }, onError: (error) {
          setSnackbar(error.toString(), context);
          context.read<FavoriteProvider>().setLoading(false);
        });
      } else {
        context.read<FavoriteProvider>().setLoading(false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  void getOfferImages() {
    Map parameter = Map();

    apiBaseHelper.postAPICall(getOfferImageApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        offerImages.clear();
        offerImages =
            (data as List).map((data) => new Model.fromSlider(data)).toList();
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setOfferLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setOfferLoading(false);
    });
  }

  void getSection() {
    // Map parameter = {PRODUCT_LIMIT: "5", PRODUCT_OFFSET: "6"};
    Map parameter = {PRODUCT_LIMIT: "5"};

    if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID!;
    String curPin = context.read<UserProvider>().curPincode;
    if (curPin != '') parameter[ZIPCODE] = curPin;

    apiBaseHelper.postAPICall(getSectionApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      print("Get Section Data---------: $getdata");
      print(getSectionApi.toString());
      print(parameter.toString());
      sectionList.clear();
      if (!error) {
        var data = getdata["data"];
        print("Get Section Data2: $data");
        sectionList = (data as List)
            .map((data) => new SectionModel.fromJson(data))
            .toList();
      } else {
        if (curPin != '') context.read<UserProvider>().setPincode('');
        setSnackbar(msg!, context);
        print("Get Section Error Msg: $msg");
      }
      context.read<HomeProvider>().setSecLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSecLoading(false);
    });
  }

  void getSetting() {
    CUR_USERID = context.read<SettingProvider>().userId;
    //print("")
    Map parameter = Map();
    if (CUR_USERID != null) parameter = {USER_ID: CUR_USERID};

    apiBaseHelper.postAPICall(getSettingApi, parameter).then((getdata) async {
      bool error = getdata["error"];
      String? msg = getdata["message"];

      print("Get Setting Api${getSettingApi.toString()}");
      print("parametereerererererer ${parameter.toString()}");

      if (!error) {
        var data = getdata["data"]["system_settings"][0];
        cartBtnList = data["cart_btn_on_list"] == "1" ? true : false;
        refer = data["is_refer_earn_on"] == "1" ? true : false;
        CUR_CURRENCY = data["currency"];
        RETURN_DAYS = data['max_product_return_days'];
        MAX_ITEMS = data["max_items_cart"];
        MIN_AMT = data['min_amount'];
        CUR_DEL_CHR = data['delivery_charge'];
        String? isVerion = data['is_version_system_on'];
        extendImg = data["expand_product_images"] == "1" ? true : false;
        String? del = data["area_wise_delivery_charge"];
        MIN_ALLOW_CART_AMT = data[MIN_CART_AMT];

        if (del == "0")
          ISFLAT_DEL = true;
        else
          ISFLAT_DEL = false;

        if (CUR_USERID != null) {
          REFER_CODE = getdata['data']['user_data'][0]['referral_code'];

          context
              .read<UserProvider>()
              .setPincode(getdata["data"]["user_data"][0][PINCODE]);

          if (REFER_CODE == null || REFER_CODE == '' || REFER_CODE!.isEmpty)
            generateReferral();

          context.read<UserProvider>().setCartCount(
              getdata["data"]["user_data"][0]["cart_total_items"].toString());
          context
              .read<UserProvider>()
              .setBalance(getdata["data"]["user_data"][0]["balance"]);

          _getFav();
          _getCart("0");
        }

        UserProvider user = Provider.of<UserProvider>(context, listen: false);
        SettingProvider setting =
            Provider.of<SettingProvider>(context, listen: false);
        user.setMobile(setting.mobile);
        user.setName(setting.userName);
        user.setEmail(setting.email);
        user.setProfilePic(setting.profileUrl);

        Map<String, dynamic> tempData = getdata["data"];
        if (tempData.containsKey(TAG))
          tagList = List<String>.from(getdata["data"][TAG]);

        if (isVerion == "1") {
          String? verionAnd = data['current_version'];
          String? verionIOS = data['current_version_ios'];

          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String version = packageInfo.version;
          final Version currentVersion = Version.parse(version);
          final Version latestVersionAnd = Version.parse(verionAnd.toString());
          final Version latestVersionIos = Version.parse(verionIOS.toString());

          if ((Platform.isAndroid && latestVersionAnd > currentVersion) ||
              (Platform.isIOS && latestVersionIos > currentVersion))
            updateDailog();
        }
      } else {
        setSnackbar(msg!, context);
      }
    }, onError: (error) {
      setSnackbar(error.toString(), context);
    });
  }

  Future<void> _getCart(String save) async {
    _isNetworkAvail = await isNetworkAvailable();

    if (_isNetworkAvail) {
      try {
        var parameter = {USER_ID: CUR_USERID, SAVE_LATER: save};

        Response response =
            await post(getCartApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));
        print("this is cate=====${getCartApi.toString()}");
        print(getCartApi.toString());

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];

          List<SectionModel> cartList = (data as List)
              .map((data) => new SectionModel.fromCart(data))
              .toList();
          context.read<CartProvider>().setCartlist(cartList);
        }
      } on TimeoutException catch (_) {}
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<Null> generateReferral() async {
    String refer = getRandomString(8);

    Map parameter = {
      REFERCODE: refer,
    };

    apiBaseHelper.postAPICall(validateReferalApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        REFER_CODE = refer;

        Map parameter = {
          USER_ID: CUR_USERID,
          REFERCODE: refer,
        };

        apiBaseHelper.postAPICall(getUpdateUserApi, parameter);
      } else {
        if (count < 5) generateReferral();
        count++;
      }

      context.read<HomeProvider>().setSecLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSecLoading(false);
    });
  }

  updateDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Text(getTranslated(context, 'UPDATE_APP')!),
        content: Text(
          getTranslated(context, 'UPDATE_AVAIL')!,
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
              onPressed: () async {
                Navigator.of(context).pop(false);

                String _url = '';
                if (Platform.isAndroid) {
                  _url = androidLink + packageName;
                } else if (Platform.isIOS) {
                  _url = iosLink;
                }

                if (await canLaunch(_url)) {
                  await launch(_url);
                } else {
                  throw 'Could not launch $_url';
                }
              })
        ],
      );
    }));
  }

  Widget homeShimmer() {
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: SingleChildScrollView(
            child: Column(
          children: [
            catLoading(),
            sliderLoading(),
            sectionLoading(),
          ],
        )),
      ),
    );
  }

  Widget sliderLoading() {
    double width = deviceWidth!;
    double height = width / 2;
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: height,
          color: Theme.of(context).colorScheme.white,
        ));
  }

  Widget _buildImagePageItem(Model slider) {
    double height = deviceWidth! / 0.5;

    return GestureDetector(
      child: FadeInImage(
          fadeInDuration: Duration(milliseconds: 150),
          image: CachedNetworkImageProvider(slider.image!),
          height: height,
          width: double.maxFinite,
          fit: BoxFit.contain,
          imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/sliderph.png",
                fit: BoxFit.contain,
                height: height,
                color: colors.primary,
              ),
          placeholderErrorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/sliderph.png",
                fit: BoxFit.contain,
                height: height,
                color: colors.primary,
              ),
          placeholder: AssetImage(imagePath + "sliderph.png")),
      onTap: () async {
        int curSlider = context.read<HomeProvider>().curSlider;

        if (homeSliderList[curSlider].type == "products") {
          Product? item = homeSliderList[curSlider].list;

          Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => ProductDetail(
                    model: item, secPos: 0, index: 0, list: true)),
          );
        } else if (homeSliderList[curSlider].type == "categories") {
          Product item = homeSliderList[curSlider].list;
          if (item.subList == null || item.subList!.length == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    name: item.name,
                    id: item.id,
                    tag: false,
                    fromSeller: false,
                  ),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategory(
                    title: item.name!,
                    subList: item.subList,
                  ),
                ));
          }
        }
      },
    );
  }

  Widget deliverLoading() {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          height: 18.0,
          color: Theme.of(context).colorScheme.white,
        ));
  }

  Widget catLoading() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                    .map((_) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.white,
                            shape: BoxShape.circle,
                          ),
                          width: 50.0,
                          height: 50.0,
                        ))
                    .toList()),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          height: 18.0,
          color: Theme.of(context).colorScheme.white,
        ),
      ],
    );
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              context.read<HomeProvider>().setCatLoading(true);
              context.read<HomeProvider>().setSecLoading(true);
              context.read<HomeProvider>().setSliderLoading(true);
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  if (mounted)
                    setState(() {
                      _isNetworkAvail = true;
                    });
                  callApi();
                } else {
                  await buttonController.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  _deliverPincode() {
    // String curpin = context.read<UserProvider>().curPincode;
    return GestureDetector(
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 8),
        color: Theme.of(context).colorScheme.white,
        child: ListTile(
          dense: true,
          minLeadingWidth: 10,
          leading: Icon(
            Icons.location_pin,
          ),
          title: Selector<UserProvider, String>(
            builder: (context, data, child) {
              return Text(
                data == ''
                    ? getTranslated(context, 'SELOC')!
                    : getTranslated(context, 'DELIVERTO')! + data,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.fontColor),
              );
            },
            selector: (_, provider) => provider.curPincode,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
      onTap: _pincodeCheck,
    );
  }

  void _pincodeCheck() {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: ListView(shrinkWrap: true, children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, bottom: 40, top: 30),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                textCapitalization: TextCapitalization.words,
                                validator: (val) => validatePincode(val!,
                                    getTranslated(context, 'PIN_REQUIRED')),
                                onSaved: (String? value) {
                                  context
                                      .read<UserProvider>()
                                      .setPincode(value!);
                                },
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor),
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: Icon(Icons.location_on),
                                  labelText:
                                      getTranslated(context, 'PINCODEHINT_LBL'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsetsDirectional.only(start: 20),
                                      width: deviceWidth! * 0.35,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          context
                                              .read<UserProvider>()
                                              .setPincode('');

                                          context
                                              .read<HomeProvider>()
                                              .setSecLoading(true);
                                          getSection();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            getTranslated(context, 'All')!),
                                      ),
                                    ),
                                    Spacer(),
                                    SimBtn(
                                        size: 0.35,
                                        title: getTranslated(context, 'APPLY'),
                                        onBtnSelected: () async {
                                          if (validateAndSave()) {
                                            // validatePin(curPin);
                                            context
                                                .read<HomeProvider>()
                                                .setSecLoading(true);
                                            getSection();

                                            // context
                                            //     .read<HomeProvider>()
                                            //     .setSellerLoading(true);
                                            // sellerList.clear();
                                            // getSeller();
                                            Navigator.pop(context);
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ))
              ]),
            );
            //});
          });
        });
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;

    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  void getSlider() {
    Map map = Map();
    apiBaseHelper.postAPICall(getSliderApi, map).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      print(getSliderApi.toString());
      if (!error) {
        var data = getdata["data"];

        homeSliderList =
            (data as List).map((data) => new Model.fromSlider(data)).toList();

        pages = homeSliderList.map((slider) {
          return _buildImagePageItem(slider);
        }).toList();
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSliderLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSliderLoading(false);
    });
  }

  getCat() {
    print("working here ");
    Map parameter = {
      CAT_FILTER: "false",
    };
    apiBaseHelper.postAPICall(getCatApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      print("Surendra=============${getCatApi.toString()}");
      print(parameter.toString());
      if (!error) {
        print("yes now easy");
        var data = getdata["data"];
        catList =
            (data as List).map((data) => new Product.fromCat(data)).toList();
        if (getdata.containsKey("popular_categories")) {
          var data = getdata["popular_categories"];
          popularList =
              (data as List).map((data) => new Product.fromCat(data)).toList();
          print("product list here ${popularList}");
          if (popularList.length > 0) {
            Product pop =
                new Product.popular("Popular", imagePath + "popular.svg");
            catList.insert(0, pop);
            context.read<CategoryProvider>().setSubList(popularList);
          }
        }
        setState(() {

        });
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setCatLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setCatLoading(false);
    });
  }

  sectionLoading() {
    return Column(
        children: [0, 1, 2, 3, 4]
            .map((_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 40),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                width: double.infinity,
                                height: 18.0,
                                color: Theme.of(context).colorScheme.white,
                              ),
                              GridView.count(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                childAspectRatio: 1.0,
                                physics: NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                children: List.generate(
                                  4,
                                  (index) {
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color:
                                          Theme.of(context).colorScheme.white,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    sliderLoading()
                    //offerImages.length > index ? _getOfferImage(index) : Container(),
                  ],
                ))
            .toList());
  }

  void getSeller() {
    String pin = context.read<UserProvider>().curPincode;
    Map parameter = {};
    if (pin != '') {
      parameter = {
        ZIPCODE: pin,
      };
    }

    apiBaseHelper.postAPICall(getSellerApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        print("Seller Parameter =========> $parameter");
        print("Seller Data=====================> : $data ");
        sellerList =
            (data as List).map((data) => new Product.fromSeller(data)).toList();
      } else {
        setSnackbar(msg!, context);
      }
      context.read<HomeProvider>().setSellerLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSellerLoading(false);
    });
  }

  _seller() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? Container(
                width: double.infinity,
                child: Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.simmerBase,
                    highlightColor: Theme.of(context).colorScheme.simmerHigh,
                    child: catLoading()))
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sellerList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated(context, 'SHOP_BY_SELLER')!,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                      fontWeight: FontWeight.bold)),
                              GestureDetector(
                                child:
                                    Text(getTranslated(context, 'VIEW_ALL')!),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SellerList()));
                                },
                              )
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: ListView.builder(
                      itemCount: sellerList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(end: 10),
                          child: GestureDetector(
                            onTap: () {
                              print(sellerList[index].open_close_status);
                              if (sellerList[index].open_close_status == '1') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SellerProfile(
                                              sellerStoreName: sellerList[index]
                                                      .store_name ??
                                                  "",
                                              sellerRating: sellerList[index]
                                                      .seller_rating ??
                                                  "",
                                              sellerImage: sellerList[index]
                                                      .seller_profile ??
                                                  "",
                                              sellerName: sellerList[index]
                                                      .seller_name ??
                                                  "",
                                              sellerID:
                                                  sellerList[index].seller_id,
                                              storeDesc: sellerList[index]
                                                  .store_description,
                                            )));
                              } else {
                                showToast("Currently Store is Off");
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      bottom: 5.0),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        "${sellerList[index].seller_profile!}"),
                                  ),

                                  // new ClipRRect(
                                  //   borderRadius: BorderRadius.circular(25.0),
                                  //   child: new FadeInImage(
                                  //     fadeInDuration:
                                  //         Duration(milliseconds: 150),
                                  //     image: CachedNetworkImageProvider(
                                  //       sellerList[index].seller_profile!,
                                  //     ),
                                  //     height: 50.0,
                                  //     width: 50.0,
                                  //     fit: BoxFit.contain,
                                  //     imageErrorBuilder:
                                  //         (context, error, stackTrace) =>
                                  //             erroWidget(50),
                                  //     placeholder: placeHolder(50),
                                  //   ),
                                  // ),
                                ),
                                Container(
                                  child: Text(
                                    sellerList[index].seller_name!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .fontColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
      },
      selector: (_, homeProvider) => homeProvider.sellerLoading,
    );
  }
}


import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:flutter/material.dart';

import '../Model/GetSubCatModel.dart';
import 'ProductList.dart';

class ViewAllSubCategory extends StatefulWidget {
  final String? title;
  final List<Subcategories>? subCat;
  ViewAllSubCategory({this.title,this.subCat});

  @override
  State<ViewAllSubCategory> createState() => _ViewAllSubCategoryState();
}

class _ViewAllSubCategoryState extends State<ViewAllSubCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(widget.title.toString(), context),
      body: GridView.count(
          padding: EdgeInsets.all(20),
          crossAxisCount: 3,
          shrinkWrap: true,
          childAspectRatio: .75,
          children: List.generate(
            widget.subCat!.length,
                (index) {
              return subCatItem(index, context);
            },
          )),
    );
  }
  subCatItem(int index, BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage(
                    image: CachedNetworkImageProvider(widget.subCat![index].image!),
                    fit: BoxFit.fill,
                    fadeInDuration: Duration(milliseconds: 150),
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(50),
                    placeholder: placeHolder(50),
                  )),
            ),
          ),
          Text(
            widget.subCat![index].name! + "\n",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
          )
        ],
      ),
      onTap: () {
        // if (widget.subCat![index] == null ||
        //     widget.subCat![index].subList!.length == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductList(
                  name: widget.subCat![index].name,
                  id: widget.subCat![index].id,
                  tag: false,
                  fromSeller: false,
                ),
              ));
       // }
        // else {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => SubCategory(
        //           subList: subList![index].subList,
        //           title: subList![index].name ?? "",
        //         ),
        //       ));
        // }
      },
    );
  }
}

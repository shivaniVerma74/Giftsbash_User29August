import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Row(
        children: <Widget>[
          Container(
            height: 20.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _item.isSelected!
                    ? colors.primary
                    : Theme.of(context).colorScheme.white,
                border: Border.all(color: colors.grad2Color)),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: _item.isSelected!
                  ? Icon(
                      Icons.check,
                      size: 15.0,
                      color: Theme.of(context).colorScheme.white,
                    )
                  : Icon(
                      Icons.circle,
                      size: 15.0,
                      color: Theme.of(context).colorScheme.white,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 15.0),
            child: new Text(_item.name!),
          ),
          SizedBox(width: 10,),
        _item.delivery == null || _item.delivery == '' ? SizedBox.shrink() :
        Text("(\u{20B9}${_item.delivery})"),
          Spacer(),
          _item.img != ""
              ? SvgPicture.asset(
                  _item.img!,

                )
              : Container()
        ],
      ),
    );
  }
}

class RadioModel {
  bool? isSelected;
  final String? img;
  final String? name;
  final String? id;
  final String? del;
  final String? delivery;


  RadioModel({this.isSelected, this.name, this.img, this.id,this.del,this.delivery});
}

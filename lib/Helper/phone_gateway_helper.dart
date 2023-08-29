import 'dart:convert';

import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:phonepe_gateway/model/phonepe_config.dart';
import 'package:phonepe_gateway/model/phonepe_params_upi.dart';
import 'package:phonepe_gateway/phonepe_ui.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/UserProvider.dart';
import 'String.dart';

class PhonepeGatewayHelper{
  String amount;

  ValueChanged onResult;
  BuildContext context1;
  PhonepeGatewayHelper({required this.amount,required this.context1,required this.onResult});

    String  marchantTransactionId = "";
  void init(){
      marchantTransactionId = DateTime.now().millisecondsSinceEpoch.toString();
      var userProvider = Provider.of<UserProvider>(context1, listen: false);
      PhonpePaymentGateway.instance.init(
          config: PhonePeConfig(
              redirectUrl: "https://giftsbash.com/app/v1/api/",
              baseUrl: "https://giftsbash.com/app/v1/api/",
              appName: appName,
              callBackUrl:
              "https://webhook.site/5bc1de03-f570-4bec-9673-89f6e1d7dc3e",
              merchanId: "GIFTSBASHONLINE",
              saltIndex: 1,
              saltKey: "67be6e79-1453-469c-b118-9f1b25a75609"));
      PhonpePaymentGateway.instance.handlerCancelled(
            (value) {
          debugPrint("Cancelled :${jsonEncode(value.toJson())}");
        },
      );
      PhonpePaymentGateway.instance.handlerFailed(
            (value) {
          debugPrint("Failed :${jsonEncode(value.toJson())}");
        },
      );

      PhonpePaymentGateway.instance.handlerSuccess(
            (value) {
          debugPrint("Success :${jsonEncode(value.toJson())}");
        },
      );
      PhonpePaymentGateway.instance.initPayment(context1,
          params: ParamsPayment(
              amount: 100,
              merchantTransactionId:
              marchantTransactionId,
              merchantUserId: CUR_USERID!,
              mobileNumber: userProvider.mob,
              notes: {
                "uid": "1234567890",
                "name": "Test User",
                "email": "example#example.com"
              }
              ));
  }
}
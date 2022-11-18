import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getFormattedDate(DateTime dateTime, {String pattern = 'dd/MM/yyyy'}) {
  return DateFormat(pattern).format(dateTime);
}
void showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));


Future<bool> isConnectedToInternet() async{
  var result = await (Connectivity().checkConnectivity());
  return result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
}

String getPriceAfterDiscount(num price, num discount){
  return (price-(price*discount)/100).toStringAsFixed(0);
}

String get generateOrderId =>
    'PB_${getFormattedDate(DateTime.now(), pattern: 'yyyyMMdd_HH:mm:ss')}';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils{
  static void toast(String msg,{Color backgroundColor = Colors.black}){
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: backgroundColor,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
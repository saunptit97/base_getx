import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:store_redirect/store_redirect.dart';
import 'dart:math';
import 'dart:developer' as Log;

/// Created by daewubintara on
/// 09, September 2020 11.03

///
/// --------------------------------------------
/// There are many amazing [Function]s in this class.
/// Especialy in [Function]ality.
/// You can find and use on your Controller wich is the Controller extends [BaseController].
class Utilities {
  static Future<void> callPhoneNumber({String phone = "0"}) async {
    await launch("tel://$phone");
  }

  static Future<void> web({String link = "https://google.com"}) async {
    final url = link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openClassin(
      {String link = "https://share.classin.com"}) async {
    String defaultCalssinLink = "https://share.classin.com";
    final url = link;
    var splited = link.split("=");
    var classinLink = "classin://www.eeo.cn/enterclass?openClassId=" +
        splited[splited.length - 1];

    if (await canLaunch(classinLink)) {
      await launch(classinLink);
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        final appId = Platform.isAndroid ? 'cn.eeo.classin' : '1226361488';
        final url = (Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/$appId");
        if (Platform.isIOS) {
          StoreRedirect.redirect(
              androidAppId: "cn.eeo.classin", iOSAppId: "1226361488");
        } else {
          await launch(url);

          // if (await canLaunch(link)) {
          //   await launch(link);
          // } else {
          //   throw 'Could not launch $url';
          // }
        }
      }
    }
  }

  String rupiahFormater(String? value) {
    value ??= "0";

    double amount = double.parse(value);
    // FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: amount);
    // String c = fmf.output.nonSymbol.toString().replaceAll(".00", "");
    // String fix = "Rp. " + c.replaceAll(",", ".");
    return value;
  }

  static String moneyFormater(String value) {
    if (value == null || value == 'null') {
      value = "0";
    }

    double amount = double.parse(value);
    // FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: amount);
    // String c = fmf.output.nonSymbol.toString().replaceAll(".00", "");
    // String fix = "" + c.replaceAll(",", ".");
    return value;
  }

  static String formattedDate({
    String? format = 'dd MMMM yyyy',
    String? date,
  }) {
    try {
      if (date == null || date == 'null') {
        return "";
      }
      String formattedDate = DateFormat(format).format(DateTime.parse(date));
      return formattedDate;
    } catch (e) {
      return DateFormat(format).format(DateTime.parse(
        DateTime.now().toString(),
      ));
    }
  }

  String formattedDateGetDay({
    required String format,
    required String date,
  }) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('EEEE').format(dateTime);
    switch (formattedDate) {
      case "Monday":
        formattedDate = "T2";
        break;
      case "Tuesday":
        formattedDate = "T3";
        break;
      case "Wednesday":
        formattedDate = "T4";
        break;
      case "Thursday":
        formattedDate = "T5";
        break;
      case "Friday":
        formattedDate = "T6";
        break;
      case "Saturday":
        formattedDate = "T7";
        break;
      case "Sunday":
        formattedDate = "CN";
        break;
    }

    return formattedDate;
  }

  String formattedDateGetMonth({required String format, String? date}) {
    if (date == null) {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('MMMM').format(dateTime);
    switch (formattedDate) {
      case "January":
        formattedDate = "Januari";
        break;
      case "February":
        formattedDate = "Februari";
        break;
      case "March":
        formattedDate = "Maret";
        break;
      case "April":
        formattedDate = "April";
        break;
      case "May":
        formattedDate = "Mei";
        break;
      case "June":
        formattedDate = "Juni";
        break;
      case "July":
        formattedDate = "Juli";
        break;
      case "August":
        formattedDate = "Agustus";
        break;
      case "September":
        formattedDate = "September";
        break;
      case "October":
        formattedDate = "Oktober";
        break;
      case "November":
        formattedDate = "November";
        break;
      case "December":
        formattedDate = "Desember";
        break;
    }

    return formattedDate;
  }

  String formattedSimpleDate({String? format, String? date}) {
    if (date == null) {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  }

  String stringCardFormated(
      {String value = "", int splitOn = 3, String modelSplit = " "}) {
    String newValue = "Error Formating";
    if (value.length < splitOn) {
      newValue = value;
    } else {
      int startIndex = 0;
      int endIndex = splitOn;
      newValue =
          _formating(startIndex, endIndex, value, "", splitOn, modelSplit);
    }
    return newValue;
  }

  String _formating(int startIndex, int endIndex, String value, String temp,
      int splitOn, String modelSplit) {
    if (startIndex == 0 && endIndex >= value.length) {
      temp = value.substring(startIndex, endIndex);
      return temp;
    }
    if (startIndex == 0 && endIndex < value.length) {
      temp = value.substring(startIndex, endIndex);
      startIndex += splitOn;
      endIndex += splitOn;
      return _formating(startIndex, endIndex, value, temp, splitOn, modelSplit);
    }
    if (startIndex < value.length && endIndex < value.length) {
      temp += "$modelSplit" + value.substring(startIndex, endIndex);
      startIndex += splitOn;
      endIndex += splitOn;
      return _formating(startIndex, endIndex, value, temp, splitOn, modelSplit);
    } else {
      temp += "$modelSplit" + value.substring(startIndex, value.length);
      return temp;
    }
  }

  Color? colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF" + color));
    } else if (color.length == 8) {
      return Color(int.parse("0x" + color));
    }
    return null;
  }

  void logWhenDebug(String tag, String message) {
    if (kDebugMode) Log.log("$tag => ${message.toString()}");
  }

  static getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    return (bytes / pow(1024, 2));
  }
}

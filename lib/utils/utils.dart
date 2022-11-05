import 'dart:io';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:in_app_review/in_app_review.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;

///
/// --------------------------------------------
/// There are many amazing [Function]s in this class.
/// Especialy in [Function]ality.
/// You can find and use on your Controller wich is the Controller extends [BaseController].
class Utilities {
  static Future<void> callPhoneNumber({String phone = "0"}) async {
    await launch("tel://$phone");
  }

  static Future<void> web({
    String link = "https://google.com",
  }) async {
    final url = link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openClassin({
    String link = "https://share.classin.com",
  }) async {
    var splited = link.split("=");
    var classinLink =
        "classin://www.eeo.cn/enterclass?openClassId=${splited[splited.length - 1]}";

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

  static String formattedDate({
    String format = 'dd/MMMM/yyyy',
    String? date,
  }) {
    try {
      if (date == null) {
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

  static getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    return (bytes / pow(1024, 2));
  }

  static rateApp(String appId) async {
    final InAppReview _inAppReview = InAppReview.instance;
    final isAvailable = await _inAppReview.isAvailable();
    if (isAvailable) {
      _inAppReview.openStoreListing(
        appStoreId: appId,
        microsoftStoreId: '...',
      );
    }
  }

  static String timeAgo(DateTime date, String locale) {
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    return timeago.format(date, locale: locale);
  }
}

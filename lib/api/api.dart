import 'dart:io';

import 'package:base_getx/api/result.dart';
import 'package:base_getx/utils/logger.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

enum Method { GET, POST }

/// This class must be instantiated in the [Repositories] class
/// core of the custom API networking
class ApiServiceBase {
  _Api _api = _Api();

  Future<Result> callManualy(
      {Method method = Method.GET,
      required String endPoint,
      required Map<String, String> param,
      bool withToken = false}) async {
    return await _api.callManualy(
      method: method,
      endPoint: endPoint,
      param: param,
      withToken: withToken,
    );
  }

  Future<Result> getData({
    required String endPoint,
    required Map<String, String> query,
    bool withToken = false,
  }) async {
    return await _api.getData(
      endPoint: endPoint,
      query: query,
      withToken: withToken,
    );
  }

  Future<Result> postData({
    required String endPoint,
    required Map data,
    bool withToken = false,
  }) async {
    return await _api.postData(
      endPoint: endPoint,
      data: data,
      withToken: withToken,
    );
  }
}

/// PRIVATE CLASS
/// USE THIS VIA [ApiServiceBase] class
class _Api extends GetConnect {
  // ignore: non_constant_identifier_names
  String API_NAME = "api/scan/";
  Result _result = Result(
      // status: false,
      // isError: false,
      // text: "Xin chào",
      );

  bool _withToken = false;

  @override
  void onInit() async {
    httpClient.baseUrl = 'xxxxx';
    String pf = Platform.operatingSystem;
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['platform'] = pf;
      if (_withToken) {
        // String token = box.read(MyConfig.TOKEN_STRING_KEY);
        // if (token != null) request.headers['Authorization'] = "Bearer $token";
      }
      // Logger.showLog("HEADERS", request.headers.toString());
      return request;
    });
    super.onInit();
  }

  /// FOR NETWORKING WITH [Method.POST] / [Method.GET]
  /// RETURN DATA WITH [Result.body] MODELS and please parse with your model
  Future<Result> callManualy({
    Method method = Method.GET,
    required String endPoint,
    required Map<String, String> param,
    bool withToken = false,
  }) async {
    _withToken = withToken;
    onInit();

    Logger.showLog(method == Method.GET ? "GET" : "POST",
        httpClient.baseUrl! + API_NAME + endPoint);
    Logger.showLog("PARAMS", query.toString());
    Logger.showLog("TOKEN", _withToken.toString());
    try {
      var res;
      if (method == Method.GET) {
        res = await get(API_NAME + endPoint, query: param);
      } else {
        res = await post(API_NAME + endPoint, param);
      }
      _result = Result.fromJson(res.bodyString!);
      if (res.isOk) {
        Logger.showLog("LOADED", res.bodyString);
        // _result.status = true;
        // _result.body = res.body;
        Logger.showLog("PARSING", "SUCCESS");
        return _result;
      } else {
        Logger.showLog("ERROR 0", res.bodyString);
        // _result.status = true;
        // _result.isError = true;
        // _result.text = "Terjadi kesalahan, coba beberapa saat lagi...";
        return _result;
      }
    } catch (e) {
      Logger.showLog("ERROR 1", e.toString());
      // _result.status = true;
      // _result.isError = true;
      return _result;
    }
  }

  /// FOR NETWORKING WITH THE [Method.GET]
  /// RETURN DATA WITH [Result] MODEL
  Future<Result> getData({
    required String endPoint,
    required Map<String, String> query,
    bool withToken = false,
  }) async {
    _withToken = withToken;
    onInit();
    Logger.showLog("GET", httpClient.baseUrl! + API_NAME + endPoint);
    Logger.showLog("PARAMS", query.toString());
    Logger.showLog("TOKEN", _withToken.toString());
    try {
      var res = await get(API_NAME + endPoint, query: query);
      _result = Result.fromJson(res.bodyString!);
      if (res.isOk) {
        Logger.showLog("LOADED", res.bodyString!);
        // _result = Result.fromJson(res.bodyString!);
        // _result.body = res.body;
        Logger.showLog("PARSING", "SUCCESS");
        return _result;
      } else {
        Logger.showLog("ERROR 0", res.bodyString!);
        // _result.status = true;
        // _result.isError = true;
        // _result.text = "Terjadi kesalahan, coba beberapa saat lagi...";
        return _result;
      }
    } catch (e) {
      Logger.showLog("ERROR 1", e.toString());
      // _result.status = true;
      // _result.isError = true;
      return _result;
    }
  }

  /// FOR NETWORKING WITH [Method.POST]
  /// RETURN DATA WITH [Result] MODEL
  Future<Result> postData({
    String endPoint = "",
    required Map data,
    bool withToken = false,
  }) async {
    _withToken = withToken;
    onInit();
    Logger.showLog("POST", httpClient.baseUrl! + API_NAME + endPoint);
    Logger.showLog("PARAMS", data.toString());
    Logger.showLog("TOKEN", _withToken.toString());
    try {
      var res = await httpClient.post(API_NAME + endPoint, body: data);
      _result = Result.fromJson(res.bodyString!);
      if (res.isOk) {
        Logger.showLog("LOADED", res.bodyString!);
        // _result = Result.fromJson(res.bodyString!);
        // _result.body = res.body;
        Logger.showLog("PARSING", "SUCCESS");
        return _result;
      } else {
        Logger.showLog("ERROR 0", res.bodyString!);
        // _result.status = true;
        // _result.isError = true;
        // _result.text = "Terjadi kesalahan, coba beberapa saat lagi...";
        return _result;
      }
    } catch (e) {
      Logger.showLog("ERROR 1", e.toString());
      // _result.status = true;
      // _result.isError = true;
      return _result;
    }
  }

  /// TO SHOW THE LOG WHEN DEBUG MODE TRUE

}

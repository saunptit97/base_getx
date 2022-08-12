import 'package:base_getx/api/api.dart';
import 'package:base_getx/api/result.dart';

/// createdby Daewu Bintara
/// Friday, 1/29/21

///
/// --------------------------------------------
/// In this class where the [Function]s correspond to the API.
/// Which function here you will make it and you will consume it.
/// You can find and use on your Controller wich is the Controller extends [BaseController].
class Repositories {
  final ApiServiceBase _service = ApiServiceBase();

  Future<Result> getDataMember() async => await _service.getData(
        endPoint: "test-get",
        query: {},
      );
}

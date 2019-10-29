import 'package:dio/dio.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';

class Config {

  ServicesApi con = new ServicesApi();

  static var uri = ServicesApi.baseUrl;

  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: 60000,
      receiveTimeout: 90000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
        return null;
      });
}
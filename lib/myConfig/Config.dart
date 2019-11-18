import 'package:dio/dio.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';

class Config {
  ServicesApi con = new ServicesApi();

  static var uri = ServicesApi.basic_url;

  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: 60000,
      receiveTimeout: 900000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
        return null;
      });
}

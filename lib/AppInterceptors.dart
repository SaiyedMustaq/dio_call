import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  @override
  Future<dynamic> onRequest(RequestOptions options) async {
    if (options.headers.containsKey("requiresToken")) {
      //remove the auxiliary header
      options.headers.remove("requiresToken");

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // var header = prefs.get("Header");

      // options.headers.addAll({"Header": "$header${DateTime.now()}"});

      return options;
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<dynamic> onError(DioError dioError) {
    if (dioError.message.contains("ERROR_001")) {
      // this will push a new route and remove all the routes that were present
      // navigatorKey.currentState.pushNamedAndRemoveUntil(
      //     "/login", (Route<dynamic> route) => false);
    }

    return dioError.error;
  }

  @override
  Future<dynamic> onResponse(Response options) async {
    if (options.headers.value("verifyToken") != null) {
      //if the header is present, then compare it with the Shared Prefs key
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // var verifyToken = prefs.get("VerifyToken");

      // // if the value is the same as the header, continue with the request
      // if (options.headers.value("verifyToken") == verifyToken) {
      //   return options;
      // }
    }

    return DioError(
        request: options.request, error: "User is no longer active");
  }
}

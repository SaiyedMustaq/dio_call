import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'NoInternetPage.dart';

// ignore: constant_identifier_names
enum Method { POST, GET, PUT, DELETE, PATCH }

// ignore: constant_identifier_names
const BASE_URL = "https://reqres.in/api/";

class NetworkCall {
  static header() => {
        "Content-Type": "application/json",
      };
  final Dio _dio = Dio();

  NetworkCall() {
    _dio.interceptors.add(PrettyDioLogger(
      error: true,request: true,requestBody: true,requestHeader: true,responseBody: true,responseHeader: true
    ));
  }

  Future<Response> request({
    @required BuildContext? context,
    @required String? url,
    @required Method? method,
    Map<String, dynamic>? params,
  }) async {
    String callUrl = BASE_URL + url!;
    if (kDebugMode) {
      print('URL WAS $callUrl');
    }
    Response response;

    try {
      if (method == Method.POST) {
        response = await _dio.post(callUrl, data: params);
      } else if (method == Method.DELETE) {
        response = await _dio.delete(callUrl);
      } else if (method == Method.PATCH) {
        response = await _dio.patch(callUrl);
      } else {
        response = await _dio.get(callUrl, queryParameters: params);
      }

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        _showInternalServerError(
            context: context, method: method, requestParam: params, url: url);
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something does wen't wrong");
      }
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      _showNoInternetDialog(
        method: method,
        requestParam: params,
        url: callUrl,
        context: context,
      );
      throw Exception("Not Internet Connection");
    } on FormatException catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      throw Exception("Bad response format");
    } on DioError catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      throw Exception(e);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      throw Exception("Something wen't wrong");
    }
  }

  Future<Response> sendFile(String url, File file) async {
    var len = await file.length();
    var response = await _dio.post(url,
        data: file.openRead(),
        options: Options(headers: {
          Headers.contentLengthHeader: len,
        } // set content-length
            ));
    return response;
  }

  Future<Response> sendForm(
    String url,
    Map<String, dynamic> data,
    Map<String, File> files,
  ) async {
    Map<String, MultipartFile> fileMap = {};
    for (MapEntry fileEntry in files.entries) {
      File file = fileEntry.value;
      String fileName = file.path.split('').last;
      fileMap[fileEntry.key] = MultipartFile(
          file.openRead(), await file.length(),
          filename: fileName);
    }
    data.addAll(fileMap);
    var formData = FormData.fromMap(data);

    return await _dio.post(
      url,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  Future<Object> _showNoInternetDialog({
    String? url,
    BuildContext? context,
    Map<String, dynamic>? requestParam,
    Method? method,
  }) async {
    return showGeneralDialog(
        context: context!,
        barrierColor: Colors.red,
        // Background color
        barrierDismissible: false,
        barrierLabel: 'Dialog',
        pageBuilder: (_, __, ___) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: NoInternetPage(
                onButtonClick: () {
                  request(url: url, method: method, context: null).then(
                    (value) => Navigator.pop(
                      context,
                      value,
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  Future<Object> _showInternalServerError({
    String? url,
    BuildContext? context,
    Map<String, dynamic>? requestParam,
    Method? method,
  }) async {
    return showGeneralDialog(
        context: context!,
        barrierColor: Colors.red,
        // Background color
        barrierDismissible: false,
        barrierLabel: 'Dialog',
        pageBuilder: (_, __, ___) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: NoInternetPage(
                onButtonClick: () {
                  request(url: url, method: method, context: null).then(
                    (value) => Navigator.pop(
                      context,
                      value,
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

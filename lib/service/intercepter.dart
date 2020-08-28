import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class ApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    String languageCode, token;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((onValue) {
      token = onValue;
    });

    try {
      data.headers['Content-Type'] = 'application/json';
      data.headers['language'] = languageCode;
      data.headers['Authorization'] = 'bearer $token';
    } catch (e) {
      print(e.toString());
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    var errorData = json.decode(data.body);
    print(errorData);
    if (data.statusCode == 400) {

      var msg = '';
      for (int i = 0, l = errorData['errors'].length; i < l; i++) {
        msg += errorData['errors'][i] + '\n';
      }
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: primary,
          textColor: Colors.black,
          fontSize: 16.0);
      return Future.error('Unexpected error 😢');
    } else if (data.statusCode == 401) {
      await Common.setToken(null);
      await Common.setUserID(null);
      return Future.error('Unexpected error 😢');
    }
    return data;
  }
}

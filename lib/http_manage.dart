library http_manage;

//put with custom headers & custom model
// post with custom headers & custom body & custom model
// get with custom headers & custom model

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

abstract class BaseModel<T> {
  T fromJson(Map<String, dynamic> json);
}

final navigatorKey = GlobalKey<NavigatorState>();

enum ResponseState { SUCCESS, ERROR } //control for dialog messages

class HttpManage {
  final String endPoint;

  final String onErrorTitle; //default or custom messages
  final String onErrorMessage; //default or custom messages

  final String onSuccessTitle; //default or custom messages
  final String onSuccessMessage; //default or custom messages

  final String backButtonText; //default or custom messages

  HttpManage(
      {@required this.endPoint,
      bool showDialog = false,
      this.onSuccessTitle = 'Awesome 😻',
      this.onSuccessMessage = 'Success',
      this.onErrorTitle = 'Sorry 😿',
      this.backButtonText = 'Back',
      this.onErrorMessage = 'An Error Occured Please Try Again'});

  getRequestWithModel<T extends BaseModel>(
    //return custom model after get request
    String path,
    BaseModel<T> baseModel, {
    Map<String, String> headerItems,
    bool showDialog = false,
    List<String> keys,
    String anotherEndPoint,
  }) async {
    String requestEndPoint = anotherEndPoint == null
        ? this.endPoint
        : anotherEndPoint; //use anotherEndPoint if exist or use defaultEndPoint
    var response = await http.get('$requestEndPoint$path',
        headers: headerItems != null
            ? headerItems
            : {"httpmanage": "httpmanagedefaultheader"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      //if response success
      if (showDialog) {
        this.dialog(state: ResponseState.SUCCESS);
      }

      var data = jsonDecode(response.body); //decode
      if (keys != null) {
        keys.forEach((key) {
          data = data[key];
        });
      }
      return (data as List).map((e) => baseModel.fromJson(e)).toList(); //return
    } else {
      dialog();
    }
  }

  postRequestWithModel<T extends BaseModel>(
    String path,
    Map<String, String> bodyItem,
    BaseModel<T> baseModel, {
    Map<String, String> headerItems,
    List<String> keys,
    bool showDialog = false,
    String anotherEndPoint,
    //return custom model after post request
  }) async {
    String requestEndPoint = anotherEndPoint == null
        ? this.endPoint
        : anotherEndPoint; //use anotherEndPoint if exist or use defaultEndPoint
    var response = await http.post('$requestEndPoint$path',
        body: bodyItem,
        headers: headerItems != null
            ? headerItems
            : {"httpmanage": "httpmanagedefaultheader"}); //send request
    if (response.statusCode == 200 || response.statusCode == 201) {
      //if response success
      var data = jsonDecode(response.body); //decode
      if (showDialog) {
        this.dialog(state: ResponseState.SUCCESS);
      }

      if (keys == null) {
        return data;
      } else {
        keys.forEach((key) {
          data = data[key];
        });
        return (data as List).map((e) => baseModel.fromJson(e)).toList();
      }
    } else {
      this.dialog();
    }
  }

  putRequestWithModel<T extends BaseModel>(
    String path,
    Map<String, String> bodyItem,
    BaseModel<T> baseModel, {
    Map<String, String> headerItems,
    List<String> keys,
    bool showDialog = false,
    String anotherEndPoint,
    //return custom model after post request
  }) async {
    String requestEndPoint = anotherEndPoint == null
        ? this.endPoint
        : anotherEndPoint; //use anotherEndPoint if exist or use defaultEndPoint
    var response = await http.put('$requestEndPoint$path',
        body: bodyItem,
        headers: headerItems != null
            ? headerItems
            : {"httpmanage": "httpmanagedefaultheader"}); //send request
    if (response.statusCode == 200 || response.statusCode == 201) {
      //if response success
      var data = jsonDecode(response.body); //decode
      if (showDialog) {
        this.dialog(state: ResponseState.SUCCESS);
      }

      if (keys == null) {
        return data;
      } else {
        keys.forEach((key) {
          data = data[key];
        });
        return (data as List).map((e) => baseModel.fromJson(e)).toList();
      }
    } else {
      this.dialog();
    }
  }

  sendFile(String path, File file,
      {Map<String, String> bodyItems,
      bool showDialog = false,
      Map<String, String> headerItems,
      String anotherEndPoint}) async {
    String requestEndPoint =
        anotherEndPoint == null ? this.endPoint : anotherEndPoint;

    MultipartRequest response =
        http.MultipartRequest("POST", Uri.parse('$requestEndPoint$path'));

    response.fields.addAll(bodyItems);

    MultipartFile multipartFile =
        await MultipartFile.fromPath('image', file.path);

    response.files.add(multipartFile);
    response.headers.addAll(headerItems != null
        ? headerItems
        : {"httpmanage": "httpmanagedefaultheader"});

    response.send().then((response) {
      if (response.statusCode == 200) {
        if (showDialog) {
          this.dialog(state: ResponseState.SUCCESS);
        }
      } else {
        this.dialog();
      }
    });
  }

  postRequest(
    String path,
    Map<String, String> bodyItem, {
    Map<String, String> headerItems,
    String anotherEndPoint,
    bool showDialog = false,
  }) async {
    String requestEndPoint =
        anotherEndPoint == null ? this.endPoint : anotherEndPoint;
    var response = await http.post('$requestEndPoint$path',
        body: bodyItem,
        headers: headerItems != null
            ? headerItems
            : {"httpmanage": "httpmanagedefaultheader"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (showDialog) {
        this.dialog(state: ResponseState.SUCCESS);
      }

      return jsonDecode(response.body);
    } else {
      this.dialog();
    }
  }

  putRequest(
    String path,
    Map<String, String> bodyItem, {
    Map<String, String> headerItems,
    String anotherEndPoint,
    bool showDialog = false,
  }) async {
    String requestEndPoint =
        anotherEndPoint == null ? this.endPoint : anotherEndPoint;
    var response = await http.put('$requestEndPoint$path',
        body: bodyItem,
        headers: headerItems != null
            ? headerItems
            : {"httpmanage": "httpmanagedefaultheader"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (showDialog) {
        this.dialog(state: ResponseState.SUCCESS);
      }

      return jsonDecode(response.body);
    } else {
      this.dialog();
    }
  }

  getRequest(
    String path, {
    Map<String, String> headerItems,
    List<String> keys,
    String anotherEndPoint,
    bool showDialog = false,
  }) async {
    String requestEndPoint =
        anotherEndPoint == null ? this.endPoint : anotherEndPoint;
    var response = await http.get('$requestEndPoint$path',
        headers: headerItems != null
            ? headerItems
            : {"httpmanage": "httpmanagedefaultheader"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (showDialog) {
        this.dialog(state: ResponseState.SUCCESS);
      }
      var data = jsonDecode(response.body);
      if (keys == null) {
        return data;
      } else {
        keys.forEach((key) {
          data = data[key];
        });
        return data;
      }
    } else {
      this.dialog();
    }
  }

  deleteRequest(
    String path, {
    Map<String, String> headerItems,
    List<String> keys,
    String anotherEndPoint,
    bool showDialog = false,
  }) async {
    String requestEndPoint =
        anotherEndPoint == null ? this.endPoint : anotherEndPoint;
    var response = await http.delete('$requestEndPoint$path',
        headers: headerItems != null
            ? headerItems
            : {"httpmanage": "httpmanagedefaultheader"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (showDialog) {
        this.dialog(state: ResponseState.SUCCESS);
      }
      var data = jsonDecode(response.body);
      if (keys == null) {
        return data;
      } else {
        keys.forEach((key) {
          data = data[key];
        });
        return data;
      }
    } else {
      this.dialog();
    }
  }

  dialog({ResponseState state = ResponseState.ERROR}) {
    showDialog(
        context: navigatorKey.currentContext,
        builder: (BuildContext context) => AlertDialog(
              title: Text(state == ResponseState.ERROR
                  ? this.onErrorTitle
                  : this.onSuccessTitle),
              content: Text(state == ResponseState.ERROR
                  ? this.onErrorMessage
                  : this.onSuccessMessage),
              actions: [
                RaisedButton(
                  child: Text(this.backButtonText),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }
}

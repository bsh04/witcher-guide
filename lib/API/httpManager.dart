import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:witcher_guide/secureStorageManager.dart';

enum Method {
  POST,
  GET,
}

class RequestParams {
  late Uri url;
  late Object? body = {};
  late Map<String, String>? headers;
  late Method method = Method.POST;
}

class Response<T> {
  late int status;
  late T? data;
}

Future<Response> request(RequestParams params) async {
  var response = await httpManager(params);
  print(response?.statusCode);

  if (response?.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    var res = Response();
    res.status = 200;
    res.data = jsonResponse;
    return res;
  }

  if (response?.statusCode == 401) {
    await deleteStorageKey(tokenKey);
  }

  return Response();
}

Future httpManager(RequestParams params) async {
  try {
    http.Response response;

    switch (params.method) {
      case Method.POST:
        response = await http.post(params.url,
            headers: await getBaseHeaders(),
            body: params.body != null ? jsonEncode(params.body) : null);
        break;
      case Method.GET:
        response = await http.get(params.url, headers: await getBaseHeaders());
        break;
    }

    return response;
  } catch (err) {
    print(err);
  }
}

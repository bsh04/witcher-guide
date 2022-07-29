import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

getStorageKey(String key) async {
  return await secureStorage.read(key: key);
}

deleteStorageKey(String key) async {
  return await secureStorage.delete(key: key);
}

setStorageKey(String key, String value) async {
  return await secureStorage.write(key: key, value: value);
}

getBaseHeaders() async {
  final String? token = await getStorageKey("token");
  late Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  if (token != null) {
    headers.addAll({'x-access-token': token});
  }
  return headers;
}
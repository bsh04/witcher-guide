import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/API/httpManager.dart';

import 'package:http/http.dart' as http;
import 'package:witcher_guide/secureStorageManager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _handleLogin() async {
    RequestParams params = RequestParams();
    params.url = getUrl(userLoginUrl);
    params.body = {
      "login": _loginController.value.text,
      "password": _passwordController.value.text
    };
    Response response = await request(params);
    await setStorageKey("token", response.data["token"]);
    if (response.status == 200) {
      Navigator.pushNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Login page")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text("Sign in", style: TextStyle(fontSize: 25)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    hintText: 'Enter login',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter password',
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: MaterialButton(
                    color: Colors.blue,
                    onPressed: _handleLogin,
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration');
                  },
                  child: const Text("Don't have an account? Register now!"))
            ],
          ),
        ));
  }
}

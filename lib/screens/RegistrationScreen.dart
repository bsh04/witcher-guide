import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/API/httpManager.dart';
import 'package:witcher_guide/secureStorageManager.dart';
import 'package:witcher_guide/validators.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late String _passwordErrorText = "";
  late bool _passwordVisible = false;

  void _handleRegistration() async {
    bool isValidate = _formKey.currentState!.validate();
    if (!isValidate) {
      return;
    }
    var password = _passwordController.value.text;
    var rPassword = _repeatPasswordController.value.text;

    if (password != rPassword) {
      setState(() {
        _passwordErrorText = "Password not match";
      });
      return;
    }
    RequestParams params = RequestParams();
    params.url = getUrl(userRegisterUrl);
    params.body = {
      "login": _loginController.value.text,
      "password": _passwordController.value.text
    };
    Response response = await request(params);
    if (response.status == 200) {
      await setStorageKey("token", response.data["token"]);
      Navigator.pushNamed(context, '/');
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Registration page")),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text("Registration", style: TextStyle(fontSize: 25)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      validator: isRequired,
                      controller: _loginController,
                      decoration: const InputDecoration(
                        hintText: 'Enter login',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      validator: isRequired,
                      obscureText: !_passwordVisible,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: 'Enter password',
                          errorText: _passwordErrorText,
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: _passwordErrorText != ""
                                    ? Colors.red
                                    : Colors.blue),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: _passwordErrorText != ""
                                    ? Colors.red
                                    : Colors.black45),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      validator: isRequired,
                      obscureText: !_passwordVisible,
                      controller: _repeatPasswordController,
                      decoration: InputDecoration(
                          hintText: 'Repeat password',
                          errorText: _passwordErrorText,
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: _passwordErrorText != ""
                                    ? Colors.red
                                    : Colors.blue),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: _passwordErrorText != ""
                                    ? Colors.red
                                    : Colors.black45),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ))),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextButton(
                          onPressed: _handleRegistration,
                          child: const Text("Registration"))),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text("Do you have an account? Sign in"))
                ],
              ),
            ),
          ),
        ));
  }
}

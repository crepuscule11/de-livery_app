import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'deliverydetails_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController =
      TextEditingController(text: "riderjrsisa1");
  TextEditingController passwordController =
      TextEditingController(text: "password123@");
  TextEditingController idController = TextEditingController();

  Future<UserId?> login(String email, String password, String data) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      final msg = jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      });

      print("$email $password ");
      Response response = await post(
        Uri.parse('https://gorder.website/API/rider/login.php'),
        headers: headers,
        body: msg,
      );
      print(data);
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        UserId userId = UserId.fromJson(responseData);

        var jsonData = int.parse(responseData['data']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('jsonData', jsonData);

        return userId;
      } else {
        print('failed');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = MyHttpOverrides();
  }

  bool _isLoggedInUnsuccessful = false;
  bool test = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        // Remove debug
        child: Container(
          height: 0.8 * MediaQuery.of(context).size.height,
          width: 0.8 * MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Container(
                height: 140,
                width: 140,
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/goldengate1.png")),
                ),
              ),
              Container(
                height: 30,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Username",
                          prefixIcon: Icon(Icons.email),
                          errorText: _isLoggedInUnsuccessful
                              ? "Email or password is incorrect"
                              : null),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.security),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50.0,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 18, 83, 136),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                textStyle: TextStyle(fontSize: 20)),
                            onPressed: () async {
                              Object? isLoggedIn = await login(
                                  emailController.text.toString(),
                                  passwordController.text.toString(),
                                  idController.text.toString());

                              if (isLoggedIn != null) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const DetailsScreen())));
                                setState() {}

                                return;
                              }
                              setState(() {
                                _isLoggedInUnsuccessful = true;
                              });
                            },
                            child: const Center(child: Text("Log in"))),
                      ),
                    ),
                    Container(
                      height: 3,
                    ),
                    Center(
                      child: ListTile(
                        title: Center(
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "forgot password? ",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 15,
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

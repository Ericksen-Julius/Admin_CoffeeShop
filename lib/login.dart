// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:admin_shop/home.dart';
import 'package:admin_shop/models/userSignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Container(
                      height: 225,
                      child: Image.asset(
                        "assets/bigLogo.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                  child: TextFormField(
                    controller: _emailController,
                    cursorColor: Color.fromRGBO(227, 227, 227, 1.0),
                    style: TextStyle(
                      color: Color.fromRGBO(227, 227, 227, 1.0),
                      fontSize: 18,
                    ),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(39, 39, 39, 1),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(227, 227, 227, 0.75),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Color.fromRGBO(227, 227, 227, 0.75),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(227, 227, 227, 1.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(227, 227, 227, 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    cursorColor: Color.fromRGBO(205, 115, 115, 1),
                    style: TextStyle(
                      color: Color.fromRGBO(227, 227, 227, 1.0),
                      fontSize: 18,
                    ),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(39, 39, 39, 1),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(227, 227, 227, 0.75),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline_sharp,
                        color: Color.fromRGBO(227, 227, 227, 0.75),
                      ),
                      // helperText: "*Password length must be more than 4 characters",
                      // helperStyle: TextStyle(
                      //   color: Color.fromRGBO(227, 227, 227, 0.75),
                      // ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(227, 227, 227, 1.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(227, 227, 227, 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 25, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            visualDensity: VisualDensity(horizontal: -4.0),
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            value: isChecked,
                            checkColor: Color.fromRGBO(227, 227, 227, 1.0),
                            side: BorderSide(
                              color: Color.fromRGBO(227, 227, 227, 1.0),
                            ),
                            fillColor: MaterialStateProperty.resolveWith(
                              (states) {
                                return Color.fromRGBO(39, 39, 39, 1);
                              },
                            ),
                          ),
                          Text(
                            "Remember me",
                            style: TextStyle(
                              color: Color.fromRGBO(227, 227, 227, 0.75),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle forget password tap
                        },
                        child: Text(
                          'Forget Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _signIn(_emailController.text, _passwordController.text,
                            context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(39, 39, 39, 1),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            color: Color.fromRGBO(227, 227, 227, 1.0),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Color.fromRGBO(227, 227, 227, 0.75),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 25.0, left: 30.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Color.fromRGBO(227, 227, 227, 0.75),
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Action when "Sign up" text is tapped
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _signIn(
  String email,
  String password,
  BuildContext context,
) async {
  const url = "http://10.0.2.2:8000/api/loginAdmin";
  final uri = Uri.parse(url);
  final response = await http.post(
    uri,
    headers: {
      'Content-type': 'application/json',
    },
    body: json.encode(
      {
        'email': email,
        'password': password,
      },
    ),
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final userSignInResult = UserSignInResult.fromJson(responseData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeAdmin(
          user: userSignInResult.user!,
          token: userSignInResult.token, // Access token from the instance
        ),
      ),
    );
  } else if (response.statusCode == 403) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Failed",
              style: TextStyle(color: Colors.red),
            ),
            content: Text("Anda bukan admin"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );
        });
  } else {
    debugPrint("Error");
  }
}

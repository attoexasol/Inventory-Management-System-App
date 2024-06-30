import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management_system/Screens/dashboard_screen.dart';
import 'package:inventory_management_system/Screens/signup_screen.dart';
import 'package:inventory_management_system/services/auth_service.dart'; // Adjust path as needed
import 'package:inventory_management_system/widgets/button.dart';
import 'package:inventory_management_system/widgets/inputField.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Validation Error'),
            content: const Text('Please fill in all fields.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };

    String jsonBody = json.encode(requestBody);

    try {
      var response = await http.post(
        Uri.parse('http://103.145.138.100:8000/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print('Login successful');

        // Access authService instance from Provider and call logIn method
        AuthService authService =
            Provider.of<AuthService>(context, listen: false);
        authService.logIn();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        print(responseBody);
      } else if (response.statusCode == 401) {
        print('Login failed: Invalid credentials');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Login failed with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error making POST request: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Error making login request. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 1,
                  color: Colors.red[500],
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      top: MediaQuery.of(context).size.height * 0.125,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Welcome Back to Inventory Management system',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height * 0.7,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      InputField(
                        controller: _emailController,
                        decoration: InputDecoration(hintText: 'Enter email'),
                        keyboardtype: TextInputType.emailAddress,
                        icon: Icon(Icons.email),
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        controller: _passwordController,
                        decoration: InputDecoration(hintText: 'Password'),
                        secureText: true,
                        icon: Icon(Icons.password),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Button(
                        btnText: "Login".toUpperCase(),
                        icon: Icon(Icons.lock, color: Colors.white),
                        bgColor: Colors.red[500],
                        callback: () => _loginUser(context),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        width: 150,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      ),
                      const SizedBox(height: 100),
                      const Center(
                        child: Text(
                          "Continue with social media",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Button(
                            btnText: "Facebook",
                            icon: Icon(
                              Icons.facebook_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                            bgColor: Colors.blue[500],
                            // callback: () => _loginUser(context),
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 18),
                            width: MediaQuery.of(context).size.width * 0.42,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          Button(
                            btnText: "Google",
                            icon: Icon(
                              Icons.g_mobiledata,
                              color: Colors.white,
                              size: 40,
                            ),
                            bgColor: Colors.red[500],
                            // callback: () => _loginUser(context),
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 18),
                            width: MediaQuery.of(context).size.width * 0.35,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have any account?"),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()),
                              );
                            },
                            child: Text(
                              "Signup",
                              style: TextStyle(
                                color: Colors.red[500],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

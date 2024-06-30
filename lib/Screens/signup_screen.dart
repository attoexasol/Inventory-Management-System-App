import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management_system/Screens/login_screen.dart';
import 'package:inventory_management_system/widgets/button.dart';
import 'package:inventory_management_system/widgets/inputField.dart'; // Replace with actual path if needed

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _registerUser() async {
    // Gather the values from the text controllers
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Validate inputs (add more complex validation if needed)
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
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

    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Validation Error'),
            content: const Text('Passwords do not match.'),
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

    // Prepare the request body
    Map<String, String> requestBody = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };

    // Encode the body to JSON
    String jsonBody = json.encode(requestBody);

    // Make the POST request
    try {
      var response = await http.post(
        Uri.parse('http://103.145.138.100:8000/api/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        print('Registration successful');
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else if (response.statusCode == 422) {
        var responseBody = json.decode(response.body);
        print('Registration failed with validation errors:');
        print(responseBody);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registration Failed'),
              content: Text(responseBody[
                  'message']), // Adjust based on API response structure
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
      } else {
        // Other status codes handling (e.g., 404, 500)
        print('Registration failed with status code ${response.statusCode}');
        // Optionally handle other error scenarios
      }
    } catch (e) {
      // Exception thrown during http call
      print('Error making POST request: $e');
      // Optionally handle exception here
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Error making registration request. Please try again later.'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 1,
                  color: Colors.red[500],
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Welcome to Inventory Management System',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height * 0.7,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: Column(
                    children: [
                      InputField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(hintText: 'Enter name'),
                        icon: Icon(Icons.person),
                      ),
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
                      InputField(
                        controller: _confirmPasswordController,
                        decoration:
                            InputDecoration(hintText: 'Confirm password'),
                        secureText: true,
                        icon: Icon(Icons.password),
                      ),
                      const SizedBox(height: 20),
                      Button(
                        btnText: "Sign Up".toUpperCase(),
                        icon: Icon(Icons.lock, color: Colors.white),
                        bgColor: Colors.red[500],
                        callback: () => _registerUser(),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        width: 160,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      ),
                      const SizedBox(height: 20),
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
                          const Text("Already have an account?"),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the login screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              "Login",
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

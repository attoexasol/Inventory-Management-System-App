import 'package:flutter/material.dart';
import 'package:inventory_management_system/screens/dashboard_screen.dart';
import 'package:inventory_management_system/screens/login_screen.dart';
import 'package:inventory_management_system/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return FutureBuilder<bool>(
      future: authService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          bool isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? DashboardScreen() : LoginScreen();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:inventory_management_system/services/auth_service.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back button
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.logOut(); // Call logout method
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Dashboard!'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/features/shop/screens/requests/add_request_screen.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'add_request_screen.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: darkMode ? TColors.black : TColors.white,
      appBar: AppBar(
        title: Text(
          'Requests',
          style: TextStyle(
            color: darkMode ? TColors.white : TColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkMode ? TColors.black : TColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          'Requests List',
          style: TextStyle(
            fontSize: 18,
            color: darkMode ? TColors.white : TColors.black,
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'New Request',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRequestScreen()),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Iconsax.add_square, color: Colors.white),
        ),
      ),
    );
  }
}


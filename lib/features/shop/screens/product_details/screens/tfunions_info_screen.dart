import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';

class TfUnionsScreen extends StatelessWidget {
  const TfUnionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: Text("TF Unions")),
      body: const Center(
        child: Text("TF Unions Info Screen"),
      ),
    );
  }
}
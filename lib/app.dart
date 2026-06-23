import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/bindings/general_bindings.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      builder: (context, child) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: child!,
          ),
        );
      },
      home: const Scaffold(
        backgroundColor: TColors.primary,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }
}

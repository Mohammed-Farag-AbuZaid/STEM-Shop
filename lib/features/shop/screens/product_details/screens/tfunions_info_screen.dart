import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/buttons/visit_tf_button.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TfUnionsScreen extends StatelessWidget {
  const TfUnionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: Text("TF Unions"), showBackArrow: true),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          TCircularContianer(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            backgroundColor: Colors.transparent,
            showBorder: true,
            borderColor: Colors.grey.withValues(alpha: 0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "About TF Unions",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 8),
                Text(
                  "TF Unions is a non-profit organization dedicated to supporting and empowering students throughout their academic journey by creating digital solutions — apps, websites, videos, guides, and more. For more information, visit the TF Unions website, and join our WhatsApp community to stay updated with the latest news.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: VisitTFButton(),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: SizedBox(height: 60, width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse('https://chat.whatsapp.com/DSiidKAP0TP84vXA9Pand7');
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              child: const Text('WhatsApp Community'),
            ),
            ),
          ),
        ],
      ),
    );
  }
}

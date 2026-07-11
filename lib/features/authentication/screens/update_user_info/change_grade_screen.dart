import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangeGrade extends StatelessWidget {
  const ChangeGrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Change Grade',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be done from here, you can change your Grade and all other academic information from the TF-Unions website',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBwSections),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse('https://tfunions.vercel.app/');
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: const Text('Visit TF-Unions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

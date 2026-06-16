import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangeSchool extends StatelessWidget {
  const ChangeSchool({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Change School',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be done from here, you can change your school from the TF-Unions website',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBwSections),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse('https://tf-unions.netlify.app/');
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

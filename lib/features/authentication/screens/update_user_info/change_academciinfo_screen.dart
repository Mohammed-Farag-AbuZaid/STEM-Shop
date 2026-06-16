import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangeAcademicInfo extends StatelessWidget {
  const ChangeAcademicInfo({super.key, this.title = 'Change Academic Info', this.description = 'This action cannot be done from here, you can change your Academic Info from the TF-Unions website'});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be done from here, you can change your $description and all other Academic Info from the TF-Unions website',
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

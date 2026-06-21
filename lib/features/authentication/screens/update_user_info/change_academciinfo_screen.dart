import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/buttons/visit_tf_button.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

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


            VisitTFButton(),
          ],
        ),
      ),
    );
  }
}



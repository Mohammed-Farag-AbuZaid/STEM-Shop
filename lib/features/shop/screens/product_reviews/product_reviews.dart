import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/product/ratings/rating_indicator.dart';
import 'package:stem_shop/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:stem_shop/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:stem_shop/utils/constants/sizes.dart'; 

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// --- AppBar
      appBar: TAppBar(title: const Text('Reviews & Ratings'), showBackArrow: true),

      /// --- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ratings and reviews are verified and are from people who use the same type of device that you use.",
              ),
              const SizedBox(height: TSizes.spaceBwItems),

              /// --- Overall Product Ratings
              TOverallProductRating(), 
              TRatingBarIndicator(rating: 3.5),
              Text("12,611", style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: TSizes.spaceBwSections),
              /// --- User Reviews List
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}

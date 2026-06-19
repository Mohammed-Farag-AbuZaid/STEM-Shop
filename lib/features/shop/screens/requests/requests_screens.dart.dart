import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/features/shop/screens/requests/request_detail_screen.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'add_request_screen.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);

    final List<Map<String, String>> dummyRequests = [
      {
        'userName': 'Ahmed Ali',
        'userImage': 'https://dicebear.com',
        'title': 'Arduino Uno & Breadboard',
        'category': 'Electronics',
        'price': '\$20.00',
        'discount': '25%',
        'finalPrice': '\$15.00',
        'school': 'STEM October',
        'date': '2 hours ago',
        'whatsapp': '+201234567890',
        'desc':
            'Need it urgently for our physics project this week. Must be in good condition with all jumper wires included.',
      },
      {
        'userName': 'Sara Mohamed',
        'userImage': 'https://dicebear.com',
        'title': 'Capstone Engineering Tools',
        'category': 'Capstone',
        'price': '\$45.00',
        'discount': '0%',
        'finalPrice': '\$45.00',
        'school': 'All STEM Schools',
        'date': 'Yesterday',
        'whatsapp': '+201987654321',
        'desc':
            'Looking for a complete soldering iron kit and digital multimeter. Preferable if it includes some solder wire.',
      },
    ];

    return Scaffold(
      backgroundColor: darkMode ? TColors.black : TColors.white,
      appBar: AppBar(
        title: Text(
          'Students Requests',
          style: TextStyle(
            color: darkMode ? TColors.white : TColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkMode ? TColors.black : TColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: dummyRequests.length,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        itemBuilder: (context, index) {
          final request = dummyRequests[index];
          final isSpecificSchool = request['school'] != 'All STEM Schools';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RequestDetailScreen(request: request, darkMode: darkMode),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: TSizes.spaceBwInputFields),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: darkMode
                    ? TColors.white.withValues(alpha: 0.05)
                    : Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: darkMode
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.blue.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                        child: Icon(
                          Iconsax.user,
                          size: 16,
                          color: darkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['userName']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: darkMode ? TColors.white : TColors.black,
                            ),
                          ),
                          Text(
                            request['date']!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          request['category']!,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    request['title']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkMode ? TColors.white : TColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    request['desc']!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  Divider(
                    height: 1,
                    color: darkMode ? Colors.white12 : Colors.black12,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        isSpecificSchool ? Iconsax.building : Iconsax.global,
                        size: 16,
                        color: isSpecificSchool ? Colors.orange : Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        request['school']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSpecificSchool
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Budget: ',
                        style: TextStyle(
                          fontSize: 13,
                          color: darkMode ? Colors.white70 : Colors.black,
                        ),
                      ),
                      Text(
                        request['finalPrice']!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Tooltip(
        message: 'New Request',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddRequestScreen()),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Iconsax.add_square, color: Colors.white),
        ),
      ),
    );
  }
}

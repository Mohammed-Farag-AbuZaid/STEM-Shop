import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/requests/request_card.dart';
import 'package:stem_shop/features/shop/screens/requests/add_request_screen.dart';
import 'package:stem_shop/features/shop/screens/requests/request_detail_screen.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  final List<Map<String, dynamic>> _dummy = const [
    {
      'userName': 'Ahmed Ali',
      'userImage': '',
      'title': 'Arduino Uno & Breadboard',
      'category': 'Electronics',
      'budget': 150.0,
      'whatsapp': '+201234567890',
      'desc': 'Need it urgently for our physics project this week. Must be in good condition with all jumper wires included.',
      'school': 'my_school',
    },
    {
      'userName': 'Sara Mohamed',
      'userImage': '',
      'title': 'Capstone Engineering Tools',
      'category': 'Capstone',
      'budget': 450.0,
      'whatsapp': '+201987654321',
      'desc': 'Looking for a complete soldering iron kit and digital multimeter. Preferable if it includes some solder wire.',
      'school': 'all_schools',
    },
    {
      'userName': 'Kareem Mahmoud',
      'userImage': '',
      'title': 'Physics Olympiad Book Set',
      'category': 'Books',
      'budget': 200.0,
      'whatsapp': '+201122334455',
      'desc': 'Looking for Irodov and Halliday Resnick. Any edition is fine, just needs to be readable.',
      'school': 'all_schools',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Requests',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_sharp),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        itemCount: _dummy.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: TSizes.spaceBwItems),
        itemBuilder: (context, index) {
          final r = _dummy[index];
          return RequestCard(
            request: r,
            timeAgo: _timeAgo(
              DateTime.now().subtract(const Duration(hours: 2)),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RequestDetailScreen(request: r),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddRequestScreen()),
        ),
        backgroundColor: Colors.blue,
        child: const Icon(Iconsax.add_square, color: Colors.white),
      ),
    );
  }
}


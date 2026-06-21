import 'package:url_launcher/url_launcher.dart';

class TWhatsAppLauncher {

  static Future<bool> openChat({
    required String phone,
    required String message,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final encodedMessage = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/20$cleanPhone?text=$encodedMessage');

    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
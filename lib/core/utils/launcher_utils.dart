import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static const String defaultTargetNumber = '7489128297';

  static Future<void> launchWhatsApp({
    required String tenantName,
    required String roomNo,
    required num monthlyRent,
    String? phone,
  }) async {
    final rawPhone = (phone != null && phone.isNotEmpty) ? phone : defaultTargetNumber;
    final cleanPhone = rawPhone.replaceAll(RegExp(r'\D'), '');
    final formattedPhone = cleanPhone.length == 10 ? '91$cleanPhone' : cleanPhone;

    final message = Uri.encodeComponent(
      'Hello $tenantName, this is a rent payment reminder for Room $roomNo at Dormly PG. '
      'Your monthly rent amount is ₹$monthlyRent. Kindly settle the payment at your earliest convenience. Thank you!',
    );

    final url = Uri.parse('https://wa.me/$formattedPhone?text=$message');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        final fallbackUrl = Uri.parse('whatsapp://send?phone=$formattedPhone&text=$message');
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        // Fallback attempt
        final webUrl = Uri.parse('https://api.whatsapp.com/send?phone=$formattedPhone&text=$message');
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    }
  }

  static Future<void> makePhoneCall(String? phone) async {
    final rawPhone = (phone != null && phone.isNotEmpty) ? phone : defaultTargetNumber;
    final cleanPhone = rawPhone.replaceAll(RegExp(r'\D'), '');
    final url = Uri.parse('tel:$cleanPhone');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(url);
      } catch (e) {
        // Handled silently
      }
    }
  }
}

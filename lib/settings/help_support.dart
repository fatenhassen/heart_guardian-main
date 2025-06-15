import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'projectteam1235@gmail.com',
      query: 'subject=Support Needed&body=Hello, I need help with...',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      debugPrint('Could not launch email client.');
    }
  }

  void _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse("https://wa.me/201091256413");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch WhatsApp.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.teal[700] : const Color(0xFFA0D1EF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'help_support'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'need_assistance'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Agbalumo',
                color: isDark ? Colors.white : const Color(0XFF042D46),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 7,
              color: isDark ? Colors.grey[900] : Colors.white,
              shadowColor: isDark ? Colors.tealAccent : const Color(0xFF6C9FBB),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'contact_instruction'.tr(),
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white70 : Colors.black,
                        fontFamily: 'Agbalumo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.email_outlined,
                        color:
                            isDark
                                ? Colors.tealAccent
                                : const Color(0XFF042D46),
                      ),
                      title: Text(
                        'projectteam1235@gmail.com',
                        style: TextStyle(
                          color:
                              isDark ? Colors.white70 : const Color(0xFF656363),
                          fontFamily: 'Agbalumo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: _launchEmail,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        'assets/icons/whatsapp.svg',
                        width: 24,
                        height: 24,
                        color: isDark ? Colors.tealAccent : null,
                      ),
                      title: Text(
                        '+20 1091256413',
                        style: TextStyle(
                          color:
                              isDark ? Colors.white70 : const Color(0xFF656363),
                          fontSize: 16,
                          fontFamily: 'Agbalumo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: _launchWhatsApp,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'faq_contact'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Agbalumo',
                color: isDark ? Colors.white : const Color(0XFF042D46),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

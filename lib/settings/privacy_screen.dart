import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // تأكد من إضافته

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA0D1EF),
        title: Text(
          'privacy_policy'.tr(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Transform.rotate(
            angle: 3.1416,
            child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Agbalumo',
            fontSize: 16,
            color: textColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'your_privacy_matters'.tr(),
                style: const TextStyle(
                  fontFamily: 'Agbalumo',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color(0xFF74B0D4),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'privacy_description'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'your_rights'.tr(),
                style: const TextStyle(
                  fontFamily: 'Agbalumo',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color(0xFF74B0D4),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'rights_description'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'contact_us'.tr(),
                style: const TextStyle(
                  fontFamily: 'Agbalumo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF74B0D4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

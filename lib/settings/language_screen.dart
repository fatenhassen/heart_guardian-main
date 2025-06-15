import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA0D1EF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 100,
        title: Text(
          'language'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'choose_language'.tr(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Agbalumo',
                fontSize: 20,
                color: textColor,
              ),
            ),
            const SizedBox(height: 25),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text('arabic'.tr()),
                    value: 'ar',
                    groupValue: currentLocale,
                    onChanged: (value) {
                      context.setLocale(const Locale('ar'));
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('english'.tr()),
                    value: 'en',
                    groupValue: currentLocale,
                    onChanged: (value) {
                      context.setLocale(const Locale('en'));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

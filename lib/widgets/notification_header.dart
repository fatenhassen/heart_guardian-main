import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';  
class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'today'.tr(),  
            style: TextStyle(
              color: isDark ? Colors.blue[200] : const Color(0xFFA0D1EF),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Agbalumo',
            ),
          ),
          Text(
            'mark_all_read'.tr(),  
            style: TextStyle(
              color: isDark ? Colors.blue[200] : const Color(0xFFA0D1EF),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Agbalumo',
            ),
          ),
        ],
      ),
    );
  }
}

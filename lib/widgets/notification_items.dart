import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; 

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title; 
  final String subtitle; 
  final String time;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : const Color(0XFFE8E8E8),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withOpacity(0.6)
                      : const Color(0XFF042D46).withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 2,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue[700] : const Color(0xFFA0D1EF),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  icon,
                  color: isDark ? Colors.white : const Color(0XFF042D46),
                  size: 28.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.tr(), 
                      style: TextStyle(
                        fontFamily: 'Agbalumo',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: isDark ? Colors.white : const Color(0XFF042D46),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle.tr(), 
                      style: TextStyle(
                        color:
                            isDark ? Colors.grey[400] : const Color(0XFF918C8C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0XFF000000),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Agbalumo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

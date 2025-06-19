import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.iconTheme.color ?? const Color(0xFF042D46);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Agbalumo',
                  fontSize: 16.0,
                  color: textColor,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (title != 'Dark Mode')
              Icon(Icons.arrow_forward_ios, color: iconColor),
          ],
        ),
      ),
    );
  }
}

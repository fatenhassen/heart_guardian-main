import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController fullNameController = TextEditingController(
    text: 'Faten hassan ',
  );
  bool isFullNameUpdated = false;
  bool _obscurePassword = true;
  TextEditingController birthdateController = TextEditingController(
    text: '20/03/2003',
  );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003, 7, 19),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthdateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _updateFullName() {
    if (fullNameController.text != ' Faten Hassan') {
      setState(() {
        isFullNameUpdated = true;
      });
    } else {
      setState(() {
        isFullNameUpdated = false;
      });
    }
  }

  void _updateProfile() async {
    String fullName = fullNameController.text;
    String _ = birthdateController.text;
    if (fullName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('empty_name_error'.tr())));
      return;
    }

    await Future.delayed(const Duration(seconds: 2));
    bool isSaveSuccessful = true;

    if (isSaveSuccessful) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('profile_updated_success'.tr())));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('profile_update_failed'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final fillColor = isDark ? Colors.grey[800] : const Color(0xFFE0F2F7);
    final bgColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor),
        title: Padding(
          padding: const EdgeInsets.only(left: 95, top: 10),
          child: Text(
            'my_profile'.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: textColor,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(color: textColor, width: 4.0),
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/Images/Profil.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFB3D9EF),
                      radius: 20,
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'full_name'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: fullNameController,
              onSubmitted: (_) => _updateFullName(),
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Alaa Elashmawi',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                suffixIcon: Icon(
                  Icons.check,
                  color:
                      isFullNameUpdated ? const Color(0XFF042D46) : Colors.grey,
                ),
                filled: true,
                fillColor: fillColor,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'email'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10.0),
            TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'alaa@gmail.com',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                filled: true,
                fillColor: fillColor,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'password'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10.0),
            TextField(
              obscureText: _obscurePassword,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '**********',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed:
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                ),
                filled: true,
                fillColor: fillColor,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'birthdate'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: birthdateController,
              readOnly: true,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '19/07/2003',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: () => _selectDate(context),
                ),
                filled: true,
                fillColor: fillColor,
              ),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 40.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF042D46),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'update_profile'.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

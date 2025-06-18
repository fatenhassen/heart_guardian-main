import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isFullNameUpdated = false;
  bool _obscurePassword = true;

  String originalFullName = '';
  String originalBirthdate = '';

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    final url = Uri.parse(
      'https://web-production-6fe6.up.railway.app/profile/${widget.userId}',
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          fullNameController.text = data['full_name'] ?? '';
          birthdateController.text = data['birthdate'] ?? '';
          emailController.text = data['email'] ?? '';
          passwordController.text = '**********';

          originalFullName = fullNameController.text;
          originalBirthdate = birthdateController.text;
        });
      } else {
        print('❌ فشل في جلب البيانات: ${response.statusCode}');
        print('الرد من السيرفر: ${response.body}');
      }
    } catch (e) {
      print('⚠️ خطأ أثناء جلب البيانات: $e');
    }
  }

  bool hasUnsavedChanges() {
    return fullNameController.text.trim() != originalFullName.trim() ||
        birthdateController.text.trim() != originalBirthdate.trim();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003, 7, 19),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF042D46),
              onPrimary: Colors.white,
              surface:
                  isDark ? (Colors.grey[800] ?? Colors.grey) : Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat(
        'dd/MM/yyyy',
        context.locale.toString(),
      ).format(picked);
      setState(() => birthdateController.text = formattedDate);
    }
  }

  void _updateFullName() {
    setState(() {
      isFullNameUpdated = fullNameController.text != originalFullName;
    });
  }

  Future<void> _updateProfile() async {
    final fullName = fullNameController.text.trim();
    final birthdate = birthdateController.text.trim();

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('empty_name_error'.tr())));
      return;
    }

    final url = Uri.parse(
      'https://web-production-6fe6.up.railway.app/profile/${widget.userId}',
    );
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'full_name': fullName, 'birthdate': birthdate}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('profile_updated_success'.tr())));
        getUserProfile(); // ✅ إعادة تحميل البيانات بعد التحديث
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('profile_update_failed'.tr())));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('network_error'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final fillColor =
        isDark ? (Colors.grey[800] ?? Colors.grey) : const Color(0xFFE0F2F7);
    final bgColor = theme.scaffoldBackgroundColor;

    return WillPopScope(
      onWillPop: () async {
        if (hasUnsavedChanges()) {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('تنبيه'),
                  content: const Text(
                    'لديك تغييرات لم يتم حفظها. هل تريد الخروج بدون حفظ؟',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('خروج'),
                    ),
                  ],
                ),
          );
          return shouldExit ?? false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: textColor),
          title: Center(
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor:
                            isDark ? Colors.blueGrey : const Color(0xFFB3D9EF),
                        radius: 20,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildLabeledField(
                label: 'full_name'.tr(),
                controller: fullNameController,
                hint: 'Alaa Elashmawi',
                textColor: textColor,
                fillColor: fillColor,
                onSubmitted: (_) => _updateFullName(),
                suffixIcon: Icon(
                  Icons.check,
                  color:
                      isFullNameUpdated ? const Color(0xFF042D46) : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              _buildLabeledField(
                label: 'email'.tr(),
                controller: emailController,
                hint: 'alaa@gmail.com',
                textColor: textColor,
                fillColor: fillColor,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              _buildLabeledField(
                label: 'password'.tr(),
                controller: passwordController,
                hint: '**********',
                textColor: textColor,
                fillColor: fillColor,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed:
                      () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                ),
              ),
              const SizedBox(height: 20),
              _buildLabeledField(
                label: 'birthdate'.tr(),
                controller: birthdateController,
                hint: '19/07/2003',
                textColor: textColor,
                fillColor: fillColor,
                readOnly: true,
                onTap: () => _selectDate(context),
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 40),
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
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required Color textColor,
    required Color fillColor,
    bool readOnly = false,
    bool obscureText = false,
    Widget? suffixIcon,
    void Function(String)? onSubmitted,
    void Function()? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscureText,
          onSubmitted: onSubmitted,
          onTap: onTap,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fillColor,
          ),
        ),
      ],
    );
  }
}

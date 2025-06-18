import 'package:flutter/material.dart';
import 'package:heart_guardian/screen/login_view.dart'; // تأكدي أن هذا المسار صحيح
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPassword extends StatefulWidget {
  final String email;
  final String resetToken; // هذا السطر لاستقبال الـ resetToken

  const ResetPassword({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _submitNewPassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse(
      'https://web-production-6fe6.up.railway.app/api/v1/password/reset',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "email": widget.email,
        "newPassword": password, // تم تغيير اسم الحقل ليطابق الباك-اند
        "confirmNewPassword":
            confirmPassword, // تم تغيير اسم الحقل ليطابق الباك-اند
        "resetToken": widget.resetToken, // هذا السطر يرسل الـ resetToken
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false,
      );
    } else {
      final error = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['message'] ?? 'Something went wrong')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA0D1EF),
        title: const Text(
          'New Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            const Text(
              'Enter your new password below',
              style: TextStyle(
                fontFamily: 'Agbalumo',
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF656363),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                filled: true,
                fillColor: Colors.white,
                labelStyle: const TextStyle(
                  color: Color(0xFFA0D1EF),
                  fontFamily: 'Agbalumo',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: Color(0xFF042D46)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                filled: true,
                fillColor: Colors.white,
                labelStyle: const TextStyle(
                  color: Color(0xFFA0D1EF),
                  fontFamily: 'Agbalumo',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: Color(0xFF042D46)),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitNewPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF042D46),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 9,
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontFamily: 'Agbalumo',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

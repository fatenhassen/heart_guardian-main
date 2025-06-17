import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPassword extends StatefulWidget {
  final String token; // استلام التوكن من الرابط

  const ResetPassword({super.key, required this.token, required String resetCode});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _submitNewPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Please fill in both fields');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse(
      'https://web-production-6fe6.up.railway.app/reset-password/${widget.token}',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'password': password}),
      );

      if (response.statusCode == 200) {
        _showMessage('Password has been reset successfully');
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        _showMessage('Failed to reset password: ${response.body}');
      }
    } catch (e) {
      _showMessage('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
              decoration: _inputDecoration('New Password'),
              style: const TextStyle(color: Color(0xFF042D46)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: _inputDecoration('Confirm Password'),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(
        color: Color(0xFFA0D1EF),
        fontFamily: 'Agbalumo',
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

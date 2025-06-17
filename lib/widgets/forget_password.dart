import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heart_guardian/widgets/VerifyCodeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> sendResetEmail(String email) async {
    final url = Uri.parse(
      'https://web-production-6fe6.up.railway.app/api/v1/password/forgot',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reset code has been sent to your email"),
          ),
        );

        await openEmailApp(); // ✅ فتح الإيميل مباشرة بعد الإرسال

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VerifyCodeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send reset code")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("An error occurred")));
    }
  }

  Future<void> openEmailApp() async {
    final Uri gmailUri = Uri.parse("googlegmail://");
    final Uri mailtoUri = Uri(scheme: 'mailto');

    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(gmailUri);
    } else if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No email app found")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA0D1EF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Forget Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              const Text(
                'Enter your email address to receive a password reset code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Agbalumo',
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF656363),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  hintText: 'Email address',
                  filled: true,
                  fillColor: const Color(0xFFA0D1EF),
                  hintStyle: const TextStyle(
                    fontFamily: 'Agbalumo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF042D46),
                      width: 3.5,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Agbalumo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF042D46),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 9,
                  ),
                  onPressed: () {
                    final email = _emailController.text.trim();
                    if (email.isNotEmpty) {
                      sendResetEmail(email);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter your email"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Send Email',
                    style: TextStyle(
                      fontFamily: 'Agbalumo',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: openEmailApp,
                icon: const Icon(Icons.mail_outline, color: Color(0xFF042D46)),
                label: const Text(
                  "Open Email App",
                  style: TextStyle(
                    color: Color(0xFF042D46),
                    fontFamily: 'Agbalumo',
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

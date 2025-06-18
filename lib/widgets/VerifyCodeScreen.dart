import 'package:flutter/material.dart';
import 'package:heart_guardian/widgets/reset_password.dart'; // تأكدي أن هذا المسار صحيح
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _verifyCode() async {
    String enteredCode = _controllers.map((c) => c.text).join();

    if (enteredCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the 6-character code")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
      'https://web-production-6fe6.up.railway.app/api/v1/password/verify-reset-code',
    );

    print("📩 Email being sent: ${widget.email}");
    print("🔐 Entered code: $enteredCode");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        // تم التعديل هنا: "resetCode" أصبح "code" ليتوافق مع الباك-اند
        body: jsonEncode({"email": widget.email, "code": enteredCode}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Code verified")),
        );

        // تم التعديل هنا: تمرير resetToken إلى شاشة ResetPassword
        // تأكدي أن الباك-اند يرسل 'resetToken' في حالة النجاح
        final String resetToken = data['resetToken'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ResetPassword(email: widget.email, resetToken: resetToken),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Invalid code")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildCodeField(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: _controllers[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          fontFamily: 'Agbalumo',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA0D1EF),
        title: const Text(
          'Verify Code',
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
          children: [
            const SizedBox(height: 25),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF656363),
                  fontFamily: 'Agbalumo',
                ),
                children: [
                  const TextSpan(text: 'Enter the 6-character code sent to\n'),
                  TextSpan(
                    text: widget.email,
                    style: const TextStyle(color: Color(0xFF042D46)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, _buildCodeField),
            ),
            const SizedBox(height: 45),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyCode,
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
                          'Verify',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Agbalumo',
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

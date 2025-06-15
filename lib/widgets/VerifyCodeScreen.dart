import 'package:flutter/material.dart';

import 'package:heart_guardian/widgets/forget_password.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  void _verifyCode() {
    String enteredCode = _controllers.map((c) => c.text).join();

    if (enteredCode.length == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the 4-digit code")),
      );
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildCodeField(int index) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: _controllers[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontFamily: 'Agbalumo',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
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
            const Text(
              'Enter the 4-digit code sent to your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF656363),
                fontFamily: 'Agbalumo',
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, _buildCodeField),
            ),
            const SizedBox(height: 45),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF042D46),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 9,
                ),
                child: const Text(
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

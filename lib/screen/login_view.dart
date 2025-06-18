import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:heart_guardian/widgets/forget_password.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_view.dart';
import 'signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isObscured = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    final url = Uri.parse('https://web-production-6fe6.up.railway.app/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final int userId = responseData['user_id'];
        await prefs.setInt('user_id', userId);

        // ✅ جلب البيانات من الرد إذا كانت موجودة
        final fullName = responseData['full_name'];
        final birthdate = responseData['birthdate'];

        // ✅ إرسال البيانات إلى البروفايل مباشرة
        if (fullName != null && birthdate != null) {
          final profileUrl = Uri.parse(
            'https://web-production-6fe6.up.railway.app/profile/$userId',
          );
          await http.put(
            profileUrl,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'full_name': fullName, 'birthdate': birthdate}),
          );
        }

        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFF042D46),
                          width: 5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            tr("login_success"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF042D46),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        );

        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.of(context)
          ..pop()
          ..pushReplacement(
            MaterialPageRoute(builder: (context) => HomeView(userId: userId)),
          );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? tr("login_failed")),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr("error_connecting"))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isDark
                    ? [Colors.black87, Colors.black]
                    : [const Color(0xFFA0D1EF), const Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr("welcome_text"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: tr("email"),
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          labelText: tr("password"),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const ForgetPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            tr("forgot_password"),
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF042D46),
                        ),
                        child: ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            tr("sign_in"),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpView(),
                      ),
                    );
                  },
                  child: Text(
                    tr("dont_have_account"),
                    style: const TextStyle(
                      color: Color(0xFF848383),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

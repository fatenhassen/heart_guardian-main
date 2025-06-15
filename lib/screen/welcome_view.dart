import 'package:flutter/material.dart';
import 'package:heart_guardian/screen/login_view.dart';
import 'package:heart_guardian/screen/signup_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
 
import 'package:heart_guardian/services/google_auth_service.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA0D1EF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              _buildButton(
                context,
                "SIGN IN",
                LoginView(),
                width: screenWidth * 0.9,
              ),
              const SizedBox(height: 20),
              _buildButton(
                context,
                "SIGN UP",
                SignUpView(),
                isFilled: true,
                textColor: Color(0xFF042D46),
                backgroundColor: Colors.white,
                width: screenWidth * 0.9,
              ),
              const SizedBox(height: 60),
              const Text(
                "Login with Social Media",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF848383),
                  fontFamily: 'Agbalumo',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.telegram_outlined,
                      color: Color(0xFF0088CC),
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(
                      Icons.facebook,
                      color: Color(0xFF3B5998),
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () async {
                      final userCredential =
                          await GoogleAuthService().signInWithGoogle();
                      if (userCredential != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('فشل تسجيل الدخول باستخدام Google'),
                          ),
                        );
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/icons/google.svg',
                      height: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Widget screen, {
    bool isFilled = true,
    Color textColor = Colors.white,
    Color backgroundColor = const Color(0xFF042D46),
    Color? borderColor,
    double? width,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: width ?? 200,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isFilled ? backgroundColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:heart_guardian/screen/home_view.dart';

class OpenCameraScreen extends StatefulWidget {
  final String cameraIp;
  final int userId;

  const OpenCameraScreen({
    super.key,
    required this.cameraIp,
    required this.userId,
  });

  @override
  State<OpenCameraScreen> createState() => _OpenCameraScreenState();
}

class _OpenCameraScreenState extends State<OpenCameraScreen> {
  late final WebViewController _settingsController;
  Uint8List? _imageBytes;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _settingsController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..enableZoom(true)
          ..loadRequest(Uri.parse('http://${widget.cameraIp}'));

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _fetchFrame();
    });
  }

  Future<void> _fetchFrame() async {
    try {
      final response = await http.get(
        Uri.parse('http://${widget.cameraIp}/capture'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _imageBytes = response.bodyBytes;
        });
      }
    } catch (e) {
      // تجاهل الخطأ
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA0D1EF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeView(userId: widget.userId),
              ),
            );
          },
        ),
        title: const Text(
          'Camera Control & Live View',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: WebViewWidget(controller: _settingsController),
          ),

          const VerticalDivider(width: 1, color: Colors.grey),

          Expanded(
            flex: 2,
            child:
                _imageBytes == null
                    ? const Center(child: Text('Loading live stream...'))
                    : Image.memory(
                      _imageBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
          ),
        ],
      ),
    );
  }
}
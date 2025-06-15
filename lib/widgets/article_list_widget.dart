import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article.dart';

class ArticleListWidget extends StatelessWidget {
  final List<Article> articles;

  const ArticleListWidget({super.key, required this.articles});

  // دالة لتعديل رابط يوتيوب عشان يكون صالح للفتح
  String fixYouTubeUrl(String url) {
    if (url.contains("youtube.com/embed/")) {
      // نحول رابط embed إلى رابط مشاهدة عادي
      final videoId = url.split('/embed/').last;
      return 'https://www.youtube.com/watch?v=$videoId';
    }
    return url;
  }

  void _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      print('الرابط فارغ أو غير صالح');
      return;
    }

    url = fixYouTubeUrl(url);

    final uri = Uri.tryParse(url);
    if (uri == null) {
      print('الرابط غير قابل للتحليل: $url');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        print('فشل في فتح الرابط: $url');
      }
    } catch (e) {
      print('حدث خطأ أثناء محاولة فتح الرابط: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/Images/mother.png', fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          ListView.builder(
            itemCount: articles.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                elevation: 10,
                shadowColor: const Color(0xFF6C9FBB),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F657C),
                        ),
                      ),
                      const SizedBox(height: 0.5),

                      // الوصف
                      Text(
                        article.description,
                        style: GoogleFonts.agbalumo(
                          fontSize: 15,
                          color: const Color(0xFF656363),
                        ),
                      ),
                      const SizedBox(height: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.play_circle, color: Color(0xFF042D46)),
                              SizedBox(width: 5),
                              Text(
                                "Watch Video",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Icon(Icons.menu_book, color: Color(0xFF042D46)),
                              SizedBox(width: 5),
                              Text(
                                "Read Article",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // روابط Click Here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => _launchURL(article.videoUrl),
                            child: Text(
                              "Click Here",
                              style: GoogleFonts.agbalumo(
                                fontSize: 17,
                                color: const Color(0xFF6C9FBB),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _launchURL(article.link),
                            child: Text(
                              "Click Here",
                              style: GoogleFonts.agbalumo(
                                fontSize: 17,
                                color: const Color(0xFF6C9FBB),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

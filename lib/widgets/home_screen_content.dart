import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/blogs_section_widget.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference bpmRef = FirebaseDatabase.instance.ref(
      "sensorData/BPM",
    );
    final DatabaseReference spo2Ref = FirebaseDatabase.instance.ref(
      "sensorData/SpO2",
    );

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              tr('app_title'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                shadows: const [
                  Shadow(
                    blurRadius: 8.0,
                    color: Color(0xFF6BAED6),
                    offset: Offset(2, 3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<DatabaseEvent>(
                        stream: spo2Ref.onValue,
                        builder: (context, snapshot) {
                          final value = snapshot.data?.snapshot.value;
                          return _buildDataItem(
                            title: tr('oxygen_percentage'),
                            valueWidget:
                                value != null
                                    ? Text(
                                      '$value %',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF042D46),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    )
                                    : const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: StreamBuilder<DatabaseEvent>(
                        stream: bpmRef.onValue,
                        builder: (context, snapshot) {
                          final value = snapshot.data?.snapshot.value;
                          return _buildDataItem(
                            title: tr('heartbeats'),
                            valueWidget:
                                value != null
                                    ? Text(
                                      '$value bpm',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF042D46),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    )
                                    : const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
              child: Text(
                '${tr('blogs')} :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
            const BlogsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem({required String title, required Widget valueWidget}) {
    return Card(
      color: const Color(0xFF6BAED6).withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            Flexible(child: valueWidget),
          ],
        ),
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

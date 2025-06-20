import 'package:firebase_database/firebase_database.dart';
import 'package:heart_guardian/services/notifiction_service.dart';
 

class HeartMonitorService {
  static void startMonitoring() {
    final databaseRef = FirebaseDatabase.instance.ref('SensorData/BPM');

    databaseRef.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        final bpm = int.tryParse(value.toString());
        if (bpm != null && (bpm < 60 || bpm > 120)) {
          NotificationService.showHeartRateAlert(bpm);
        }
      }
    });
  }
}
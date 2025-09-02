import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../generated/collections.dart';
import '../generated/pref_manager.dart';

Future<void> sendNotifications({
  required String notificationTitle,
  required String notificationBody,
  required String userId,
}) async {
  final manager = PrefManager();
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection(FCM_COLLECTION)
            .where(FCM_USER_ID, isEqualTo: userId)
            .get();

    List<String> tokens =
        snapshot.docs.map((doc) => doc['token'] as String).toList();

    if (tokens.isEmpty) {
      log('No FCM tokens found.');
      return;
    }
    final tokenUrl = Uri.parse(
      'https://shubhamsingh.in/sit_crm/api/select/get_token.php',
    );
    final response = await http.get(tokenUrl);
    log('Token response status: ${response.statusCode}');
    log('Token response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String accessToken = data['access_token'];

      final projectId = 'frubix-6712a';
      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
      );

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      for (String token in tokens) {
        final body = jsonEncode({
          "message": {
            "token": token,
            "notification": {
              "title": notificationTitle,
              "body": notificationBody,
            },
            "android": {
              "priority": "high",
              "notification": {"click_action": "FLUTTER_NOTIFICATION_CLICK"},
            },
            "apns": {
              "payload": {
                "aps": {"category": "FLUTTER_NOTIFICATION_CLICK"},
              },
            },
            "data": {"id": "1", "status": "done"},
          },
        });

        final fcmResponse = await http.post(url, headers: headers, body: body);

        if (fcmResponse.statusCode == 200) {
          log('Notification sent to $token');
        } else {
          log('Failed to send to $token. Status: ${fcmResponse.statusCode}');
          log('Response: ${fcmResponse.body}');
        }
      }
    } else {
      log('Failed to fetch access token. Status: ${response.statusCode}');
      log('Response: ${response.body}');
    }
  } catch (e) {
    log('FCM ERROR: $e');
  }
}

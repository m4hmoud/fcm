import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FcmController {
  sendNotification(String title, String desc, String topic) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAyQns6Fk:APA91bFAPOuPk7ZMmBddJ8tAg6FFLEcGbvlOI-u1JxtMG6xot5t7aXX_MBR2xCSdFdFADoWb2cBQ_FbRzv6vmcH29oz0x8GeXqQ7rfa4ut5J_uJixvA-KwRb3uih62xBKtFjLYrb3Opf'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": "/topics/$topic",
      "notification": {
        "title": title,
        "body": desc,
      }
    };

    var req = Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
    } else {
      debugPrint(resBody);
    }
  }
}

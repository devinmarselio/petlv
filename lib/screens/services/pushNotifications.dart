import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class PushNotifications {
  static Future<String> getAccessTokens() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "petlv-db",
      "private_key_id": "c4ce5554c2e5ada16f9cdb13a43fa3c1c1c2805d",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCzVPiWRF3gFkYx\n2SbHJPMXDDPyKZTriJQQ490eUPWQjXUEZNh3C1G1A5SY2qQTrOI36pVr+XgXc6n7\nlVHAngTOPAzo+vryppOCHAsz5NT5OBJNEX2q01rwEeKR67FeXS/mQfmR8hABIHhC\njYUEf1B9k7IPkxPuBnz5LBQDxuDsQJj9VmmEMJm/0CRHLdgZ1ovi5SiZyhFckz/+\nlF4wQDURnFbP5DRZXnL/LVSzm8ubmHqeySMyBPUByX6g0LI4fWkwR5Nmqe2QVWf4\n24ztIF+W8WFqlK0I9AQSdIzOFLp/BZc5EFeqo8RjvAQLPhi1afuf0vRrWNOj7OcF\ntZ4nznJPAgMBAAECggEASzNEku7UVtXAVcLzyeqqrW2GkvPw6Nv7CyIiZUYZ06Yd\n/du0EieC+d8ofvigeUe0DTKnugGA5ISyMTeqcpVQ+pKf70rf1MUZciQEZpx82o0y\nz3KYOfwrVCSL2Bj35dQ589qSpyrUn0RYacAimYIx5Jb8wh8w6k16NprPQc4yH585\n+wLS3dL9oOjGzR9H46X0yHI4XGd3Du7ZF4041SpAFmrdaiMU2FM5vrBY4p++CU6e\nJkoxPbz3qqp2pF7xntsTlc3v6VDKvpYeAYEMSSLtkMOJ42n9Yfx3FWfO75Ookqef\n8Y1hxTz7rQJVuV0yh2KX25Y7vUlisc0G7j7W8myn0QKBgQDyN8D5/gMRvunoV17B\nJyrKaNBDOq56Xhd1yl2Y2DNNre+gsJ5M1rksFCR9mMG4Pfoq3f8gZP44IPMBcPS8\nfOGFwXATwCraGY/lv9HRNff0pZwTcYUMZEF/p9ZjCgs8wHdTFKOfoTjgIQsELlfg\n4e89DPiPR3D/SjwWU7BeA72LRQKBgQC9iTH4HbM1lWq8bnBYQeODMRjbUuzVJCx2\nI9W9g/1HqjgRdSLG5OIHr/mynhjV0d2o7aEVmX4lOv0w1PcpCvL//DHlV4jIKm9R\nrPJHkm0VMKEDKb5MameAWzPDCymNe+6BUD/miE1RFKMTY+x10pMjfiKhnnIatMu6\nsx8xCdtWgwKBgAt29B1hFogafzvOFuARmIboGyNzfZqxJW8f2vpHEXaVywfSFEwS\nxcT+VxPSzSiJVnP8+fxwi0/gz1+8Fvls98e69jEZIW4dU6BOSgIbCdd8lzycXO3P\nOQJv0Ufyy8FeYsd97Ji7qtOA/OJ/xw0P5KEBIiq1+PU8cEemQmzQxIH5AoGBAJ+x\nYqq8y2vQUrglDP8vtLOqwFi6y9Thv5xioQomlVa2crsyyHRwEImNmYMHdcFiK7LT\nVK/QPdq8kut75CtukENih9/GGvcb2eMlJpVrKAF8kY0KtM3JsR8SuNATLZWJ3/CQ\nXuar3Qj9rFEAFhFHtLVo52DpERazUhwiI5u7xFRlAoGBAMfQ1dQGbzXgQaTKsfMH\na1iJzJfZlL4NyMzAcaGULJDpMbtYxMKOQ33mnq2qo8it9KRFzFAlHfcGbLCl1RDC\nLoAEN9gHFZ5jpiRaNsQwKh+gaDWF7vNAUdJQOLpdOeBexcvY4IeaSoA6Afq2mvDB\nY5fc96deM6NBnxNS9qdiMYUF\n-----END PRIVATE KEY-----\n",
      "client_email":
          "petlv-messaging-handler@petlv-db.iam.gserviceaccount.com",
      "client_id": "109477142918184083189",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/petlv-messaging-handler%40petlv-db.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email"
          "https://www.googleapis.com/auth/firebase.database"
          "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotificationToUser(
      String deviceToken, BuildContext context) async {
    final String serverKey = await getAccessTokens();
    String endPointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/petlv-db/message:send';

    final Map<String, dynamic> message = {
      'message':
      {
        'token': deviceToken,
        'notification':
        {
          'title': "New comment on your post!",
          'body': "Check out the new comment on your post!",
        },
        'data':
        {
          'postId' : 'Testing',
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endPointFirebaseCloudMessaging),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode!= 200) {
      print('Error sending notification: ${response.statusCode}');
    }
  }
}

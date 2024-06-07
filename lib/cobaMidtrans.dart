import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class MidTrans extends StatefulWidget {
  const MidTrans({super.key});

  @override
  State<MidTrans> createState() => _MidTransState();
}

class _MidTransState extends State<MidTrans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Pay Now"),
          onPressed: () => PayNow(),
        ),
      ),
    );
  }

  void PayNow() async {
    Map<String, dynamic> requestBody = {
      "transaction_details": {
        "order_id": "YOUR-ORDERID-7",
        "gross_amount": 10000
      },
      "customer_details": {
        "first_name": "budi",
        "last_name": "pratama",
        "email": "budi.pra@example.com",
        "phone": "08111222333"
      }
    };

    String url =
        'https://app.sandbox.midtrans.com/snap/v1/transactions'; // Ganti dengan URL API Anda

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Basic U0ItTWlkLXNlcnZlci1VZ3hWLXRibUF1eklhN3AzM2ZrbGZOMUU='
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        debugPrint(json['redirect_url']);
        launchUrl(Uri.parse(json['redirect_url']));
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
}

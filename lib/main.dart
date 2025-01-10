import 'package:flutter/material.dart';
import 'package:frontend/views/pages/dashBoardStoreOwner_page.dart';
import 'package:frontend/views/pages/payment_page.dart';
import 'package:frontend/views/pages/initialization_page.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import '../helpers/user_helper.dart';
import 'dart:convert';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  Map<String, dynamic>? _paymentPageData; // Save payment data for redirection

  @override
  void initState() {
    super.initState();
    _handleDeepLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleDeepLinks() {
    String? processedOrderId; // Track processed order IDs

    _sub = uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        print("Received deep link: ${uri.toString()}");

        final token = uri.queryParameters['token'];

        if (token != null && token != processedOrderId) {
          processedOrderId = token; // Mark this order ID as processed

          if (uri.host == "paypal-success") {
            await _handlePayPalSuccess(uri);
          } else if (uri.host == "paypal-cancel") {
            _handlePayPalCancel();
          }
        } else {
          print("Duplicate deep link or missing token. Ignoring.");
        }
      }
    }, onError: (err) {
      print("Error in deep link handling: $err");
    });
  }

  Future<void> _handlePayPalSuccess(Uri uri) async {
    final token = uri.queryParameters['token'];
    final payerID = uri.queryParameters['PayerID'];

    if (token != null && payerID != null) {
      try {
        final captureResponse = await userApiHelper.get(
          'users/signup/payPal-return?token=$token',
        );

        if (captureResponse.statusCode == 200) {
          final responseBody = json.decode(captureResponse.body);
          final userToken = responseBody['token'];

          if (userToken != null) {
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                builder: (context) => DashboardStoreOwnerPage(token: userToken),
              ),
            );
          } else {
            print("Token is missing in the backend response.");
          }
        } else {
          print("Failed to capture PayPal payment: ${captureResponse.body}");
        }
      } catch (e) {
        print("Error during PayPal success handling: $e");
      }
    } else {
      print("Token or PayerID is missing in the deep link.");
    }
  }

  void _handlePayPalCancel() {
    if (_paymentPageData != null) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            username: _paymentPageData!['username'],
            email: _paymentPageData!['email'],
            password: _paymentPageData!['password'],
            confirmPassword: _paymentPageData!['confirmPassword'],
            condition: _paymentPageData!['condition'],
            role: _paymentPageData!['role'],
            plan: _paymentPageData!['plan'],
          ),
        ),
      );
    } else {
      print("Payment page data is missing for redirection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Use the navigatorKey
      debugShowCheckedModeBanner: false,
      home: InitializationPage(),
    );
  }
}

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> createBancolombiaTransferTransaction(
  String privateKey,
  String acceptanceToken,
  int amountInCents,
  String currency,
  String customerEmail,
  String referenceId,
  bool isProduction,
) async {
  try {
    final baseUrl = isProduction
        ? 'https://production.wompi.co/v1'
        : 'https://sandbox.wompi.co/v1';

    final requestBody = {
      'acceptance_token': acceptanceToken.trim(),
      'amount_in_cents': amountInCents,
      'currency': currency.toUpperCase(),
      'customer_email': customerEmail.trim(),
      'reference': referenceId.trim(),
      'payment_method': {
        'type': 'BANCOLOMBIA_TRANSFER',
        'payment_description': 'Pago con Bancolombia',
        'user_type': 'PERSON',
      }
    };

    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: {
        'Authorization': 'Bearer $privateKey',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'error': errorData['error']?.toString() ?? 'Error al crear transacción',
        'statusCode': response.statusCode,
        'details': errorData,
      };
    }

    final data = jsonDecode(response.body)['data'];
    final asyncPaymentUrl =
        data['payment_method']['extra']['async_payment_url'];

    return {
      'success': true,
      'transactionId': data['id'],
      'status': data['status'],
      'asyncPaymentUrl': asyncPaymentUrl,
      'amount': data['amount_in_cents'],
      'currency': data['currency'],
      'customerEmail': data['customer_email'],
      'reference': data['reference'],
    };
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

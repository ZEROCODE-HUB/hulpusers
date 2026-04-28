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

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> createPaymentSource(
  String privateKey,
  String cardToken,
  String acceptanceToken,
  String customerEmail,
  bool isProduction,
) async {
  try {
    // Validaciones básicas
    if (cardToken.trim().isEmpty) {
      return {
        'success': false,
        'error': 'Token de tarjeta requerido',
        'field': 'cardToken'
      };
    }

    if (acceptanceToken.trim().isEmpty) {
      return {
        'success': false,
        'error': 'Token de aceptación requerido',
        'field': 'acceptanceToken'
      };
    }

    if (customerEmail.trim().isEmpty || !customerEmail.contains('@')) {
      return {
        'success': false,
        'error': 'Email válido requerido',
        'field': 'customerEmail'
      };
    }

    // Validar formato de private key
    if (!privateKey.startsWith('prv_')) {
      return {
        'success': false,
        'error': 'Formato de private key inválido. Debe empezar con "prv_"',
        'field': 'privateKey'
      };
    }

    // Determinar la URL base
    final baseUrl = isProduction
        ? 'https://production.wompi.co/v1'
        : 'https://sandbox.wompi.co/v1';

    // Preparar el body de la petición
    final requestBody = {
      'type': 'CARD',
      'token': cardToken,
      'customer_email': customerEmail.trim().toLowerCase(),
      'acceptance_token': acceptanceToken,
    };

    // DEBUGGING - Imprimir información de la petición
    print('=== DEBUGGING WOMPI REQUEST ===');
    print('URL: $baseUrl/payment_sources');
    print('Private Key (primeros 15 chars): ${privateKey.substring(0, 15)}...');
    print('Card Token: $cardToken');
    print('Acceptance Token: $acceptanceToken');
    print('Customer Email: ${customerEmail.trim().toLowerCase()}');
    print('Request Body: ${jsonEncode(requestBody)}');
    print('================================');

    // Hacer la petición POST para crear el payment source
    final response = await http.post(
      Uri.parse('$baseUrl/payment_sources'),
      headers: {
        'Authorization': 'Bearer $privateKey',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    // DEBUGGING - Imprimir respuesta
    print('=== DEBUGGING WOMPI RESPONSE ===');
    print('Response Status: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');
    print('=================================');

    // Decodificar la respuesta
    final responseData = jsonDecode(response.body);

    // Verificar si la creación fue exitosa
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'paymentSourceId': responseData['data']['id'],
        'status': responseData['data']['status'],
        'type': responseData['data']['type'],
        'customerEmail': responseData['data']['customer_email'],
        'publicData': responseData['data']['public_data'],
        'createdAt': responseData['data']['created_at'],
        'message': 'Payment Source creado exitosamente',
        'fullData': responseData['data']
      };
    } else {
      return {
        'success': false,
        'error': responseData['error']?.toString() ??
            'Error desconocido al crear Payment Source',
        'statusCode': response.statusCode,
        'details': responseData,
        'requestSent': requestBody, // Para debugging
        'errorMessage':
            responseData['error']?['message'] ?? 'Sin mensaje de error',
        'errorType': responseData['error']?['type'] ?? 'Sin tipo de error',
        'errorReasons': responseData['error']?['reasons'] ?? []
      };
    }
  } catch (e) {
    print('=== ERROR EN CREATEPAYMENTSOURCE ===');
    print('Error: ${e.toString()}');
    print('Stack trace: ${StackTrace.current}');
    print('=====================================');

    return {
      'success': false,
      'error': 'Error de conexión: ${e.toString()}',
      'statusCode': 0
    };
  }
}

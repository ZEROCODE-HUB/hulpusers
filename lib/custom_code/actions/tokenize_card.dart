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

Future<dynamic> tokenizeCard(
  String publicKey,
  String cardNumber,
  String expMonth,
  String expYear,
  String cvc,
  String cardHolder,
  bool isProduction,
) async {
  try {
    // Limpiar el número de tarjeta (remover espacios y caracteres especiales)
    final cleanCardNumber = cardNumber.replaceAll(RegExp(r'[\s-]'), '');

    // Validaciones básicas
    if (cleanCardNumber.length < 13 || cleanCardNumber.length > 19) {
      return {
        'success': false,
        'error': 'Número de tarjeta inválido',
        'field': 'cardNumber'
      };
    }

    if (expMonth.length != 2 ||
        int.tryParse(expMonth) == null ||
        int.parse(expMonth) < 1 ||
        int.parse(expMonth) > 12) {
      return {
        'success': false,
        'error': 'Mes de expiración inválido (formato: MM)',
        'field': 'expMonth'
      };
    }

    if (expYear.length != 2 || int.tryParse(expYear) == null) {
      return {
        'success': false,
        'error': 'Año de expiración inválido (formato: YY)',
        'field': 'expYear'
      };
    }

    if (cvc.length < 3 || cvc.length > 4 || int.tryParse(cvc) == null) {
      return {
        'success': false,
        'error': 'CVC inválido (3 o 4 dígitos)',
        'field': 'cvc'
      };
    }

    if (cardHolder.trim().length < 2) {
      return {
        'success': false,
        'error': 'Nombre del titular muy corto',
        'field': 'cardHolder'
      };
    }

    // Determinar la URL base
    final baseUrl = isProduction
        ? 'https://production.wompi.co/v1'
        : 'https://sandbox.wompi.co/v1';

    // Preparar el body de la petición
    final requestBody = {
      'number': cleanCardNumber,
      'exp_month': expMonth,
      'exp_year': expYear,
      'cvc': cvc,
      'card_holder': cardHolder.trim(),
    };

    // Hacer la petición POST para tokenizar
    final response = await http.post(
      Uri.parse('$baseUrl/tokens/cards'),
      headers: {
        'Authorization': 'Bearer $publicKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    // Decodificar la respuesta
    final responseData = jsonDecode(response.body);

    // Verificar si la tokenización fue exitosa
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Verificar que el status sea CREATED
      if (responseData['status'] == 'CREATED') {
        return {
          'success': true,
          'token': responseData['data']['id'],
          'brand': responseData['data']['brand'],
          'lastFour': responseData['data']['last_four'],
          'cardName': responseData['data']['name'],
          'expiresAt': responseData['data']['expires_at'],
          'message': 'Tarjeta tokenizada exitosamente',
          'fullData': responseData['data']
        };
      } else {
        return {
          'success': false,
          'error': 'Error en tokenización: ${responseData['status']}',
          'details': responseData
        };
      }
    } else {
      return {
        'success': false,
        'error': responseData['error']?.toString() ??
            'Error desconocido en tokenización',
        'statusCode': response.statusCode,
        'details': responseData
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': 'Error de conexión: ${e.toString()}',
      'statusCode': 0
    };
  }
}

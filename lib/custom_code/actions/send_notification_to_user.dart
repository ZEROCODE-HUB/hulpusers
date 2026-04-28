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

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> sendNotificationToUser(
  String userId,
  String title,
  String message,
) async {
  try {
    // 1. Obtener el player_id del usuario desde Supabase
    final response = await SupaFlow.client
        .from('user_notifications')
        .select('player_id')
        .eq('user_id', userId)
        .single();

    if (response == null || response['player_id'] == null) {
      print('❌ No se encontró player_id para el usuario: $userId');
      return false;
    }

    final String playerId = response['player_id'];
    print('📱 Enviando notificación a Player ID: $playerId');

    // 2. Enviar notificación via OneSignal REST API
    final notificationResponse = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic os_v2_app_7oqzfd4llbcddhwoqchoqbmvglo6hcdx326u6z4up2z3inizrvplcqth73zogzladhmzprwk7rrvlenjpeztxg4nbwtwy3dyrqnczxi',
      },
      body: jsonEncode({
        'app_id': 'fba1928f-8b58-4431-9ece-808ee8059532',
        'include_player_ids': [playerId],
        'contents': {'en': message},
        'headings': {'en': title},
        'data': {
          'sent_from': 'flutterflow_app',
          'timestamp': DateTime.now().toIso8601String(),
        },
      }),
    );

    if (notificationResponse.statusCode == 200) {
      print('✅ Notificación enviada exitosamente');
      print('Response: ${notificationResponse.body}');
      return true;
    } else {
      print(
          '❌ Error enviando notificación: ${notificationResponse.statusCode}');
      print('Response body: ${notificationResponse.body}');
      return false;
    }
  } catch (e) {
    print('❌ Error en sendNotificationToUser: $e');
    return false;
  }
}

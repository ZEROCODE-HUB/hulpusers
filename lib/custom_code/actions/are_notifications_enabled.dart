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
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<bool> areNotificationsEnabled() async {
  try {
    final tags = await OneSignal.User.getTags();
    final value = tags['notifications_enabled'];

    print('🔍 Tag actual: notifications_enabled = $value');

    // Verificamos si el valor es exactame
    return value == 'true';
  } catch (e) {
    print('❌ Error obteniendo el tag: $e');
    return false; // o manejarlo como null según tu lógica
  }
}

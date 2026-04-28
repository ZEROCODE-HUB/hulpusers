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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> checkEmail(String? email) async {
  if (email == null || email.isEmpty) {
    return true;
  }

  try {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('usuarios')
        .select('correo_electronico')
        .eq('correo_electronico', email)
        .maybeSingle();

    return response != null;
  } catch (e) {
    print('Error verificando email: $e');
    return true;
  }
}

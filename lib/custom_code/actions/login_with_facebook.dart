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

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> loginWithFacebook() async {
  final supabase = Supabase.instance.client;

  try {
    // Para móviles, usa un deep link registrado en tu app
    // Para web, Supabase maneja automáticamente la redirección
    final redirectUrl = kIsWeb
        ? null
        : 'hulp://hulp.com'; // Cambia 'hulp' por tu esquema de app registrado

    await supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: redirectUrl,
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode
              .externalApplication, // Abre en navegador externo en móviles
    );
  } catch (e) {
    print('Error al iniciar sesión con Facebook: $e');
    rethrow;
  }
}

// // Automatic FlutterFlow imports
// import '/backend/schema/structs/index.dart';
// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/actions/index.dart'; // Imports other custom actions
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom action code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'package:flutter/foundation.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';

// Future<void> loginWithFacebook() async {
//   final supabase = Supabase.instance.client;

//   try {
//     // Para móviles, usa un deep link en lugar de la URL web
//     final redirectUrl = kIsWeb
//         ? 'https://zexegravzidwloxeimxx.supabase.co/auth/v1/callback'
//         : 'hulp://hulp.com'; // Cambia "tuapp" por tu esquema

//     await supabase.auth.signInWithOAuth(
//       OAuthProvider.facebook,
//       redirectTo: redirectUrl,
//     );
//   } catch (e) {
//     print('Error al iniciar sesión con Facebook: $e');
//     rethrow;
//   }
// }

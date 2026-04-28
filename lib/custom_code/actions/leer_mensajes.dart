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

// Recibe chat_id y remitente_id, busca en mensajes_chat los mensajes con chat_id igual al parámetro y remitente_id distinto al parámetro, cuenta los que tienen leido = false, actualiza esos a true y retorna un boolean indicando si hubo mensajes pendientes
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> leerMensajes(String chatId, String remitenteId) async {
  try {
    final supabase = Supabase.instance.client;

    // Buscar mensajes no leídos del chat que no sean del remitente
    final response = await supabase
        .from('mensajes_chat')
        .select('id')
        .eq('chat_id', chatId)
        .neq('remitente_id', remitenteId)
        .eq('leido', false);

    final mensajesNoLeidos = response as List<dynamic>;

    // Si no hay mensajes pendientes, retornar false
    if (mensajesNoLeidos.isEmpty) {
      return false;
    }

    // Actualizar los mensajes a leído = true
    await supabase
        .from('mensajes_chat')
        .update({'leido': true})
        .eq('chat_id', chatId)
        .neq('remitente_id', remitenteId)
        .eq('leido', false);

    // Retornar true indicando que había mensajes pendientes
    return true;
  } catch (e) {
    print('Error al actualizar mensajes: $e');
    return false;
  }
}

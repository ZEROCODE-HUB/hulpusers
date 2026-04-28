import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

bool verifyUrlPhoneEmail(String input) {
  final normalized = input.trim();

  // Regex para email (estricto)
  final emailRegex = RegExp(
    r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b',
  );

  // Regex para teléfono (acepta +, paréntesis, guiones, espacios)
  final phoneRegex = RegExp(
    r'(\+?\(?\d{1,4}\)?[\s\-\.]*)?(\d{2,4}[\s\-\.]*){2,4}',
  );

  // Regex para URL más precisa (debe tener al menos un punto con dominio)
  final urlRegex = RegExp(
    r'\b((https?:\/\/)?([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,})(\/[^\s]*)?\b',
  );

  // Retornar si hay coincidencia válida
  return emailRegex.hasMatch(normalized) ||
      phoneRegex.hasMatch(normalized) ||
      urlRegex.hasMatch(normalized);
}

String obtenercaracteres(
  String numeros,
  String texto,
) {
  // quiero obtener el numero de caracteres del texto del parámetro, ejemplo el parámetro "numeros" es 1,2  entonces se debe obtener el caracter 1 y 2, si es 3,4 entonces el 3 y 4
  List<String> indices = numeros.split(',');
  String resultado = '';

  for (String indice in indices) {
    int index = int.parse(indice.trim());
    if (index >= 0 && index < texto.length) {
      resultado += texto[index];
    }
  }

  return resultado;
}

int stringToIngeter(String texto) {
  // convertir texto a entero
  return int.tryParse(texto) ??
      0; // Convert text to integer, return 0 if conversion fails
}

DateTime? convertHora(DateTime? date) {
  // convertir si o si a formato js o sea con AM o PM
  if (date == null) return null;
  String formattedTime = DateFormat.jm().format(date); // Format to AM/PM
  return DateFormat('yyyy-MM-dd hh:mm a').parse(formattedTime);
}

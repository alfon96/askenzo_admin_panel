import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:flutter/material.dart';

void exceptionHandler(
    int statusCode, ScaffoldMessengerState scaffoldMessenger) {
  Map<int, String> messageMap = {
    400: 'Il titolo del contenuto è già stato usato',
    401: 'Login necessario',
    403: 'La password inserita non è corretta',
    404: 'Server non disponibile',
    422: 'Errore nella richiesta al server',
    500: 'Impossibile contattare il server',
  };

  if (messageMap.containsKey(statusCode)) {
    showCustomSnackBar(scaffoldMessenger, messageMap[statusCode]!);
  }
}

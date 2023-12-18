import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


Future<T?> handleApiErrors<T>(Future<T> Function() apiCall,
    ScaffoldMessengerState scaffoldMessenger) async {
  try {
    return await apiCall();
  } on SocketException {
    // Handle network error
    scaffoldMessenger.showSnackBar(
      const SnackBar(
          content: Text('Errore di rete. Controlla la tua connessione.')),
    );
  } on HttpException {
    // Handle server error
    scaffoldMessenger.showSnackBar(
      const SnackBar(
          content: Text('Errore del server. Per favore riprova più tardi.')),
    );
  } on http.ClientException {
    // Handle ClientException
    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('C\'è stato un errore con la richiesta')),
    );
  } catch (e) {
    // Handle any other exceptions
    scaffoldMessenger.showSnackBar(
      const SnackBar(
          content:
              Text('E\' avvenuto un errore inaspettato. Per favore riprova.')),
    );
  }
  return null;
}

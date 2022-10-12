import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static http.Client? _clientInstance;

  static http.Client get client {
    return _clientInstance ?? http.Client();
  }

  static Future<http.Client> get _instance async {
    return _clientInstance ??= await createLEClient();
  }

  static Future<void> init() async {
    _clientInstance = await _instance;
  }

  static Future<http.Client> createLEClient() async {
    final securityContext = SecurityContext();

    try {
      final sslCert = await rootBundle.load('certificates/themoviedb-org.pem');

      securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    } on TlsException catch (err) {
      log('error ${err.message}');
      rethrow;
    } catch (err) {
      log('unexpected error: $err');
      rethrow;
    }

    final client = HttpClient(context: securityContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    final ioClient = IOClient(client);
    return ioClient;
  }
}

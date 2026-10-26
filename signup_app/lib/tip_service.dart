import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupTipResult {
  final String tip;
  final bool isMock;

  const SignupTipResult({
    required this.tip,
    required this.isMock,
  });
}

class SignupTipException implements Exception {
  final String message;

  const SignupTipException(this.message);

  @override
  String toString() => message;
}

class SignupTipService {
  SignupTipService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl =
            (baseUrl ?? const String.fromEnvironment('SIGNUP_AI_PROXY_URL'))
                .trim();

  final http.Client _client;
  final String _baseUrl;

  Future<SignupTipResult> getSignupTip() async {
    if (_baseUrl.isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 350));

      return const SignupTipResult(
        tip: 'Use a unique password with at least 6 characters. A long passphrase is easier to remember and harder to guess.',
        isMock: true,
      );
    }

    late final Uri uri;

    try {
      uri = Uri.parse(_baseUrl);
    } on FormatException {
      throw const SignupTipException(
        'The signup tip service URL is invalid. Please check the configuration.',
      );
    }

    if (uri.scheme != 'https' || uri.host.isEmpty) {
      throw const SignupTipException(
        'The signup tip service must use a valid HTTPS URL.',
      );
    }

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'task': 'signup_tip',
              'topic': 'password_help',
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw const SignupTipException(
          'The signup tip service is unavailable right now. Please try again.',
        );
      }

      dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        throw const SignupTipException(
          'The signup tip service returned an unreadable response. Please try again.',
        );
      }

      if (decoded is! Map || decoded['tip'] is! String) {
        throw const SignupTipException(
          'The signup tip service returned an invalid response. Please try again.',
        );
      }

      final tip = (decoded['tip'] as String).trim();

      if (tip.isEmpty) {
        throw const SignupTipException(
          'No signup tip was returned. Please try again.',
        );
      }

      final shortenedTip =
          tip.length > 240 ? tip.substring(0, 240).trimRight() : tip;

      return SignupTipResult(
        tip: shortenedTip,
        isMock: false,
      );
    } on TimeoutException {
      throw const SignupTipException(
        'The signup tip request took too long. Please try again.',
      );
    } on http.ClientException {
      throw const SignupTipException(
        'Could not connect to the signup tip service. Please check your connection and try again.',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
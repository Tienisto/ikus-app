import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:ikus_app/constants.dart';

class Crypto {
  Crypto._();

  static String hashSHA256(String plain) {
    final bytes = utf8.encode(plain);
    final hashBytes = sha256.convert(bytes);
    return hashBytes.toString();
  }

  static String generateToken() {
    // https://github.com/jonasroussel/jsonwebtoken/issues/8
    return JWT({'dummy':'dummy'}).sign(
        SecretKey(Constants.jwt),
        algorithm: JWTAlgorithm.HS256,
        expiresIn: const Duration(minutes: 10)
    );
  }
}
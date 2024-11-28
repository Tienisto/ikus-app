import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:ikus_app/gen/env.g.dart';

class Crypto {
  Crypto._();

  static String hashSHA256(String plain) {
    final bytes = utf8.encode(plain);
    final hashBytes = sha256.convert(bytes);
    return hashBytes.toString();
  }

  static String generateToken() {
    return JWT({}).sign(
        SecretKey(Env.jwtSecret),
        algorithm: JWTAlgorithm.HS256,
        expiresIn: const Duration(minutes: 10)
    );
  }
}

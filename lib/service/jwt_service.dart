import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:ikus_app/constants.dart';

class JwtService {

  static String generateToken() {
    return JWT('').sign(
        SecretKey(Constants.jwt),
        algorithm: JWTAlgorithm.HS256,
        expiresIn: const Duration(minutes: 1)
    );
  }
}
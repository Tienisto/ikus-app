import 'package:ikus_app/constants.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtService {

  static String generateToken() {
    final claimSet = new JwtClaim(maxAge: const Duration(minutes: 1));
    return issueJwtHS256(claimSet, Constants.jwt);
  }
}
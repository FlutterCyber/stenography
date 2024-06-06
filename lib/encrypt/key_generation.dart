import 'dart:convert';
import 'package:cryptography/cryptography.dart';

Future keyGenFunc({required int keyLength, required String password}) async {
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 10000, // 20k iterations
    bits: keyLength, // 256 bits = 32 bytes output
  );

  final newSecretKey = await pbkdf2.deriveKeyFromPassword(
    password: password,
    nonce: const [1, 2, 3],
  );
  final List<int> secretKeyBytes = await newSecretKey.extractBytes();
  final base64Key = base64.encode(secretKeyBytes);
  return base64Key;
}

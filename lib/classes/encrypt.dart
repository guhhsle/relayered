import '../data.dart';
import 'package:encrypt/encrypt.dart';

class Crypt {
  static IV get iv {
    return IV.fromUtf8(pf['encryptKey']);
  }

  static Encrypter get encrypter {
    Key key = Key.fromUtf8(pf['encryptKey']);
    return Encrypter(AES(key));
  }

  static String encrypt(String raw) {
    try {
      return encrypter.encrypt(raw, iv: iv).base64;
    } catch (e) {
      return raw;
    }
  }

  static String? decrypt(String? crypt) {
    try {
      return encrypter.decrypt(
        Encrypted.fromBase64(crypt!),
        iv: iv,
      );
    } catch (e) {
      return null;
    }
  }
}

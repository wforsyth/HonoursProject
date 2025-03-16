import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static final key = encrypt.Key.fromUtf8('your32characterlongsecretkey1234');
  static final iv = encrypt.IV.fromLength(16);

  static String encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  static String decryptData(String encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return decrypted;
  }
}

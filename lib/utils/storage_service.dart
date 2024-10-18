import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storageKey = const FlutterSecureStorage();
  AndroidOptions _getAndroidOption() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  IOSOptions _getIOSOption() => const IOSOptions(
        synchronizable: true,
      );

  Future<void> writeSecureData(key, value) async {
    await _storageKey.write(
      key: key,
      value: value,
      aOptions: _getAndroidOption(),
      iOptions: _getIOSOption(),
    );
  }

  Future<String?> readSecureStorage(key) async {
    var data = await _storageKey.read(
      key: key,
      aOptions: _getAndroidOption(),
      iOptions: _getIOSOption(),
    );
    return data;
  }

  Future<void> deleteSecureStorage(key) async {
    await _storageKey.delete(
      key: key,
      aOptions: _getAndroidOption(),
      iOptions: _getIOSOption(),
    );
  }
}

StorageService storageService = StorageService();

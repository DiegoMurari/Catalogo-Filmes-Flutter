// firebase_options.dart
// Este é um template para o arquivo de opções do Firebase.
// Após rodar "flutterfire configure", esse arquivo será gerado automaticamente com os valores corretos.
// Atualize os valores abaixo conforme seu projeto Firebase.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      // Se desejar suporte para macOS ou outros, adicione os casos aqui.
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não são suportadas para essa plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    appId: '1:1234567890:web:abcdef123456',
    apiKey: 'YOUR_WEB_API_KEY',
    projectId: 'catalogo-filmes-flutter',
    messagingSenderId: '1234567890',
    authDomain: 'catalogo-filmes-flutter.firebaseapp.com',
    storageBucket: 'catalogo-filmes-flutter.appspot.com',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    appId: '1:1234567890:android:abcdef123456',
    apiKey: 'YOUR_ANDROID_API_KEY',
    projectId: 'catalogo-filmes-flutter',
    messagingSenderId: '1234567890',
    storageBucket: 'catalogo-filmes-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    appId: '1:1234567890:ios:abcdef123456',
    apiKey: 'YOUR_IOS_API_KEY',
    projectId: 'catalogo-filmes-flutter',
    messagingSenderId: '1234567890',
    storageBucket: 'catalogo-filmes-flutter.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.example.catalogoFilmes',
  );
}

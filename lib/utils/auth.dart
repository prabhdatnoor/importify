import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:importify/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../redux/redux.dart';


class PkcePair {
  final String verifier;
  final String challenge;

  PkcePair(this.verifier, this.challenge);

  static PkcePair generate({int length = 128}) {
    final random = Random.secure();

    // Generate code verifier
    final List<int> verifier = List<int>.generate(length, (_) {
      final int randomInt = random.nextInt(255);
      return randomInt;
    });

    // Generate code challenge
    final String verifierString = base64Url.encode(verifier);
    final String challenge = _sha256Hash(verifierString);

    return PkcePair(verifierString, challenge);
  }

  static PkcePair generateAndStoreInRedux({int length = 128, required UserType userType}) {
    final pkcePair = generate(length: length);

    //store in redux
    switch (userType){
      case UserType.import:
        store.dispatch(SetImportUserVerifier(pkcePair.verifier));
        break;
      case UserType.export:
        store.dispatch(SetExportUserVerifier(pkcePair.verifier));
        break;
      default:
    }
    return pkcePair;
  }

  static String _sha256Hash(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes);
  }
}
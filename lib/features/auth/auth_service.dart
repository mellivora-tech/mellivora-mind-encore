import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _providerKey = 'auth_provider';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';

  final FlutterSecureStorage _storage;
  final GoogleSignIn _googleSignIn;

  AuthService({
    FlutterSecureStorage? storage,
    GoogleSignIn? googleSignIn,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<AuthResult> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final token = credential.identityToken ?? '';
      final name = [
        credential.givenName ?? '',
        credential.familyName ?? '',
      ].where((s) => s.isNotEmpty).join(' ');
      final email = credential.email ?? '';

      await _persistAuth(
        token: token,
        provider: 'apple',
        name: name,
        email: email,
      );

      return AuthResult(success: true, userName: name, email: email);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return AuthResult(success: false, error: 'Google sign in cancelled');
      }

      final auth = await account.authentication;
      final token = auth.idToken ?? auth.accessToken ?? '';
      final name = account.displayName ?? '';
      final email = account.email;

      await _persistAuth(
        token: token,
        provider: 'google',
        name: name,
        email: email,
      );

      return AuthResult(success: true, userName: name, email: email);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<void> _persistAuth({
    required String token,
    required String provider,
    required String name,
    required String email,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _providerKey, value: provider);
    await _storage.write(key: _userNameKey, value: name);
    await _storage.write(key: _userEmailKey, value: email);
  }

  Future<String?> getUserName() async {
    return _storage.read(key: _userNameKey);
  }

  Future<String?> getUserEmail() async {
    return _storage.read(key: _userEmailKey);
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _storage.deleteAll();
  }
}

class AuthResult {
  final bool success;
  final String? userName;
  final String? email;
  final String? error;

  AuthResult({
    required this.success,
    this.userName,
    this.email,
    this.error,
  });
}

/*
 * flutter_auth_firebase_google
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'dart:async';

import 'package:flutter_auth_firebase/flutter_auth_firebase.dart';

class FirebaseGoogleProvider extends AuthProvider implements LinkableProvider {
  FirebaseGoogleProvider(
      {@required FirebaseAuthService service,
      UserAcceptanceCallback hasUserAcceptedTerms})
      : _service = service,
        _hasUserAcceptedTerms = hasUserAcceptedTerms;

  final UserAcceptanceCallback _hasUserAcceptedTerms;
  final FirebaseAuthService _service;

  GoogleSignIn _googleSignIn = new GoogleSignIn(
      // scopes: [
      //   'email',
      //   'https://www.googleapis.com/auth/contacts.readonly',
      // ],
      );

  @override
  String get providerName => 'google';

  @override
  String get providerDisplayName => "Google";

  @override
  Future<AuthUser> linkAccount(Map<String, String> args) async {
    var account = await _googleSignIn.signIn();

    if (account == null) return null;

    GoogleSignInAuthentication signInAuth = await account.authentication;

    var user = await _service.auth.linkWithGoogleCredential(
        idToken: signInAuth.idToken, accessToken: signInAuth.accessToken);
    return _service.authUserChanged.value = new FirebaseUser(user);
  }

  @override
  Future<AuthUser> signIn(Map<String, String> args,
      {termsAccepted = false}) async {
    var account = await _googleSignIn.signIn();

    if (account == null) return null;

    GoogleSignInAuthentication signInAuth = await account.authentication;

    var user = await _service.auth.signInWithGoogle(
        idToken: signInAuth.idToken, accessToken: signInAuth.accessToken);

    // In the case the the user is signin up to google, we need to check that they have or not
    // accepted terms. Since the first time signin and subsequent signin are the same,
    // we need to create the user first.
    if (!termsAccepted && _hasUserAcceptedTerms != null) {
      bool accepted = await _hasUserAcceptedTerms(user?.uid);
      if (!accepted) {
        throw new UserAcceptanceRequiredException(args);
      }
    }

    return _service.authUserChanged.value = new FirebaseUser(user);
  }

  @override
  Future<AuthUser> changePassword(Map<String, String> args) async {
    throw new UnsupportedError('Cannot change Google password ');
  }

  @override
  Future<AuthUser> changePrimaryIdentifier(Map<String, String> args) async {
    throw new UnsupportedError('Cannot change Google email ');
  }

  @override
  Future<AuthUser> create(Map<String, String> args,
      {termsAccepted = false}) async {
    throw new UnsupportedError('Cannot create Google password ');
  }

  @override
  Future<AuthUser> sendPasswordReset(Map<String, String> args) async {
    throw new UnsupportedError('Cannot reset Google password ');
  }

  @override
  Future<AuthUser> sendVerification(Map<String, String> args) async {
    throw new UnsupportedError('Cannot send Google verification email ');
  }
}

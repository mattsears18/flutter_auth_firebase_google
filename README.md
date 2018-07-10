# flutter_auth_firebase_google
An plugin for flutter_auth_firebase which uses FlutterFire and GoogleSignIn 

This package relies on the following packages:

* [google_sign_in](https://pub.dartlang.org/packages/google_sign_in) : To support signin in to google

* [flutter_auth_base](https://github.com/aqwert/flutter_auth_base) : Base package that allows the abstraction from Firebase

* [flutter_auth_firebase](https://github.com/aqwert/flutter_auth_firebase) : The implmentation of Firebase which this plugin ois used for.

```dart
AuthService createFirebaseAuthService() {
  var authService = new FirebaseAuthService();
  authService.authProviders.addAll([
    new FirebaseEmailProvider(service: authService),
    new FirebaseGoogleProvider(service: authService)
  ]);
  authService.linkProviders.addAll([
    new FirebaseEmailProvider(service: authService),
    new FirebaseGoogleProvider(service: authService)
  ]);

  return authService;
}
```
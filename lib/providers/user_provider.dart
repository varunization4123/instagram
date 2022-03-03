import 'package:flutter/cupertino.dart';
import 'package:instagram/resources/auth_methods.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get getUser => _user;
  final AuthMethods _authMethods = AuthMethods();

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserData();
    _user = user;
    notifyListeners();
  }
}

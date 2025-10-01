import 'package:flutter/widgets.dart';
import '../model/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get currentUser => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
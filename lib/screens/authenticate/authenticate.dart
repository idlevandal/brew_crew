import 'package:brew_crew_two/screens/authenticate/register.dart';
import 'package:brew_crew_two/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showSignInStateProvider = StateProvider<bool>((_) {
  return true;
});

final showSignIn = Provider<bool>((ref) {
  return ref.watch(showSignInStateProvider).state;
});

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return watch(showSignIn) ? SignIn() : Register();
      },
    );
  }
}

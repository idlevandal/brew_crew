import 'package:brew_crew_two/screens/authenticate/authenticate.dart';
import 'package:brew_crew_two/screens/home/home.dart';
import 'package:brew_crew_two/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider).data?.value;

    // return home or authenticate
    // print('🤷‍♂️$user ');
    return user == null ? Authenticate() : Home();
  }
}

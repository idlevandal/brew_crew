import 'package:brew_crew_two/screens/authenticate/authenticate.dart';
import 'package:brew_crew_two/services/auth.dart';
import 'package:brew_crew_two/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // text field state
  String email = '';
  String password = '';
  String _error = '';
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  String validateFormField(String val, String formField) {
    return val.isEmpty ? '$formField is required' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Scaffold(
          backgroundColor: Colors.brown[100],
          appBar: AppBar(
            backgroundColor: Colors.brown[400],
            elevation: 0.0,
            title: Text('Sign in to Brew Crew'),
            actions: [
              FlatButton.icon(
                  onPressed: () {
                    context.read(showSignInStateProvider).state = false;
                  },
                  icon: Icon(Icons.person),
                  label: Text('Register'))
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      initialValue: email,
                      decoration: textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (value) => validateFormField(value, 'Email'),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      initialValue: password,
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (value) => value.length < 6 ? 'Password must be at least 6 characters' : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      color: Colors.pink.shade400,
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => _isLoading = true);
                          dynamic result = await context.read(authServiceProvider).signInEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              _error = 'Could not sign in with those credentials';
                              _isLoading = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12.0,),
                    Text(_error, style: TextStyle(color: Colors.red, fontSize: 14.0),),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

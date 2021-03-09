import 'package:brew_crew_two/services/auth.dart';
import 'package:brew_crew_two/services/database.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew_two/shared/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Consumer(
        builder: (context, watch, child) {
          final userId = watch(userProvider).data.value.uid;
          final userData = watch(userDataStreamProvider(userId));

          return userData.when(
              data: (data) {

                return Column(
                  children: <Widget>[
                    Text(
                      'Update your brew settings.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: _currentName ?? data.name,
                      decoration: textInputDecoration.copyWith(hintText: 'Name'),
                      validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                      onChanged: (val) => setState(() => _currentName = val),
                    ),
                    SizedBox(height: 10.0),
                    DropdownButtonFormField(
                      value: _currentSugars ?? data.sugars,
                      decoration: textInputDecoration,
                      items: sugars.map((sugar) {
                        return DropdownMenuItem(
                          value: sugar,
                          child: Text('$sugar sugars'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _currentSugars = val ),
                    ),
                    SizedBox(height: 10.0),
                    Slider(
                      value: (_currentStrength ?? data.strength).toDouble(),
                      activeColor: Colors.brown[_currentStrength ?? data.strength],
                      inactiveColor: Colors.brown[_currentStrength ?? data.strength],
                      min: 100,
                      max: 900,
                      divisions: 8,
                      onChanged: (val) {
                        setState(() => _currentStrength = val.toInt());
                      },
                    ),
                    SizedBox(height: 10.0,),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await context.read(databaseServiceUIDProvider(userId)).updateUserData(
                                _currentSugars ?? data.sugars,
                                _currentName ?? data.name,
                                _currentStrength ?? data.strength
                            );
                            Navigator.pop(context);
                          }
                        }
                    ),
                  ],
                );
              },
              loading: () => CircularProgressIndicator(),
              error: (e, st) {
                print(e.toString());
                return Container();
              },
          );
        },
      )
    );
  }
}

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
          final user = watch(userProvider);
          final userData = watch(userDataStreamProvider(user.data.value.uid));

          return userData.when(
              data: (data) {
                // _currentName = data.name;
                // _currentSugars = data.sugars;
                // _currentStrength = data.strength;

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
                          print(_currentName);
                          print(_currentSugars);
                          print(_currentStrength);
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

          // return Column(
          //   children: <Widget>[
          //     Text(
          //       'Update your brew settings.',
          //       style: TextStyle(fontSize: 18.0),
          //     ),
          //     SizedBox(height: 20.0),
          //     TextFormField(
          //       decoration: textInputDecoration.copyWith(hintText: 'Name'),
          //       validator: (val) => val.isEmpty ? 'Please enter a name' : null,
          //       onChanged: (val) => setState(() => _currentName = val),
          //     ),
          //     SizedBox(height: 10.0),
          //     DropdownButtonFormField(
          //       value: _currentSugars ?? '0',
          //       decoration: textInputDecoration,
          //       items: sugars.map((sugar) {
          //         return DropdownMenuItem(
          //           value: sugar,
          //           child: Text('$sugar sugars'),
          //         );
          //       }).toList(),
          //       onChanged: (val) => setState(() => _currentSugars = val ),
          //     ),
          //     SizedBox(height: 10.0),
          //     Slider(
          //       value: (_currentStrength ?? 100).toDouble(),
          //       activeColor: Colors.brown[_currentStrength ?? 100],
          //       inactiveColor: Colors.brown[_currentStrength ?? 100],
          //       min: 100,
          //       max: 900,
          //       divisions: 8,
          //       onChanged: (val) {
          //         setState(() => _currentStrength = val.toInt());
          //       },
          //     ),
          //     SizedBox(height: 10.0,),
          //     RaisedButton(
          //         color: Colors.pink[400],
          //         child: Text(
          //           'Update',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //         onPressed: () async {
          //           print(_currentName);
          //           print(_currentSugars);
          //           print(_currentStrength);
          //         }
          //     ),
          //   ],
          // );
        },
      )
    );
  }
}

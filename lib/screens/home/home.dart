import 'package:brew_crew_two/screens/home/brew_list.dart';
import 'package:brew_crew_two/screens/home/settings_form.dart';
import 'package:brew_crew_two/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {

    void showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Brew Crew'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: [
          FlatButton.icon(
            onPressed: () async {
              await context.read(authServiceProvider).signOut();
            },
            icon: Icon(Icons.person),
            label: Text('logout'),
          ),
          FlatButton.icon(
            onPressed: () => showSettingsPanel(),
            icon: Icon(Icons.settings),
            label: Text('settings'),
          ),
        ],
      ),
      body: BrewList(),
    );
  }
}

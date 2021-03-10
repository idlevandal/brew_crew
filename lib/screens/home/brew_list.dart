import 'package:brew_crew_two/screens/home/brew_tile.dart';
import 'package:brew_crew_two/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrewList extends StatefulWidget {
  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {

        // final brews = watch(brewStreamProvider).data?.value;
        final brews = watch(brewStreamProvider);

        return brews.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => const Text('Oops'),
          data: (results) => ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return BrewTile(brew: results[index]);
            },
          )
        );
      },
    );
  }
}

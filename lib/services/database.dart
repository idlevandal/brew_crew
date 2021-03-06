import 'package:brew_crew_two/models/brew.dart';
import 'package:brew_crew_two/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseServiceProvider = Provider<DatabaseService>((_) {
  return DatabaseService();
});

final databaseServiceUIDProvider = Provider.family<DatabaseService, String>((ref, uid) {
  return DatabaseService(uid: uid);
});

final brewStreamProvider = StreamProvider<List<Brew>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return db.brews;
});

final userDataStreamProvider = StreamProvider.family<UserData, String>((ref, uid) {
  final db = ref.watch(databaseServiceUIDProvider(uid));
  return db.userData;
});

class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<Brew> brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc.data()['name'] ?? '',
        strength: doc.data()['strength'] ?? 0,
        sugars: doc.data()['sugars'] ?? '',
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      sugars: snapshot.data()['sugars'],
      strength: snapshot.data()['strength'],
    );
  }

  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

  // get brews table/document stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
      .map((snapshot) => brewListFromSnapshot(snapshot));
  }

}

// document() is deprecated, use doc() instead, same for setData() use set() instead.
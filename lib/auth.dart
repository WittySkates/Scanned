import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:developer';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();
  Map<String, dynamic> test;
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);
    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    updateUserData(user);

    loading.add(false);
    print("Signed in " + user.displayName);

    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  Future<String> getCurrentUID() async {
    return (await _auth.currentUser()).uid;
  }

  void signOut() {
    _auth.signOut();
  }

  Future<String> createGroup(
      String name, String country, String state, String city) async {
    final FirebaseUser currentUser = await _auth.currentUser();

    String _documentID;

    CollectionReference refUserGroupsJoined = _db
        .collection('users')
        .document(currentUser.uid)
        .collection('groupsJoined');

    CollectionReference refUserGroupsOwned = _db
        .collection('users')
        .document(currentUser.uid)
        .collection('groupsOwned');

    CollectionReference refGroups = _db.collection('groups');

    refGroups.add({
      'name': name,
      'country': country,
      'state': state,
      'city': city,
      'people': {
        'members': FieldValue.arrayUnion([currentUser.uid]),
        'owner': FieldValue.arrayUnion([currentUser.uid])
      },
    }).then((value) {
      _documentID = value.documentID;
      refGroups
          .document(_documentID)
          .setData({'gid': _documentID}, merge: true);
    }).then((value) {
      refUserGroupsJoined.document(_documentID).setData({
        'name': name,
        'country': country,
        'state': state,
        'city': city,
        'gid': _documentID,
      });
    }).then((value) {
      refUserGroupsOwned.document(_documentID).setData({
        'name': name,
        'country': country,
        'state': state,
        'city': city,
        'gid': _documentID,
      });
    });

    return _documentID;
  }

  Future<String> generateQr() async {
    final FirebaseUser currentUser = await _auth.currentUser();
  }
}

final AuthService authService = AuthService();

//Future<String> createGroup(
//    String name, String country, String state, String city) async {
//  final FirebaseUser currentUser = await _auth.currentUser();
//
//  String _documentID;
//  DocumentReference refUsers =
//  _db.collection('users').document(currentUser.uid);
//
//  CollectionReference refGroups = _db.collection('groups');
//  refGroups.add({
//    'name': name,
//    'country': country,
//    'state': state,
//    'city': city,
//    'people': {
//      'members': FieldValue.arrayUnion([currentUser.uid]),
//      'owner': FieldValue.arrayUnion([currentUser.uid])
//    },
//  }).then((value) {
//    _documentID = value.documentID;
//    refGroups
//        .document(_documentID)
//        .setData({'gid': _documentID}, merge: true);
//  }).then((value) {
//    refUsers.setData({
//      'lastSeen': DateTime.now(),
//      'groupsJoined': FieldValue.arrayUnion([_documentID]),
//      'groupsOwned': FieldValue.arrayUnion([_documentID])
//    }, merge: true);
//  });

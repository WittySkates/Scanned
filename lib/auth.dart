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
    }).then((value) {
      _documentID = value.documentID;
      refGroups
          .document(_documentID)
          .setData({'gid': _documentID}, merge: true);
    }).then((value) {
      refGroups
          .document(_documentID)
          .collection('occupants')
          .document(currentUser.uid)
          .setData({
        'name': currentUser.displayName,
        'uid': currentUser.uid,
      }, merge: true);
      refGroups
          .document(_documentID)
          .collection('owner')
          .document(currentUser.uid)
          .setData({
        'name': currentUser.displayName,
        'uid': currentUser.uid,
      }, merge: true);
    }).then((value) {
      refUserGroupsJoined.document(_documentID).setData({
        'name': name,
        'country': country,
        'state': state,
        'city': city,
        'gid': _documentID,
        'owned': true,
        'admin': false,
      }, merge: true);
    });
    return _documentID;
  }

  Future<String> generateGroupQr() async {
    final FirebaseUser currentUser = await _auth.currentUser();
  }

  Future<List<DocumentSnapshot>> getUsersGroups() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    QuerySnapshot qn = await _db
        .collection('users')
        .document(currentUser.uid)
        .collection('groupsJoined')
        .getDocuments();
    return qn.documents;
  }

  Future<List<DocumentSnapshot>> getGroupMembers(String gid) async {
    QuerySnapshot qn = await _db
        .collection('groups')
        .document(gid)
        .collection('occupants')
        .getDocuments();
    return qn.documents;
  }
}

final AuthService authService = AuthService();

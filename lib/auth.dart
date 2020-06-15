import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  String currentUserUID;
  String currentUserName;
  String currentUserEmail;
  var resultQR;

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

  Future<bool> initUserData() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    currentUserUID = currentUser.uid;
    currentUserEmail = currentUser.email;
    currentUserName = currentUser.displayName;

    if (currentUserUID != null) {
      return true;
    } else {
      return false;
    }
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

    CollectionReference refGroups = _db.collection('groups');

    refGroups.add({
      'name': name,
      'country': country,
      'state': state,
      'city': city,
      'memberCount': FieldValue.increment(1),
      'eventCount': 0,
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
        'status': 'owner',
        'email': currentUser.email,
      }, merge: true);
    }).then((value) {
      refUserGroupsJoined.document(_documentID).setData({
        'name': name,
        'country': country,
        'state': state,
        'city': city,
        'gid': _documentID,
        'status': 'owner',
      }, merge: true);
    });
    return _documentID;
  }

//  Future<bool> checkGroupExist(String gid) async {
//    bool exists = false;
//    DocumentReference ref = _db.collection('groups').document(gid);
//    await ref.get().then((snapshot) => {
//          if (snapshot.exists) {exists = true} else {exists = false}
//        });
//    return exists;
//  }

  Future<bool> scannedQR(String res) async {
    DocumentSnapshot groupData;
    String gid;
    String eid;
    log(res);
    for (int i = 0; i < res.length; i++) {
      if (res[i] == '+') {
        gid = res.substring(0, i);
        eid = res.substring(i + 1, res.length);
        break;
      } else {
        gid = res;
      }
    }

    await _db.collection('groups').document(gid).get().then((value) {
      groupData = value;
    });

    DocumentReference refGroup = _db.collection('groups').document(gid);

    DocumentReference refNewMember = _db
        .collection('groups')
        .document(gid)
        .collection('occupants')
        .document(currentUserUID);

    DocumentReference refCurrentUser = _db
        .collection('users')
        .document(currentUserUID)
        .collection('groupsJoined')
        .document(gid);

    bool exists = false;

    await refNewMember.get().then((snapshot) {
      if (!snapshot.exists) {
        refGroup.setData({
          'memberCount': FieldValue.increment(1),
        }, merge: true);
      }
    });

    await refGroup.get().then((snapshot) {
      if (snapshot.exists) {
        refNewMember.setData({
          'name': currentUserName,
          'email': currentUserEmail,
          'uid': currentUserUID,
          'status': 'member',
        }, merge: true);

        refCurrentUser.setData({
          'name': groupData.data['name'],
          'country': groupData.data['country'],
          'state': groupData.data['state'],
          'city': groupData.data['city'],
          'gid': groupData.data['gid'],
          'status': 'member',
        }, merge: true);

        exists = true;
      } else {
        exists = false;
      }
    });
    return exists;
  }

  void addEvent(String gid, String name, DateTime start, DateTime end) {
    CollectionReference ref =
        _db.collection('groups').document(gid).collection('events');
    DocumentReference refDoc = _db.collection('groups').document(gid);
    ref.add({
      'name': name,
      'start time': start,
      'end time': end,
      'gid': gid,
    }).then((value) {
      ref.document(value.documentID).setData({
        'eid': value.documentID,
      }, merge: true);
    });
    refDoc.setData({'eventCount': FieldValue.increment(1)}, merge: true);
  }

  Stream<QuerySnapshot> getUsersGroups() {
    Stream<QuerySnapshot> qn;
    qn = _db
        .collection('users')
        .document(currentUserUID)
        .collection('groupsJoined')
        .snapshots();
    return qn;
  }

  Stream<DocumentSnapshot> getGroupCounts(String gid) {
    Stream<DocumentSnapshot> qn;
    qn = _db.collection('groups').document(gid).snapshots();
    return qn;
  }

  Stream<QuerySnapshot> getGroupMembers(String gid) {
    Stream<QuerySnapshot> qn;
    qn = _db
        .collection('groups')
        .document(gid)
        .collection('occupants')
        .snapshots();
    return qn;
  }

  Stream<QuerySnapshot> getGroupEvents(String gid) {
    Stream<QuerySnapshot> qn;
    qn =
        _db.collection('groups').document(gid).collection('events').snapshots();
    return qn;
  }

  Stream<DocumentSnapshot> getGroupEventsDetails(String gid, String eid) {
    Stream<DocumentSnapshot> qn;
    qn = _db
        .collection('groups')
        .document(gid)
        .collection('events')
        .document(eid)
        .snapshots();
    return qn;
  }

  Future scanQR() async {
    try {
      var QRresult = await BarcodeScanner.scan();
      resultQR = QRresult.rawContent;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        resultQR = 'Camera Permission Denied';
      } else {
        resultQR = 'Something Went Wrong: $e';
      }
    } on FormatException catch (e) {
      resultQR = 'You pressed the back button before scanning';
    } catch (e) {
      resultQR = 'Something Went Wrong: $e';
    }
  }
}

final AuthService authService = AuthService();

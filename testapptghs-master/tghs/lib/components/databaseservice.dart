import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;

  DatabaseService({ this.uid });

  // collection reference
  // ignore: deprecated_member_use
  final CollectionReference userratings = Firestore.instance.collection(
      'ratings');

  Future<void> updateUserData(String wid,String uid,double rating) async {
    // ignore: deprecated_member_use
    return await userratings.document().setData({
      'wid':wid,
      'uid':uid,
      'userrating':rating.toInt()});
        //SetOptions(merge : true));
  }
}
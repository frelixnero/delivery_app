import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of service
  final CollectionReference orders = FirebaseFirestore.instance.collection(
    "orders",
  );

  // svae to db
  Future<void> saveOrderToDb(String receipt) async {
    await orders.add({"date": DateTime.now(), "order": receipt});
  }
}

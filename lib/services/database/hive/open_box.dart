// import 'package:hive/hive.dart';

// import 'order_summary.dart';

// class HiveService {
//   static final HiveService _instance = HiveService._internal();
//   Box<List<OrderSummary>>? _box;

//   factory HiveService() {
//     return _instance;
//   }

//   HiveService._internal();

//   Future<Box<List<OrderSummary>>> getBox() async {
//     if (_box == null || !Hive.isBoxOpen('testbox')) {
//       _box = await Hive.openBox<List<OrderSummary>>('testbox');
//     }
//     return _box!;
//   }
// }

import 'package:delivery_app/location/store%20_latlng.dart';
import 'package:delivery_app/firebase_options.dart';
import 'package:delivery_app/models/resturant.dart';
import 'package:delivery_app/services/database/hive/boxes.dart';
import 'package:delivery_app/services/database/hive/order_status_details.dart';
import 'package:delivery_app/spalsh_screen.dart';
import 'package:delivery_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode
import 'navigator_key/navigator.dart';
import 'package:app_links/app_links.dart';
import 'pages/payment_page.dart';
import 'services/auth/auth_gate.dart';
import 'services/database/hive/order_summary.dart';
import 'services/storage/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(OrderSummaryAdapter());
  Hive.registerAdapter(OrderStatusDetailsAdapter());
  await Hive.openBox('testbox');
  // await Hive.openBox<List<OrderSummary>>('userOrdersBox'); // Corrected line
  await Hive.openBox<OrderStatusDetails>('orderStatusBox');
  initAppLinks();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Resturant()),
        ChangeNotifierProvider(create: (context) => ToDoBox()),
        ChangeNotifierProvider(create: (context) => StoreLatlng()),
        ChangeNotifierProvider(create: (context) => StorageService()),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> initAppLinks() async {
  final _appLinks = AppLinks();

  final appLink = await _appLinks.getInitialLink();
  if (appLink != null) {
    handleAppLink(appLink);
  }

  _appLinks.uriLinkStream.listen((uri) {
    handleAppLink(uri);
  });
}

Future<void> saveTransactionReference(String reference) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> references = await getTransactionReferences() ?? [];
  references.add(reference);
  await prefs.setString('transactionReferences', jsonEncode(references));
}

Future<List<String>?> getTransactionReferences() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('transactionReferences');
  if (jsonString == null) return null;
  try {
    List<dynamic> decodedList = jsonDecode(jsonString);
    return decodedList.map((item) => item.toString()).toList();
  } catch (e) {
    print("Error decoding transaction references: $e");
    return null;
  }
}

void handleAppLink(Uri uri) async {
  String? reference = uri.queryParameters['reference'];
  if (reference != null) {
    print("Deep link received! Reference: $reference");

    List<String>? storedReferences = await getTransactionReferences();

    if (storedReferences == null || !storedReferences.contains(reference)) {
      NavigationService.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            print(
              "D E E P    L I N K     R E C E I V E D! Reference: $reference",
            );
            return PaymentPage(reference: reference);
          },
        ),
      );

      await saveTransactionReference(reference);
    } else {
      print("Reference already processed: $reference");
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {"/auth_gate": (context) => AuthGate()},
    );
  }
}

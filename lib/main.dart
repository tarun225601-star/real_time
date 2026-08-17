import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time/models/vendor.dart';
import 'package:real_time/services/auth_service.dart';
import 'package:real_time/services/firestore_service.dart';
import 'package:real_time/services/shared_preferences_service.dart';
import 'package:real_time/screens/home_screen.dart';
import 'package:real_time/screens/login_screen.dart';
import 'package:real_time/screens/vendor_dashboard_screen.dart';
import 'package:real_time/providers/vendor_provider.dart';
import 'package:real_time/providers/product_provider.dart';
import 'package:real_time/providers/order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Commerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return VendorDashboardScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/vendor-dashboard': (context) => VendorDashboardScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Quick Commerce'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Save Local API Keys'),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'API Key',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (text) {
                              SharedPreferencesService().saveApiKey(text);
                            },
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: HomeScreen(),
    );
  }
}
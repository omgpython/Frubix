import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frubix/firebase_options.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print("🔕 Background message: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  PrefManager manager = PrefManager();
  manager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return MaterialApp.router(
      title: width > 480 ? 'Frubix Admin' : 'Frubix',
      debugShowCheckedModeBanner: false,
      routerConfig: Routes.router,
    );
  }
}

class RedirectScreen extends StatelessWidget {
  const RedirectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (width > 480) {
        context.go(Routes.adminLoginScreen);
      } else {
        context.go(Routes.splashScreen);
      }
    });
    return Center(child: CircularProgressIndicator());
  }
}

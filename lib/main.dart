// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/Authentication/auth_gate.dart';
import 'package:tablengo/OWNER/owner_home.dart';
import 'package:tablengo/Screens/Auth_Pages/sign_in_page.dart';
import 'package:tablengo/Screens/Welcome_screen.dart';
import 'package:tablengo/Screens/splash_screen.dart';
import 'package:tablengo/Subapase/owner_supabase/owner_nptfication.dart';
import 'package:tablengo/config/supabase_config.dart';
import 'package:tablengo/utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> initNotifications() async {
  final messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(alert: true, badge: true, sound: true);

  // Get the token
  final token = await messaging.getToken();
  print('FCM Token: $token');

  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (token != null && user != null) {
    await supabase.from('user_fcm_tokens').upsert({
      'user_id': user.id,
      'fcm_token': token,
    });
  }

  // Foreground message
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('📩 Message received: ${message.notification!.title}');
    }
  });

  // When app is opened by tapping a notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('🔗 Notification clicked: ${message.notification?.title}');
  });
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  try {
    Logger.log('Initializing Supabase...', tag: 'SUPABASE');

    // Initialize Supabase with configuration
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );

    Logger.log('Supabase initialized successfully', tag: 'SUPABASE');

    // Global auth state listener with enhanced logging
    final supabase = Supabase.instance.client;
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      Logger.log(
        'Auth change: $event | Session: ${session?.user.email}',
        tag: 'AUTH',
      );
    });

    Logger.log('Auth state listener configured', tag: 'SUPABASE');
  } catch (e, stackTrace) {
    Logger.error(
      'Failed to initialize Supabase',
      tag: 'SUPABASE',
      error: e,
      stackTrace: stackTrace,
    );
    // Continue app initialization even if Supabase fails
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp();
    print('Initialized default app $app');
  }

  Future<void> _initializeNotifications() async {
    // Initialize after user logs in
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await notificationService.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TableNgo',
      home: AuthGate(),
    );
  }
}

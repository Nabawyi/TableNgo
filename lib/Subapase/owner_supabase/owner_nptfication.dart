// notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Initialize notifications
  Future<void> initialize() async {
    // Request permission (iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Get FCM token
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveFCMToken(token);
      }

      // Listen for token refresh
      _fcm.onTokenRefresh.listen(_saveFCMToken);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }
    } else {
      print('User declined or has not accepted permission');
    }
  }

  /// Save FCM token to Supabase
  Future<void> _saveFCMToken(String token, {int? restaurantId}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // For regular users
      await _supabase
          .from('user_fcm_tokens')
          .update({'fcm_token': token})
          .eq('id', userId);

      // For restaurant owners - save to restaurants table
      if (restaurantId != null) {
        await _supabase
            .from('restaurants')
            .update({'owner_fcm_token': token})
            .eq('id', restaurantId);

        print('Restaurant owner FCM Token saved: $token');
      }

      print('FCM Token saved: $token');
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  /// Initialize for restaurant owner
  Future<void> initializeForOwner(int restaurantId) async {
    await initialize();

    String? token = await _fcm.getToken();
    if (token != null) {
      await _saveFCMToken(token, restaurantId: restaurantId);
    }
  }

  /// Handle foreground messages (when app is open)
  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.messageId}');

    RemoteNotification? notification = message.notification;
    if (notification != null) {
      // Show in-app notification or dialog
      _showInAppNotification(
        title: notification.title ?? 'Notification',
        body: notification.body ?? '',
        data: message.data,
      );
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.data}');

    final data = message.data;
    if (data['type'] == 'booking_status_change') {
      final bookingId = data['bookingId'];
      final status = data['status'];

      // Navigate to booking details page
      // You can use a global navigator key or routing logic here
      print('Navigate to booking #$bookingId with status: $status');
    }
  }

  /// Show in-app notification (when app is in foreground)
  void _showInAppNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) {
    // Get current context (you'll need to pass this from your app)
    // For now, just print
    print('In-app notification: $title - $body');

    // You can show a SnackBar, Dialog, or custom notification widget
    // Example using a global key:
    // scaffoldMessengerKey.currentState?.showSnackBar(
    //   SnackBar(
    //     content: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    //         Text(body),
    //       ],
    //     ),
    //     action: SnackBarAction(
    //       label: 'View',
    //       onPressed: () {
    //         // Navigate to booking details
    //       },
    //     ),
    //   ),
    // );
  }

  /// Delete FCM token on logout
  Future<void> deleteFCMToken() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase
          .from('user_fcm_tokens')
          .update({'fcm_token': null})
          .eq('id', userId);

      await _fcm.deleteToken();
      print('FCM Token deleted');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }

  /// Subscribe to topic (optional - for broadcast notifications)
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
}

// Global instance
final notificationService = NotificationService();

// ============================================
// USAGE IN YOUR APP
// ============================================

// In your main app or login screen:
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//   }

//   Future<void> _initializeNotifications() async {
//     // Initialize after user logs in
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user != null) {
//       await notificationService.initialize();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(title: 'TableNgo', home: SearchPage(onBooking: (ResturantData , int , DateTime ) {  }, onNavigateToBooking: (ResturantData ) {  },));
//   }
// }

// On logout:
// await notificationService.deleteFCMToken();
// await Supabase.instance.client.auth.signOut();

// ============================================
// CUSTOM IN-APP NOTIFICATION WIDGET
// ============================================

class InAppNotification extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onTap;

  const InAppNotification({
    super.key,
    required this.title,
    required this.body,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

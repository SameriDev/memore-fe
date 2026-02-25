import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'notification_service.dart';

class NovuSocketService {
  static NovuSocketService? _instance;
  static NovuSocketService get instance => _instance ??= NovuSocketService._();

  NovuSocketService._();

  io.Socket? _socket;

  final _notificationController =
      StreamController<NovuNotification>.broadcast();
  final _unseenCountController = StreamController<int>.broadcast();

  Stream<NovuNotification> get onNotification =>
      _notificationController.stream;
  Stream<int> get onUnseenCountChanged => _unseenCountController.stream;

  void connect({required String subscriberId, required String apiKey}) {
    disconnect();

    _socket = io.io(
      'https://ws.novu.co',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({
            'subscriberId': subscriberId,
            'token': apiKey,
          })
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint('[NovuSocket] Connected');
    });

    _socket!.on('notification_received', (data) {
      try {
        if (data is Map<String, dynamic>) {
          final notif = NovuNotification.fromJson(data);
          _notificationController.add(notif);
        }
      } catch (e) {
        debugPrint('[NovuSocket] Parse notification error: $e');
      }
    });

    _socket!.on('unseen_count_changed', (data) {
      try {
        final count = data is Map ? (data['unseenCount'] ?? 0) as int : 0;
        _unseenCountController.add(count);
      } catch (e) {
        debugPrint('[NovuSocket] Parse unseen count error: $e');
      }
    });

    _socket!.onDisconnect((_) {
      debugPrint('[NovuSocket] Disconnected');
    });

    _socket!.onConnectError((err) {
      debugPrint('[NovuSocket] Connection error: $err');
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _notificationController.close();
    _unseenCountController.close();
  }
}

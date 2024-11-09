// wit_socket.dart
import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter/material.dart';
import 'package:witibju_1/util/wit_code_ut.dart';

class WitSocket {
  late StompClient _stompClient;

  void connectWebSocket({ required String destination, required Function onMessageReceived}) {
    _stompClient = StompClient(
      config: StompConfig(
        url: webSoketUrl, // WebSocket 서버 URL
        onConnect: (frame) {
          debugPrint('WebSocket connected');

          // 주제 구독
          _stompClient.subscribe(
            destination: destination, // 구독할 주제
            callback: (frame) {
              if (frame.body != null) {
                final messageData = jsonDecode(frame.body!);
                onMessageReceived(messageData);
                debugPrint('Received message: \$messageData');
              }
            },
          );
        },
        onWebSocketError: (dynamic error) {
          debugPrint('WebSocket error: $error');
          if (error is Exception) {
            debugPrint('WebSocket error details: ${error.toString()}');
          }
        },
      ),
    );

    _stompClient.activate();
  }

  void disconnectWebSocket() {
    _stompClient.deactivate();
  }
}

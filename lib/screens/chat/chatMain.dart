import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../util/wit_api_ut.dart';
import '../../util/wit_soket.dart';
import 'models/message_info.dart';
import 'package:witibju_1/util/wit_code_ut.dart';
import 'package:witibju_1/screens/home/wit_kakaoLogin.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  List<MessageInfo> mssageInfoList = [];

  final _user = const types.User(
    id: '72091587',
  );

  // WitSocket 인스턴스
  late WitSocket _witSocket;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _connectWebSocket(); // WebSocket 연결 초기화
  }

  // WebSocket 연결 및 구독 설정
  void _connectWebSocket() {
    _witSocket = WitSocket();
    _witSocket.connectWebSocket(
      destination: '/topic/chat/1',
      onMessageReceived: (messageData) {
        messageData = _sanitizeMessageData(messageData);

        // TextMessage 변환 시 필요한 모든 필드가 존재하는지 확인
        // 메시지에 ID가 누락된 경우, 기본 UUID 생성
        if (messageData['id'] == null) {
          messageData['id'] = '72091587';  // 고유 ID 생성
        }

        final message = types.TextMessage.fromJson(messageData);
        if (!_messages.any((m) => m.id == message.id)) {
          setState(() {
            _messages.add(message);  // 중복되지 않으면 추가
          });
          debugPrint('Received message: $message');
        }
      },
    );
  }

  // Null 값을 기본값으로 대체하는 함수
  Map<String, dynamic> _sanitizeMessageData(Map<String, dynamic> messageData) {
    return messageData.map((key, value) {
      if (value == null) {
        if (key == 'id') return MapEntry(key, Uuid().v4()); // id가 null인 경우 UUID 생성
        if (key == 'text') return MapEntry(key, ''); // text가 null인 경우 빈 문자열로 설정
        if (key == 'type') return MapEntry(key, 'text'); // type이 null인 경우 기본 텍스트 타입 설정
        if (key == 'createdAt') return MapEntry(key, DateTime.now().millisecondsSinceEpoch); // 현재 시간 기본값 설정
      }
      return MapEntry(key, value);
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      if (!_messages.contains(message)) { // 중복 메시지 방지
        _messages.add(message);  // 메시지를 리스트 끝에 추가
      }
    });

    // 메시지를 서버에 저장
    _saveMessage(message);
  }

  void _saveMessage(types.Message message) async {
    String restId = "saveChatMessage"; // 서버에 저장하는 엔드포인트 식별자
    String chatId = "1";

    final param = jsonEncode({
      "chatId": chatId,
      "author": {
        "id": message.author.id,
      },
      "createdAt": message.createdAt,
      "text": message is types.TextMessage ? message.text : null,
      "type": message.type.toString().split('.').last,
      "metadata": message.metadata ?? {}
    });

    try {
      final response = await sendPostRequest(restId, param) ?? ''; // null 처리
      print("response==================================" + response);
      if (response == 'success') {
        _loadMessages(); // <-- 서버에서 최신 메시지 목록을 다시 불러옴
      } else {
        print("Failed to save message: $response");
      }
    } catch (e) {
      print("Error saving message: $e");
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    String restId = "getChatList";
    String chatId = "1";
    final param = jsonEncode({
      "chatId": chatId,
    });

    final response = await sendPostRequest(restId, param);

    if (response is List) {
      final messages = response
          .map((e) => e is Map<String, dynamic> ? types.TextMessage.fromJson(e.map((key, value) => MapEntry(key, value ?? ''))) : null)
          .where((message) => message != null)
          .toList();

      setState(() {
        _messages = messages.cast<types.Message>();
      });
    } else {
      print("Unsupported response type: ${response.runtimeType}");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Chat(
      messages: _messages,
      onAttachmentPressed: _handleAttachmentPressed,
      onMessageTap: _handleMessageTap,
      onPreviewDataFetched: _handlePreviewDataFetched,
      onSendPressed: _handleSendPressed,
      showUserAvatars: true,
      showUserNames: true,
      user: _user,
    ),
  );
}

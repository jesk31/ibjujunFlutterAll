// ConfirmationDialog 위젯 정의
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// [유틸] 컴펌 팝업
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCencel;

  ConfirmationDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCencel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text("취소"),
          onPressed: () {
            onCencel();
            Navigator.of(context).pop(); // 대화상자 닫기
          },
        ),
        TextButton(
          child: Text("확인"),
          onPressed: () {
            onConfirm(); // 삭제 함수 호출
            Navigator.of(context).pop(); // 대화상자 닫기
          },
        ),
      ],
    );
  }
}


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../util/wit_api_ut.dart';

dynamic sllrNo;

class EstimateRequestContentPop extends StatefulWidget {
  final dynamic sllrNo;
  const EstimateRequestContentPop({Key? key, required this.sllrNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EstimateRequestContentPopState();
  }
}

class EstimateRequestContentPopState extends State<EstimateRequestContentPop> {
  TextEditingController descriptionController = TextEditingController(); // TextController 추가

  @override
  Widget build(BuildContext context) {
    return Dialog( // AlertDialog 대신 Dialog 사용
      insetPadding: EdgeInsets.all(16.0), // 다이얼로그 여백 설정
      child: Container(
        padding: EdgeInsets.all(16.0), // 내용 여백 추가
        child: Column(
          mainAxisSize: MainAxisSize.min, // 최소 크기로 설정
          children: [
            Text('견적 설명 입력', style: TextStyle(fontSize: 20)), // 제목
            SizedBox(height: 16), // 제목 아래 여백
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: "견적 설명을 입력하세요"),
              maxLines: 5,
            ),
            SizedBox(height: 16), // 텍스트 필드 아래 여백
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    // 입력된 내용을 부모 위젯으로 반환
                    Navigator.of(context).pop(descriptionController.text); // 입력된 내용 반환
                  },
                  child: Text('수정'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

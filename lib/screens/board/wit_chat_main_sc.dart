import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  List<Widget> chatWidgets = []; // 채팅 위젯 리스트
  ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러

  int? selectedOption; // 선택된 옵션
  double progress = 0.0; // 초기 진척률

  List<dynamic> data1 = [
    {"cdCls": "CH01", "cd": "CH101", "cdName": "테스트 선택1", "uppCdCls": "", "seq": "0"},
    {"cdCls": "CH01", "cd": "CH102", "cdName": "테스트 선택2", "uppCdCls": "", "seq": "1"},
  ];

  List<dynamic> data2_1 = [
    {"cdCls": "CH02", "cd": "CH201", "cdName": "테스트 후선택1_1", "uppCdCls": "CH01", "uppCd": "CH101", "seq": "0"},
    {"cdCls": "CH02", "cd": "CH202", "cdName": "테스트 후선택1_2", "uppCdCls": "CH01", "uppCd": "CH101", "seq": "1"},
  ];

  List<dynamic> data2_2 = [
    {"cdCls": "CH03", "cd": "CH301", "cdName": "테스트 후선택2_1", "uppCdCls": "CH01", "uppCd": "CH102", "seq": "0"},
    {"cdCls": "CH03", "cd": "CH302", "cdName": "테스트 후선택2_2", "uppCdCls": "CH01", "uppCd": "CH102", "seq": "1"},
  ];

  @override
  void initState() {
    super.initState();
    selectedOption = null;
    chatWidgets.add(_leftMessage(data1));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 초기 데이터 설정
    chatWidgets.add(_leftMessage(data1));
    // UI 업데이트
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 스크롤 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.lightBlue[200],
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.lightBlue[200],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController, // 스크롤 컨트롤러 연결
                children: chatWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leftMessage(List<dynamic> data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedOption == null ? "어떤 플랫폼을 원하시나요?" : "후 선택을 해주세요:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              children: data.map<Widget>((item) {
                return _MessageRadio(item);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _MessageRadio(dynamic data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Radio<int>(
            value: int.parse(data['seq']),
            groupValue: selectedOption,
            onChanged: (int? newValue) {
              setState(() {
                selectedOption = newValue;
                progress = 0.5; // 진척도 업데이트 (50%)

                // 선택 후 추가 데이터 로드
                chatWidgets.add(_rightMessage('${data['cdName']}을 선택했습니다.'));
                _scrollToBottom(); // 스크롤을 가장 아래로 내리기
                chatWidgets.add(_leftMessage(_getFurtherData())); // 추가 선택지 표시

              });
              _scrollToBottom(); // 스크롤을 가장 아래로 내리기
            },
          ),
          Text(data['cdName']),
        ],
      ),
    );
  }

  Widget _rightMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<dynamic> _getFurtherData() {
    switch (selectedOption) {
      case 0:
        return data2_1;
      case 1:
        return data2_2;
      default:
        return [];
    }
  }

  void _scrollToBottom() {
    // 마지막 위젯으로 스크롤 이동
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }
}

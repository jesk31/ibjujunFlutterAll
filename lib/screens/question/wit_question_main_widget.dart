import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// [위젯] 좌측 라디오박스 리스트 메세지
class RadioOptionColumn extends StatefulWidget {
  final dynamic data;
  final List<Map<String, String>> options;
  final int? groupValue;
  final ValueChanged<dynamic>? onChanged;
  final List<bool>? isEnabled;
  final VoidCallback? onComplete;

  RadioOptionColumn({
    required this.data,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.isEnabled,
    this.onComplete,
  });

  @override
  _RadioOptionColumnState createState() => _RadioOptionColumnState();
}

class _RadioOptionColumnState extends State<RadioOptionColumn> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // 애니메이션을 시작합니다.
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0; // 위젯을 완전히 보이게 설정
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 500), // 애니메이션 지속 시간
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
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
            if (widget.data['qustTitle'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  widget.data['qustTitle']!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            if (widget.data['qustSubTitle'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  widget.data['qustSubTitle']!,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
            ...List.generate(widget.options.length, (optionIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 3.0),
                padding: const EdgeInsets.fromLTRB(0.0, 3.0, 3.0, 3.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: widget.groupValue == optionIndex + 1 ? Colors.blue : Colors.white,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<int?>(
                      value: optionIndex + 1,
                      groupValue: widget.groupValue,
                      onChanged: widget.onChanged,
                      activeColor: Colors.blue,
                    ),
                    Expanded(
                      child: Text(
                        widget.options[optionIndex]['opTitle']!,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (widget.isEnabled?.every((enabled) => enabled) ?? false) ? widget.onComplete : null,
                child: Text('선택 완료', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// [위젯] 좌측 체크박스 리스트 메세지
class CheckOptionColumn extends StatefulWidget {
  final dynamic data;
  final List<Map<String, String>> options; // 옵션 리스트
  final List<String> selectedValues; // 선택된 값의 리스트
  final ValueChanged<List<dynamic>>? onChanged; // 선택된 값을 업데이트하는 콜백
  final List<bool>? isEnabled; // 체크박스 활성화 상태 리스트
  final VoidCallback? onComplete; // 선택 완료 버튼 클릭 시 호출되는 콜백

  CheckOptionColumn({
    required this.data,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.isEnabled, // 활성화 상태는 선택적
    this.onComplete, // 선택 완료 콜백
  });

  @override
  _CheckOptionColumnState createState() => _CheckOptionColumnState();
}

class _CheckOptionColumnState extends State<CheckOptionColumn> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // 애니메이션을 시작합니다.
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0; // 위젯을 완전히 보이게 설정
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 500), // 애니메이션 지속 시간
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7, // 화면의 70% 너비
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0), // 바깥쪽 여백
        decoration: BoxDecoration(
          color: Colors.grey[300], // 바깥 박스 배경색
          borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // 그림자 색상
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // 그림자의 위치
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            if (widget.data['qustTitle'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0), // 제목과 옵션 간격
                child: Text(
                  widget.data['qustTitle']!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // 제목 스타일
                ),
              ),
            if (widget.data['qustSubTitle'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0), // 제목과 옵션 간격
                child: Text(
                  widget.data['qustSubTitle']!,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal), // 제목 스타일
                ),
              ),
            ...List.generate(widget.options.length, (optionIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 3.0), // 위아래 여백
                padding: const EdgeInsets.fromLTRB(0.0, 3.0, 3.0, 3.0), // 내부 여백
                decoration: BoxDecoration(
                  color: Colors.white, // 배경색
                  borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: widget.selectedValues.contains(widget.options[optionIndex]['opSeq']), // 체크박스 상태
                      onChanged: (isChecked) {
                        if (widget.isEnabled?[optionIndex] ?? true) { // 활성화 상태 확인
                          if (isChecked != null) {
                            if (isChecked) {
                              widget.selectedValues.add(widget.options[optionIndex]['opSeq']!); // 체크된 경우 추가
                            } else {
                              widget.selectedValues.remove(widget.options[optionIndex]['opSeq']); // 체크 해제된 경우 제거
                            }
                            widget.onChanged!(widget.selectedValues); // 업데이트된 선택값을 부모에 전달
                          }
                        }
                      },
                      activeColor: Colors.blue, // 체크박스 선택 시 색상
                    ),
                    Expanded(
                      child: Text(
                        widget.options[optionIndex]['opTitle']!, // 옵션 이름 표시
                        style: TextStyle(fontSize: 14, color: Colors.black), // 텍스트 스타일
                      ),
                    ),
                  ],
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight, // 오른쪽 정렬
              child: TextButton(
                onPressed: (widget.isEnabled?.every((enabled) => enabled) ?? false) ? widget.onComplete : null, // 체크박스가 모두 비활성화일 때 버튼 비활성화
                child: Text('선택 완료', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// [위젯] 기타 메세지
class EtcOptionColumn extends StatefulWidget {
  final dynamic data;

  EtcOptionColumn({
    required this.data,
  });

  @override
  _EtcOptionColumnState createState() => _EtcOptionColumnState();
}

class _EtcOptionColumnState extends State<EtcOptionColumn> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // 애니메이션을 시작합니다.
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0; // 위젯을 완전히 보이게 설정
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 500), // 애니메이션 지속 시간
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7, // 화면의 70% 너비
        padding: const EdgeInsets.all(10.0), // 바깥쪽 여백
        decoration: BoxDecoration(
          color: Colors.grey[300], // 바깥 박스 배경색
          borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // 그림자 색상
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // 그림자의 위치
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            if (widget.data['qustTitle'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0), // 제목과 옵션 간격
                child: Text(
                  widget.data['qustTitle']!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // 제목 스타일
                ),
              ),
            if (widget.data['qustSubTitle'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0), // 제목과 옵션 간격
                child: Text(
                  widget.data['qustSubTitle']!,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal), // 제목 스타일
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// [위젯] 우측 선택값 출력 메세지
class SelectedOptionsRow extends StatefulWidget {
  final String selectedOptionsText;
  final VoidCallback onReselect;

  const SelectedOptionsRow({
    Key? key,
    required this.selectedOptionsText,
    required this.onReselect,
  }) : super(key: key);

  @override
  _SelectedOptionsRowState createState() => _SelectedOptionsRowState();
}

class _SelectedOptionsRowState extends State<SelectedOptionsRow> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // 애니메이션을 시작합니다.
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0; // 위젯을 완전히 보이게 설정
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 500), // 애니메이션 지속 시간
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7, // 최대 너비 70%
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white, // 바깥 박스 배경색
              borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // 그림자 색상
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // 그림자의 위치
                ),
              ],
            ),
            child: Column( // Column으로 변경하여 수직 배치
              mainAxisSize: MainAxisSize.min, // 자식 위젯의 최소 크기에 맞추기
              crossAxisAlignment: CrossAxisAlignment.end, // 오른쪽 정렬
              children: [
                Text(
                  "[ " + widget.selectedOptionsText + " ]을 선택하셨습니다.",
                  style: TextStyle(fontSize: 16, color: Colors.black), // 글자 색을 검정색으로 설정
                  textAlign: TextAlign.left, // 텍스트를 왼쪽 정렬
                  softWrap: true, // 줄바꿈 가능
                ),
                SizedBox(height: 4), // 텍스트와 아이콘 사이의 간격 추가
                GestureDetector(
                  onTap: widget.onReselect, // 아이콘 클릭 시 호출
                  child: Icon(
                    Icons.replay,
                    color: Colors.red,
                    size: 16, // 아이콘 크기 조정
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// [위젯] 프로그래스바
class ProgressBar extends StatelessWidget {
  final double progress; // 진행률 변수를 추가

  ProgressBar({required this.progress}); // 생성자에서 진행률을 받음

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16), // 좌우 여백
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // 모서리 둥글게 처리
                  child: LinearProgressIndicator(
                    value: progress, // 진행률
                    minHeight: 8, // 프로그래스 바 최소 높이
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // 색상 설정
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20), // 텍스트 오른쪽 여백
              child: Text(
                "${(progress * 100).toStringAsFixed(0)}%", // 진행률 텍스트
                style: TextStyle(fontSize: 16), // 텍스트 크기
              ),
            ),
          ],
        ),
        SizedBox(height: 16), // 프로그래스 바 하단 여백 추가
      ],
    );
  }
}
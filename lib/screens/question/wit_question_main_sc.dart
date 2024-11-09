import 'dart:convert';

import 'package:witibju_1/screens/question/wit_question_main_widget.dart';
import 'package:flutter/material.dart';
import 'package:witibju_1/util/wit_api_ut.dart';
import 'package:witibju_1/screens/common/wit_common_widget.dart';

class Question extends StatelessWidget {
  final String qustCd; // 최초 질문 코드

  Question({required this.qustCd});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
            child: QuestionList(qustCd: qustCd),
        ),
      ),
    );
  }
}

/**
 * 질문 리스트
 */
class QuestionList extends StatefulWidget {

  final String qustCd;  // 최초 질문 코드

  QuestionList({required this.qustCd});

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<QuestionList> {

  // 사용자 코드 (세션코드로 변경 필요)
  String userId = "72091588";

  List<Map<String, String>> qustList = [];             // 질문 리스트
  List<List<Map<String, String>>> qustOptionList = []; // 질문 옵션 리스트

  Map<int, dynamic> selectedValues = {};    // 항목 선택 저장 변수
  Map<int, bool> isBoxEnabled = {};         // 박스 활성화 상태

  int currentIndex = 0;                     // 현재 선택된 항목 인덱스
  double currentProgress = 0.0;             // 진행률

  // 스크롤 컨트롤러
  ScrollController _scrollController = ScrollController();


  /*****************************************************************************************
   * 초기화
   *****************************************************************************************/
  @override
  void initState() {
    super.initState();

    // 최초 질문 조회
    getFirstQuestionInfo();
  }

  /*****************************************************************************************
   * UI 영역
   *****************************************************************************************/
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //ProgressBar(progress: currentProgress),
        Expanded(
          // 메인 LIST
          child: ListView.builder(
            controller: _scrollController,
            itemCount: currentIndex + 1,
            itemBuilder: (context, index) {
              
              // 질문 LIST 없으면 return 진행
              if (qustList.length <= 0) {
                return null;
              }
              
              // 질문 메인 BOX 영역
              return Container(
                padding: const EdgeInsets.all(16.0),    // 엣지 둥글게
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),

                // 질문 옵션 영역
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 타입이 라디오 박스 (qustType "R")
                    if (qustList[index]['qustType'] == "R")

                      // 라디오박스 컬럼 호출
                      // 호출 파라미터 : data, options, groupValue, onChanged
                      RadioOptionColumn(
                        data: qustList[index],          // 질문 LIST
                        options: qustOptionList[index], // 질문 옵션 LIST
                        groupValue: selectedValues[index],  // 그룹 번호
                        // 라디오 박스 비활성화 조건 (선택된 경우 onChanged를 null로 설정하여 비활성화)
                        onChanged: isBoxEnabled[index] == null || isBoxEnabled[index] == true ? (value) {
                          setState(() {
                            // 선택한 옵션 번호 저장
                            selectedValues[index] = value;
                          });
                        } : null,
                        // 선택 완료 버튼 이벤트
                        isEnabled: List.generate(qustOptionList[index].length, (i) => isBoxEnabled[index] ?? true),
                        onComplete: () {
                          setState(() {
                            // 체크박스 미선택 체크
                            if (selectedValues[index] == null) {
                              // 알림창 띄움
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('알림'),
                                      content: Text('선택한 값이 없습니다.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 다이얼로그 닫기
                                          },
                                          child: Text('확인'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                              return;
                            }
                            // 박스 비활성화
                            isBoxEnabled[index] = false;
                            // 하위 질문 코드
                            String lowQustCd = qustOptionList[index][selectedValues[index]-1]["lowQustCd"] ?? "";
                            // 질문 저장 및 다음질문 조회
                            saveQuestionInfo(qustList[index]['qustType']!, lowQustCd, index);
                          });
                        },
                      )

                    // 타입이 체크 박스 (qustType "C")
                    else if (qustList[index]['qustType'] == "C")

                      // 체크 박스 컬럼 호출
                      // 호출 파라미터 : data, options, selectedValues, onChanged, isEnabled, onComplete
                      CheckOptionColumn(
                        data: qustList[index],            // 질문 LIST
                        options: qustOptionList[index],   // 질문 옵션 LIST
                        selectedValues: selectedValues[index] ?? [],  // 선택한 값(여러건)
                        // 항목 체크 박스 이벤트
                        onChanged: (selected) {
                          setState(() {
                            selectedValues[index] = selected;
                          });
                        },
                        // 박스 활성화 여부
                        isEnabled: List.generate(qustOptionList[index].length, (i) => isBoxEnabled[index] ?? true),
                        // 선택 완료 버튼 이벤트
                        onComplete: () {
                          setState(() {
                            // 체크박스 미선택 체크
                            if (selectedValues[index] == null) {
                              // 알림창 띄움
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('알림'),
                                      content: Text('선택한 값이 없습니다.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 다이얼로그 닫기
                                          },
                                          child: Text('확인'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                              return;
                            }
                            // 체크박스 비활성화
                            isBoxEnabled[index] = false;
                            // 하위 질문 코드
                            String lowQustCd = qustOptionList[index][0]["lowQustCd"] ?? "";
                            // 질문 저장 및 다음질문 조회
                            saveQuestionInfo(qustList[index]['qustType']!, lowQustCd, index);

                          });
                        },
                      )

                    // 타입이 기타 (qustType "E")
                    else if (qustList[index]['qustType'] == "E")
                      EtcOptionColumn(
                        data: qustList[index],
                      ),
                    
                    // 선택된 옵션 우측 버블 보여주기
                    if (selectedValues[index] != null && isBoxEnabled[index] == false)
                      Column(
                        children: [
                          SizedBox(height: 16), // SelectedOptionsRow 위에 공간 추가
                          SelectedOptionsRow(
                            selectedOptionsText: getSelectedOptionsText(index), // 선택된 옵션 텍스트
                            onReselect: () {
                              // 삭제 확인 대화상자 표시
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // 컨펌 팝업 확인
                                  return ConfirmationDialog(
                                    title: "초기화",
                                    content: "선택하신 항목 이후값이 초기화됩니다.\n초기화 하시겠습니까?",
                                    onConfirm: () {
                                      setState(() {
                                        // 현재 인덱스 이후 데이터 삭제
                                        for (int delIdx in selectedValues.keys) {
                                          if (delIdx >= index) {
                                            deleteQuestionInfo(qustList[delIdx]['qustType']!, delIdx);
                                          }
                                        }

                                        // 재선택 버튼 클릭 시 해당 항목 이후의 리스트를 숨김
                                        currentIndex = index; // 현재 인덱스 이후로 표시하지 않도록 설정
                                        selectedValues.removeWhere((key, value) => key >= index); // 선택한 데이터 초기화
                                        isBoxEnabled.removeWhere((key, value) => key >= index);
                                        isBoxEnabled[index] = true; // 체크박스 활성화
                                      });

                                      // 스크롤 하단 이동
                                      _scrollToBottom();
                                    },
                                    onCencel: () {
                                      setState(() {

                                      });
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /*****************************************************************************************
   * 유틸, 이벤트 영역
   *****************************************************************************************/

  // [유틸] 라디오박스, 체크박스 선택시 결과값 출력용
  String getSelectedOptionsText(int index) {

    // 라디오 박스 (qustType = R)
    if (qustList[index]['qustType'] == "R") {
      // 선택한 옵션
      final selectedOption = selectedValues[index];

      if (selectedOption != null) {
        return qustOptionList[index].firstWhere(
              (opt) => int.parse(opt['opSeq']!) == selectedOption,
          orElse: () => {'opTitle': '선택 없음'}, // 기본값 설정
        )['opTitle']!;
      }

    // 체크박스 (qustType = C)
    } else if (qustList[index]['qustType'] == "C") {
      return (selectedValues[index] as List<String>)
          .map((cd) {
        return qustOptionList[index].firstWhere(
              (opt) => opt['opSeq'] == cd,
          orElse: () => {'opTitle': '선택 없음'}, // 기본값 설정
        )['opTitle']!;
      }).join(', ');
    }

    // 그외
    return '선택 없음'; // 기본값 설정
  }

// [이벤트] 스크롤바 하단으로 이동
  void _scrollToBottom() {
    // 마지막 위젯으로 스크롤 이동
    Future.delayed(Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1000), // 이동 시간
          curve: Curves.easeInOut, // 애니메이션 곡선
        );
      }
    });
  }

  // [이벤트] 컨트롤러 해제
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /*****************************************************************************************
   * 서비스 영역
   *****************************************************************************************/

  // [서비스] 최초 질문 조회
  Future<void> getFirstQuestionInfo() async {
    // REST ID
    String restId = "getFirstQuestionInfo";

    // PARAM
    final param = jsonEncode({
      "userId": userId,
    });

    // API 호출 (질문 조회)
    final questionList = await sendPostRequest(restId, param);

    // 진행 여부 확인
    if (questionList["questionList"] != null && questionList["questionList"].isNotEmpty) {

      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("확인"),
            content: Text("진행하신 데이터가 있습니다.\n이어서 진행 하시겠습니까?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // 취소
                },
                child: Text("처음부터"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // 확인
                },
                child: Text("이어서"),
              ),
            ],
          );
        },
      );

      // "이어서" 선택시
      if (confirm == true) {

        setState(() {
          int saveIdx = 0;
          String lastQustCd = "";
          currentIndex = -1;

          // 저장 질문 리스트
          for (var questionInfo in questionList["questionList"]) {
            qustList.add({
              'qustCd': questionInfo["qustCd"],
              'qustTitle': questionInfo["qustTitle"],
              'qustSubTitle': questionInfo["qustSubTitle"],
              'qustType': questionInfo["qustType"],
              'qustOpCd': questionInfo["qustOpCd"],
            });

            if (questionInfo["qustType"] == "C") {
              selectedValues[saveIdx] = questionList["saveData"][saveIdx]["opSeq"].split(",");
            } else {
              selectedValues[saveIdx] = int.parse(questionList["saveData"][saveIdx]["opSeq"]);
            }

            isBoxEnabled[saveIdx] = false;
            currentIndex++;
            saveIdx++;
          }

          // 저장 옵션 리스트
          for (var optionInfo in questionList["optionList"]) {
            List<Map<String, String>> optionList = [];
            for (var option in optionInfo) {
              optionList.add({
                'opCd': option["opCd"],
                'opSeq': option["opSeq"].toString(),
                'opTitle': option["opTitle"],
                'opSubTitle': option["opSubTitle"] ?? '',
                'opContents': option["opContents"] ?? '',
                'lowQustCd': option["lowQustCd"],
              });
              lastQustCd = option["lowQustCd"];
            }
            qustOptionList.add(optionList);
          }

          print(lastQustCd);

          // 다음 질문 진행
          getNextQuestionInfo(lastQustCd, (saveIdx-1));
        });
      
      // "처음부터" 선택시
      } else {
        // 사용자가 취소를 선택한 경우
        setState(() {
          // 질문 전체 삭제
          deleteQuestionInfoByAll();
        });
      }
    
    // 처음 들어온 경우
    } else {
      // 질문 조회
      getNextQuestionInfo(widget.qustCd, 0);
    }
  }

  // [서비스] 다음 질문 조회
  Future<void> getNextQuestionInfo(String qustCd, int index) async {
    // REST ID
    String restId = "getNextQuestionInfo";

    // PARAM
    final param = jsonEncode({
      "qustCd": qustCd,
      "qustIdx": index
    });

    // API 호출 (질문 조회)
    final questionInfo = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      // 질문이 없으면 return
      if (questionInfo["questionInfo"] == null) {
        return;
      }

      // items에 질문 정보 추가
      qustList.add({
        'qustCd': questionInfo["questionInfo"]["qustCd"],       // 질문코드
        'qustTitle': questionInfo["questionInfo"]["qustTitle"], // 질문 타이틀
        'qustSubTitle': questionInfo["questionInfo"]["qustSubTitle"], // 질문 서브 타이틀
        'qustType': questionInfo["questionInfo"]["qustType"],   // 질문 타입
        'qustOpCd': questionInfo["questionInfo"]["qustOpCd"],   // 질문 옵션 코드
      });

      List<Map<String, String>> optionList = [];
      for (var option in questionInfo["optionList"]) {
        optionList.add({
          'opCd': option["opCd"],               // 옵션 코드
          'opSeq': option["opSeq"].toString(),  // 옵션 순서
          'opTitle': option["opTitle"],         // 옵션 타이틀
          'opSubTitle': option["opSubTitle"] ?? '', // 옵션 서브 타이틀
          'opContents': option["opContents"] ?? '', // 옵션 설명
          'lowQustCd': option["lowQustCd"],     // 옵션 하위 질문

        });
      }
      qustOptionList.add(optionList); // 옵션 리스트를 options에 추가

      // 다음 항목으로 이동
      if (index < qustList.length - 1) {
        currentIndex++;
      }
    });

    // 스크롤 하단 이동
    _scrollToBottom();
  }

  // [서비스] 질문 저장
  Future<void> saveQuestionInfo(String gustType, String lowQustCd, int index) async {

    final selectedOption = selectedValues[index];

    // REST ID
    String restId = "saveQuestionInfo";

    // PARAM
    var param = null;

    if (gustType == "R") {
      // 파라미터
      param = jsonEncode({
        "qustCd" : qustList[index]["qustCd"],
        "opCd" : qustOptionList[index].firstWhere((opt) => int.parse(opt['opSeq']!) == selectedOption)["opCd"],
        "opSeq" : qustOptionList[index].firstWhere((opt) => int.parse(opt['opSeq']!) == selectedOption)["opSeq"],
        "userId" : userId,
      });

    } else if (gustType == "C") {
      // 파라미터
      param = jsonEncode({
        "qustCd" : qustList[index]["qustCd"],
        "opCd" : (selectedValues[index] as List<String>).map((cd) {return qustOptionList[index].firstWhere((opt) => opt['opSeq'] == cd)['opCd']!;}).join(','),
        "opSeq" : (selectedValues[index] as List<String>).map((cd) {return qustOptionList[index].firstWhere((opt) => opt['opSeq'] == cd)['opSeq']!;}).join(','),
        "userId" : userId,
      });

    }

    // API 호출 (질문 조회)
    final savaResult = await sendPostRequest(restId, param);

    // 저장 결과 확인
    if (savaResult["saveResult"] == "OK") {
      // 다음 질문 조회
      getNextQuestionInfo(lowQustCd, index);

      setState(() {
        currentProgress = currentProgress + 0.33;
        if (currentProgress >= 0.9) {
          currentProgress = 1.0;
        }
      });

    } else {
      print("저장중에 오류가 발생 되었습니다.");
    }

  }

  // [서비스] 질문 삭제
  Future<void> deleteQuestionInfo(String gustType, int index) async {

    final selectedOption = selectedValues[index];

    // REST ID
    String restId = "deleteQuestionInfo";

    // PARAM
    var param = null;

    if (gustType == "R") {
      // 파라미터
      param = jsonEncode({
        "qustCd" : qustList[index]["qustCd"],
        "opCd" : qustOptionList[index].firstWhere((opt) => int.parse(opt['opSeq']!) == selectedOption)["opCd"],
        "userId" : userId,
      });

    } else if (gustType == "C") {
      // 파라미터
      param = jsonEncode({
        "qustCd" : qustList[index]["qustCd"],
        "opCd" : (selectedValues[index] as List<String>).map((cd) {return qustOptionList[index].firstWhere((opt) => opt['opSeq'] == cd)['opCd']!;}).join(','),
        "userId" : userId,
      });

    }

    // API 호출 (질문 조회)
    final delResult = await sendPostRequest(restId, param);

    // 저장 결과 확인
    if (delResult["delResult"] == "OK") {

      // 진행률 수정
      setState(() {
        currentProgress = currentProgress - 0.33;
        if (currentProgress <= 0.1) {
          currentProgress = 0.0;
        }
      });
    } else {
      print("삭제 오류");
    }
  }

  // [서비스] 질문 전체 삭제
  Future<void> deleteQuestionInfoByAll() async {

    // REST ID
    String restId = "deleteQuestionInfoByAll";

    // PARAM
    var param = jsonEncode({
      "userId" : userId,      // 사용자 ID
    });

    // API 호출 (질문 조회)
    final delResult = await sendPostRequest(restId, param);

    // 전체 삭제 결과 확인
    if (delResult["delResult"] == "OK") {
      // 첫 질문 진행
      getNextQuestionInfo(widget.qustCd, 0);
    } else {
      print("전체 삭제 오류");
    }
  }

}
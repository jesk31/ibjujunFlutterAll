import 'package:witibju_1/screens/board/wit_board_main_sc.dart';
import 'package:witibju_1/screens/board/wit_board_write_sc.dart';
import 'package:witibju_1/util/wit_code_ut.dart';
import 'package:witibju_1/util/wit_api_ut.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


import '../common/wit_ImageViewer_sc.dart';

dynamic boardDetailInfo = {};

List<dynamic> boardDetailImageList = [];

List<dynamic> commentList = [];

class BoardDetail extends StatefulWidget {

  const BoardDetail({Key? key, required this.param}) : super(key: key);

  final dynamic param;

  @override
  State<StatefulWidget> createState() {
    boardDetailInfo = this.param;
    return BoardDetailState();
  }
}

class BoardDetailState extends State<BoardDetail> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 게시판 조회수 증가
    boardRdCntUp();

    // 게시판 상세 조회
    getBoardDetailList();

    // 게시판 상세 이미지 조회
    getBoardDetailImageList();

    // 댓글 리스트 조회
    getCommentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "자유게시판",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24, // 글자 크기 증가
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue, // 앱바 배경색
        elevation: 10, // 그림자 효과
        shadowColor: Colors.black54,
        centerTitle: false,
      ),
      body: SafeArea( // SafeArea 추가
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 제목과 아이콘을 양쪽 끝으로 정렬
                        children: [
                          Expanded( // 공간을 차지하도록 설정
                            child: Text(
                              boardDetailInfo["bordTitle"] ?? "",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 2, // 최대 줄 수 설정
                              overflow: TextOverflow.ellipsis, // 넘치는 텍스트는 생략 부호(...)로 표시
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert, color: Colors.black), // 점 3개 아이콘
                            color: Colors.white,
                            onSelected: (value) {
                              if (value == 'edit') {
                                // 수정하기 선택 시 화면 이동
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => BoardWrite(boardInfo: boardDetailInfo, imageList: boardDetailImageList),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              } else if (value == 'delete') {
                                // 삭제하기 선택 시 확인 대화상자
                                _showConfirmDialog(context, '삭제하시겠습니까?');
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Text('수정하기'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('삭제하기'),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20, // 동그란 이미지의 반지름
                            //backgroundImage: NetworkImage(boardDetailInfo["userImageUrl"] ?? ""), // 이미지 URL
                            //backgroundImage: NetworkImage(""), // 이미지 URL
                            // 배경색 대신 기본 아이콘 사용
                          ),
                          SizedBox(width: 15), // 이미지와 텍스트 사이의 간격
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${boardDetailInfo["creUser"] ?? "익명"}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${boardDetailInfo["creDateTxt"] ?? ""}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 8), // 날짜와 조회수 사이의 간격
                                  Text(
                                    '조회 ${boardDetailInfo["bordRdCnt"] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(),
                      SizedBox(height: 16),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: 300, // 최소 높이 300
                        ),
                        child: Text(
                          boardDetailInfo["bordContent"] ?? "",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 16),

                      // 가로 스크롤 구현 부분
                      Container(
                        height: 120, // 높이 설정
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: boardDetailImageList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // 클릭 시 ImageViewer로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageViewer(
                                      imageUrls: boardDetailImageList.map((item) => apiUrl + item["imagePath"]).toList(),
                                      initialIndex: index, // 클릭한 이미지 인덱스 전달
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 120,
                                height: 120,
                                margin: EdgeInsets.only(right: 8), // 이미지 간격
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12), // 둥글게 처리
                                  image: DecorationImage(
                                    image: NetworkImage(apiUrl + boardDetailImageList[index]["imagePath"]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),


                      SizedBox(height: 4),
                      Divider(),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "댓글 ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${boardDetailInfo["commentCnt"] ?? 0} >",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: commentList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.all(0), // 패딩 없애기
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                              children: [
                                CircleAvatar(
                                  radius: 20, // 동그란 이미지의 반지름
                                  //backgroundImage: NetworkImage(""), // 이미지 URL
                                ),
                                SizedBox(width: 15), // 이미지와 텍스트 사이의 간격
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (commentList[index]["creUser"] ?? "익명"),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      commentList[index]["cmmtContent"] ?? "",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      commentList[index]["creDateTxt"] ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // 댓글 입력란을 여기로 이동
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: commentList.isEmpty ? "첫 댓글을 남겨보세요" : "댓글을 남겨보세요", // 조건에 따라 힌트 텍스트 변경
                                border: InputBorder.none, // 테두리를 없앰
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // 내부 패딩 조정
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue, // 배경색
                              borderRadius: BorderRadius.circular(0), // 둥근 모서리
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26, // 그림자 색상
                                  blurRadius: 6, // 그림자 흐림 정도
                                  offset: Offset(2, 2), // 그림자 위치
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                size: 24, // 아이콘 크기 조정
                                color: Colors.white, // 아이콘 색상
                              ),
                              onPressed: saveCommentInfo,
                              tooltip: '댓글 보내기',
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 알림창 팝업
  void _showConfirmDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 작성글 삭제
                endBoardInfo();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // [서비스] 게시판 조회수 증가
  Future<void> boardRdCntUp() async {
    // REST ID
    String restId = "boardRdCntUp";

    // PARAM
    final param = jsonEncode({
      "bordType": "B1",
      "bordNo": boardDetailInfo["bordNo"],
      "bordSeq": boardDetailInfo["bordSeq"],
    });

    // API 호출 (게시판 상세 조회)
    final _bordRdCnt = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardDetailInfo["bordRdCnt"] = boardDetailInfo["bordRdCnt"] + 1;
    });
  }

  // [서비스] 게시판 상세 조회
  Future<void> getBoardDetailList() async {
    // REST ID
    String restId = "getBoardDetailInfo";

    // PARAM
    final param = jsonEncode({
      "bordType": "B1",
      "bordNo": boardDetailInfo["bordNo"],
      "bordSeq": boardDetailInfo["bordSeq"],
    });

    // API 호출 (게시판 상세 조회)
    final _boardDetailInfo = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardDetailInfo = _boardDetailInfo;
    });
  }

  // [서비스] 게시판 상세 이미지 조회
  Future<void> getBoardDetailImageList() async {
    // REST ID
    String restId = "getBoardDetailImageList";

    // PARAM
    final param = jsonEncode({
      "bordType": "B1",
      "bordNo": boardDetailInfo["bordNo"],
    });

    // API 호출 (게시판 상세 조회)
    final _boardDetailImageList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardDetailImageList = _boardDetailImageList;
    });
  }

  // [서비스] 댓글 리스트 조회
  Future<void> getCommentList() async {
    print("댓글 리스트 조회");

    // REST ID
    String restId = "getCommentList";

    // PARAM
    final param = jsonEncode({
      "bordNo": boardDetailInfo["bordNo"],
      "bordSeq": boardDetailInfo["bordSeq"],
    });

    // API 호출 (게시판 상세 조회)
    final _commentList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      commentList = _commentList;
    });
  }

  // 댓글 저장
  Future<void> saveCommentInfo() async {
    String cmmtContent = commentController.text;

    // 댓글 내용이 비어있지 않은 경우에만 추가
    if (cmmtContent.isNotEmpty) {
      // REST ID
      String restId = "saveCommentInfo";

      // PARAM
      final param = jsonEncode({
        "bordNo": boardDetailInfo["bordNo"],
        "bordSeq": boardDetailInfo["bordSeq"],
        "cmmtContent": cmmtContent,
        "creUser": "테스트",
      });

      // API 호출 (댓글 추가)
      final _commentList = await sendPostRequest(restId, param);

      // 댓글 리스트 갱신
      setState(() {
        commentList = _commentList;
        commentController.clear();
      });
    }
  }

  // [서비스] 게시판 종료
  Future<void> endBoardInfo() async {
    // REST ID
    String restId = "endBoardInfo";

    // PARAM
    final param = jsonEncode({
      "bordType": "B1",
      "bordNo": boardDetailInfo["bordNo"],
      "bordSeq": boardDetailInfo["bordSeq"],
      "updUser": "테스트",
    });

    // API 호출 (게시판 상세 조회)
    final result = await sendPostRequest(restId, param);

    if (result > 0) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요.')),
      );
    }

  }
  
  // 댓글 삭제
  Future<void> deleteCommentInfo() async {
    String cmmtContent = commentController.text;

    // 댓글 내용이 비어있지 않은 경우에만 추가
    if (cmmtContent.isNotEmpty) {
      // REST ID
      String restId = "saveCommentInfo";

      // PARAM
      final param = jsonEncode({
        "bordNo": boardDetailInfo["bordNo"],
        "bordSeq": boardDetailInfo["bordSeq"],
        "cmmtContent": cmmtContent,
        "updUser": "테스트",
      });

      // API 호출 (댓글 추가)
      final _commentList = await sendPostRequest(restId, param);

      // 댓글 리스트 갱신
      setState(() {
        commentList = _commentList;
        commentController.clear();
      });
    }
  }
}

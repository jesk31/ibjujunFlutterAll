import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:witibju_1/util/wit_api_ut.dart';
import 'dart:convert';
import 'package:witibju_1/screens/board/wit_board_detail_sc.dart';
import 'package:witibju_1/screens/board/wit_board_write_sc.dart';
import 'package:witibju_1/util/wit_code_ut.dart';
import '../home/wit_home_theme.dart';

// 게시판 메인
class Board extends StatefulWidget {
  final secureStorage = FlutterSecureStorage(); // Flutter Secure Storage 인스턴스
  final String boardType; // 전달받은 게시판 타입

  Board(this.boardType, {Key? key}) : super(key: key); // 생성자에서 게시판 타입 전달

  @override
  State<StatefulWidget> createState() {
    return BoardState();
  }
}

class BoardState extends State<Board> {
  // 게시판 리스트
  List<dynamic> boardList = [];
  // 검색 여부
  bool _isSearching = false;
  // 검색 Text 컨트롤러
  TextEditingController _searchController = TextEditingController();
  // 페이징 컨트롤러
  ScrollController _scrollController = ScrollController();
  // 페이징 로딩 여부
  bool isLoading = false;
  // 페이징 시작 번호
  int currentPage = 1;
  // 페이징 1회 건수
  final int pageSize = 10;

  // 게시판 이름
  String _boardTitle = ""; //

  @override
  void initState() {
    super.initState();
    // 스크롤 이벤트 추가
    _scrollController.addListener(_onScroll);
    // 게시판 리스트 조회
    currentPage = 1;
    boardList = [];
    _initializeBoardTitle(); // 아파트 이름 초기화
    getBoardList();
  }

  // secureStorage에서 boardTitle을 불러오는 함수
  Future<void> _initializeBoardTitle() async {
    String? title = await widget.secureStorage.read(key: 'mainAptNm');
    setState(() {
      _boardTitle = title ?? "제목 없음"; // 읽어온 값이 null일 경우 "제목 없음"으로 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 화면 안전 영역
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController, // 스크롤 컨트롤러 추가
          thumbVisibility: true, // 스크롤바를 항상 보이게 설정
          // 사용자 정의 스크롤뷰
          child: RefreshIndicator(
            // 스와이프시 새로고침
            onRefresh: refreshBoardList,
            child: CustomScrollView(
              // 스크롤 컨트롤러 추가
              controller: _scrollController,
              // slivers : 스크롤시 헤드 사라지고 나오게 하는 객체
              slivers: [
                // Appbar 정의
                // Appbar 정의
                SliverAppBar(
                  floating: true,
                  snap: true,
                  expandedHeight: 40.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: WitHomeTheme.nearlyBlue, // 테마 색상 적용
                    ),
                    titlePadding: EdgeInsetsDirectional.only(start: 16.0, bottom: 16.0), // 왼쪽 정렬 패딩 설정
                    title: _isSearching
                        ? // 검색 INPUT
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: TextStyle(color: WitHomeTheme.nearlyWhite), // 테마 색상 적용
                      decoration: InputDecoration(
                        hintText: "검색...",
                        hintStyle: TextStyle(color: WitHomeTheme.nearlyWhite.withOpacity(0.54)),
                        border: InputBorder.none,
                      ),
                      // 엔터시 검색
                      onSubmitted: (String value) {
                        refreshBoardList();
                      },
                    )
                        : Text(
                      _boardTitle,
                      style: WitHomeTheme.headline.copyWith(
                        color: WitHomeTheme.notWhite,
                      ),
                    ),
                  ),
                  leading: Container(), // 이전으로 가는 화살표 제거
                  // 이벤트
                  actions: [
                    // 돋보기 버튼
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: WitHomeTheme.nearlyWhite, // 테마 색상 적용
                      ),
                      // 돋보기 버튼 이벤트
                      onPressed: () {
                        if (_isSearching) {
                          if (_searchController.text.isEmpty) {
                            // 검색어가 비어있을 경우 알림창 표시
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('알림',
                                      style: WitHomeTheme.subtitle.copyWith(
                                        fontSize: 18,
                                      )),
                                  content: Text('검색어를 입력해 주세요.',
                                      style: WitHomeTheme.body1.copyWith(
                                        fontSize: 14,
                                      )),
                                  actions: [
                                    TextButton(
                                      child: Text('확인'),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // 알림창 닫기
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // 검색 버튼 클릭 시 동작
                            refreshBoardList();
                          }
                        } else {
                          // 검색 모드로 전환
                          _toggleSearch();
                        }
                      },
                    ),
                    if (_isSearching)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: WitHomeTheme.nearlyWhite, // 테마 색상 적용
                        ),
                        onPressed: _toggleSearch,
                      ),
                  ],
                ),
                // 게시판 리스트
                if (boardList.isEmpty) // 리스트가 비어 있을 때
                  SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5, // 화면의 절반 높이
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline, // 정보 아이콘 추가
                              size: 48,
                              color: WitHomeTheme.grey.withOpacity(0.6), // 테마 색상 적용
                            ),
                            SizedBox(height: 16), // 아이콘과 텍스트 사이의 간격
                            Text(
                              "조회된 값이 없습니다",
                              style: WitHomeTheme.headline.copyWith(
                                color: WitHomeTheme.grey.withOpacity(0.8), // 테마 색상 적용
                              ),
                            ),
                            SizedBox(height: 8), // 텍스트 아래 간격
                            Text(
                              "다른 조건으로 다시 검색해 보세요.",
                              style: WitHomeTheme.body2.copyWith(
                                color: WitHomeTheme.grey.withOpacity(0.5), // 테마 색상 적용
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else // 리스트에 아이템이 있을 때
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final boardInfo = boardList[index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text(boardInfo["bordTitle"]),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => BoardDetail(param: boardInfo),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                ).then((_) {
                                  refreshBoardList();
                                });
                              },
                            ),
                            Divider(),
                          ],
                        );
                      },
                      childCount: boardList.length,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 50.0,
        height: 50.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => BoardWrite(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            ).then((result) {
              refreshBoardList();
            });
          },
          child: Icon(Icons.add),
          backgroundColor: WitHomeTheme.nearlyBlue, // 테마 색상 적용
        ),
      ),
    );
  }

  // [서비스] 게시판 리스트 조회
  Future<void> getBoardList() async {
    if (isLoading) return; // 이미 로딩 중이면 무시

    setState(() {
      isLoading = true;
    });

    // REST ID
    String restId = "getBoardList";

    String? boardNo = await widget.secureStorage.read(key: 'mainAptNo');


    // PARAM
    final param = jsonEncode({
      "bordNo": boardNo,
      "bordType": widget.boardType, // 전달받은 게시판 타입 사용
      "searchText": _searchController.text.trim(),
      "currentPage": (currentPage - 1) * pageSize,
      "pageSize": pageSize,
    });

    // API 호출 (게시판 리스트 조회)
    final _boardList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardList.addAll(_boardList);
      currentPage++; // 페이지 증가
      isLoading = false;
    });
  }

  // [서비스] 게시판 리스트 새로고침
  Future<void> refreshBoardList() async {
    currentPage = 1;
    boardList = [];

    // REST ID
    String restId = "getBoardList";
    String? boardNo = await widget.secureStorage.read(key: 'mainAptNo');
    // PARAM
    final param = jsonEncode({
      "bordNo": boardNo,
      "bordType": widget.boardType, // 전달받은 게시판 타입 사용
      "searchText": _searchController.text.trim(),
      "currentPage": (currentPage - 1) * pageSize,
      "pageSize": pageSize,
    });

    // API 호출 (게시판 리스트 조회)
    final _boardList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardList.addAll(_boardList);
      currentPage++; // 페이지 증가
      isLoading = false;
    });
  }

  // [이벤트] 스크롤 이벤트
  void _onScroll() {
    // 스크롤이 최하단에 도달하면 추가 데이터 로드
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      getBoardList();
    }
  }

  // [이벤트] 게시판 검색 토글 이벤트
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });

    if (!_isSearching) {
      _searchController.clear();
      refreshBoardList();
    }
  }

  // [유틸] 오늘 날짜인지 확인하는 함수
  bool isToday(String dateString) {
    DateTime createdDate = DateTime.parse(dateString); // 글 작성 날짜를 DateTime으로 변환
    DateTime today = DateTime.now();
    return createdDate.year == today.year && createdDate.month == today.month && createdDate.day == today.day;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

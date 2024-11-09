import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:witibju_1/screens/home/widgets/wit_home_widgets.dart';
import 'package:witibju_1/screens/home/wit_company_detail_sc.dart';
import 'package:witibju_1/screens/home/wit_compay_view_sc_horizontal.dart';
import 'package:witibju_1/screens/home/wit_home_sc.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';
import 'package:witibju_1/screens/home/wit_compay_view_sc_.dart';
import 'package:witibju_1/screens/home/wit_estimate_detail.dart';

import '../../util/wit_api_ut.dart';
import 'models/category.dart';
/// 다건 견적진행
dynamic companyInfo = {};

class getEstimate extends StatefulWidget {
  const getEstimate({super.key});

  @override
  State<getEstimate> createState() => _getEstimateState();
}

class _getEstimateState extends State<getEstimate> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedItemCount = 0; // 선택된 아이템의 갯수를 추적하는 변수 추가
  List<Category> categoryList = [];
  List<bool> selectedList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 회사 목록 조회
    getCategoryList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getCategoryList() async {
    String restId = "getCategoryList";

    final param = jsonEncode({
      "inspId": companyInfo["inspId"],
    });

    final _categoryList = await sendPostRequest(restId, param);

    setState(() {
      categoryList = Category().parseCategoryList(_categoryList)!;
      selectedList = List<bool>.filled(categoryList.length, false); // categoryList의 길이에 맞춰 selectedList를 초기화
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('견적받기'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            tabs: ['견적서비스', '아파트커뮤니티'].map((name) => Tab(text: name)).toList(),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4.0, color: Colors.blue),
            ),
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                getPopularCourseUI(), // 첫 번째 탭의 내용
                getApartmentCommunity(), // 두 번째 탭의 내용
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                sendRequestInfo(); // 버튼 클릭 시 견적 요청 메서드 호출
              },
              child: Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: RichText( // 기존 Text 위젯 대신 RichText 사용
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '견적 요청하기 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '(${_selectedItemCount})', // 선택된 아이템 갯수를 표시
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 /* void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }*/
  // 견적 요청 정보 보내기 메서드
  Future<void> sendRequestInfo() async {
    String restId = "saveTotalRequestInfo";
    // 선택된 항목들에 대한 정보 (카테고리 및 회사 목록)를 준비
    List<String> selectedItems = [];
    for (int i = 0; i < categoryList.length; i++) {
      if (selectedList[i]) {
        selectedItems.add(categoryList[i].categoryId); // 선택된 카테고리 ID 수집
      }
    }

    final param = jsonEncode({
      "reqGubun": 'T',
      "reqUser": '72091587', // 사용자의 정보 또는 ID를 넣을 수 있음
      "categoryIds": selectedItems // 선택된 카테고리 ID 목록
    });

    try {
      final response = await sendPostRequest(restId, param);

      if (response != null) {
        // 성공 시 알림을 띄우고 HomeScreen으로 이동
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('견적 요청을 완료했습니다.')),
        );

        // HomeScreen으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        throw Exception('응답 없음');
      }
    } catch (e) {
      print('견적 요청 실패: $e');
      // 실패 시 에러 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('견적 요청에 실패했습니다. 다시 시도해 주세요.')),
      );
    }
  }

  // 카테고리 ID를 기준으로 인덱스 찾기
  int findCategoryIndex(String categoryId) {
    return categoryList.indexWhere((category) => category.categoryId == categoryId);
  }

  Widget getPopularCourseUI() {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: PopularCourseListHorizontalView(
                    /// 2024-08-10: 콜백 함수에서 두 인자 (Company, bool) 처리하도록 수정
                    callBack: (Category category, bool isSelected) {
                      setState(() {
                        // categoryId를 사용해 인덱스 찾기
                        int index = findCategoryIndex(category.categoryId);

                        print('Selected category: ${category.categoryId}, Index: $index');

                        if (index != -1) {
                          if (isSelected) {
                            _selectedItemCount++; // 아이템이 선택되면 갯수 증가
                            selectedList[index] = true;
                          } else {
                            _selectedItemCount--; // 선택 해제되면 갯수 감소
                            selectedList[index] = false;
                          }
                          // 카운트가 음수로 가지 않도록 방어 로직 추가
                          if (_selectedItemCount < 0) _selectedItemCount = 0;
                          print('_selectedItemCount: $_selectedItemCount'); // 현재 선택된 갯수를 출력 (디버깅용)
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 4), // 간격 줄이기
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getApartmentCommunity() {
    return Center(
      child: Text('아파트 커뮤니티 탭의 내용'), // 두 번째 탭의 내용
    );
  }
}

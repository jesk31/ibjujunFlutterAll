import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:witibju_1/screens/home/widgets/wit_home_widgets.dart';
import 'package:witibju_1/screens/home/wit_home_sc.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';
import '../../util/wit_api_ut.dart';
import '../board/wit_board_main_sc.dart';
import 'models/company.dart';

/// 단건 견적상세
dynamic companyInfo = {};

class DetailCompany extends StatefulWidget {
  final String title;
  final String categoryId;

  final secureStorage = FlutterSecureStorage(); // Flutter Secure Storage 인스턴스

  DetailCompany({super.key, required this.title, required this.categoryId});

  @override
  State<DetailCompany> createState() => _DetailCompanyState();
}

// 수정된 부분: SingleTickerProviderStateMixin에서 TickerProviderStateMixin으로 변경 - 10/21
class _DetailCompanyState extends State<DetailCompany> with TickerProviderStateMixin { // 10/21
  List<Company> companyList = []; // API로부터 받아오는 회사 리스트
  final List<String> tabNames = ['견적서비스', '아파트 커뮤니티'];
  final List<String> communityTabNames = ['내 APT', 'HOT 정보', '업체후기']; // 10/21
  List<String> selectedItems = []; // 선택된 항목 리스트
  late TabController _tabController;
  late TabController _communityTabController; // 10/21 아파트 커뮤니티 탭 컨트롤러
  bool isAllSelected = true;
  bool showBottomButton = true;
  String? mainAptNo; // 'mainAptNo'를 저장할 변수 선언

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _communityTabController = TabController(length: 3, vsync: this); // 10/21 아파트 커뮤니티 탭 컨트롤러 초기화

    // 회사 목록 조회 - 2024-10-19
    getCompanyList(widget.categoryId);

    // 초기 mainAptNo 읽기
    _loadMainAptNo(); // 10/21

    // 탭 변경 시 상태 변경 - 2024-10-19
    _tabController.addListener(() async {
      setState(() {
        showBottomButton = _tabController.index == 0; // 첫 번째 탭일 때만 버튼 표시 - 2024-10-19
      });
    });

    // 기존 Community 탭 리스너 제거
    // _communityTabController.addListener(() {
    //   if (_communityTabController.indexIsChanging) return; // 탭이 선택될 때만 처리

    //   switch (_communityTabController.index) {
    //     case 0:
    //       navigateToBoard('B1');
    //       break;
    //     case 1:
    //       navigateToBoard('H1');
    //       break;
    //     case 2:
    //       navigateToBoard('C1');
    //       break;
    //   }
    // });
  }

  // mainAptNo를 Flutter Secure Storage에서 읽어오는 비동기 함수 - 10/21
  Future<void> _loadMainAptNo() async { // 10/21
    String? aptNo = await widget.secureStorage.read(key: 'mainAptNo');
    setState(() {
      mainAptNo = aptNo;
      print('======$mainAptNo'); // 확인용 로그
    });
  } // 10/21

  @override
  void dispose() {
    _tabController.dispose();
    _communityTabController.dispose(); // 10/21 커뮤니티 탭 컨트롤러 해제
    super.dispose();
  }

  // Board 화면으로 이동하는 메서드 - 10/21 (이제 사용하지 않음)
  void navigateToBoard(String boardType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Board(boardType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WitHomeTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    getAppBarUI(),
                    WitHomeWidgets.getTabBarUI(_tabController, tabNames),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    getEstimateService(),
                    getCommunityTabs(), // 10/21 아파트 커뮤니티 탭 뷰 호출
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: showBottomButton
            ? Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              // "견적 요청하기" 버튼 클릭 시 sendRequestInfo 메서드 호출 - 2024-10-19
              sendRequestInfo();
            },
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  '견적 요청하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        )
            : null,
      ),
    );
  }

  // 10/21 아파트 커뮤니티 탭 뷰 위젯 생성
  Widget getCommunityTabs() { // 10/21
    return Column(
      children: [
        TabBar(
          controller: _communityTabController,
          tabs: communityTabNames.map((name) => Tab(text: name)).toList(),
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
        ),
        Expanded(
          child: TabBarView(
            controller: _communityTabController,
            children: [
              Board('B1'), // "내 APT" 탭
              Board('H1'), // "HOT 정보" 탭
              Board('C1'), // "업체후기" 탭
            ],
          ),
        ),
      ],
    );
  } // 10/21

  // 회사 목록 조회 메서드 - 2024-10-19
  Future<void> getCompanyList(String categoryId) async {
    String restId = "getCompanyList";
    final param = jsonEncode({"categoryId": widget.categoryId});
    try {
      final _companyList = await sendPostRequest(restId, param);
      setState(() {
        companyList = Company().parseCompanyList(_companyList) ?? [];
        // 기본적으로 모든 회사가 선택되도록 selectedItems 초기화 - 2024-10-19
        selectedItems = companyList.map((company) => company.companyId).toList();
        isAllSelected = true;  // 처음에는 전체 선택 상태로 설정 - 2024-10-19
      });
    } catch (e) {
      print('회사 목록 조회 중 오류 발생: $e');
    }
  }

  // 견적 요청 정보 보내기 메서드 - 2024-10-19
  Future<void> sendRequestInfo() async {
    String restId = "saveRequestInfo";
    final param = jsonEncode({
      "reqGubun": 'S',
      "reqUser": '72091587',
      "categoryId": widget.categoryId,
      "companyIds": selectedItems  // 선택된 회사 ID 배열 - 2024-10-19
    });

    try {
      final response = await sendPostRequest(restId, param);

      if (response != null) {
        // 성공 시 알림을 띄우고 HomeScreen으로 이동 - 2024-10-19
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('견적 요청을 완료했습니다.')),
        );

        // HomeScreen으로 이동 - 2024-10-19
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        throw Exception('응답 없음');
      }
    } catch (e) {
      print('견적 요청 실패: $e');
      // 실패 시 에러 메시지 - 2024-10-19
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('견적 요청에 실패했습니다. 다시 시도해 주세요.')),
      );
    }
  }

  Widget getAppBarUI() {
    return AppBar(
      title: Text(widget.title),
    );
  }

  Widget getEstimateService() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (isAllSelected) {
                  selectedItems.clear();
                } else {
                  selectedItems = companyList.map((company) => company.companyId).toList();
                }
                isAllSelected = !isAllSelected;
              });
            },
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                color: isAllSelected ? Colors.grey : Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  isAllSelected ? '전체 해제' : '전체 선택',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: companyList.length,
              itemBuilder: (context, index) {
                final company = companyList[index];
                bool isSelected = selectedItems.contains(company.companyId);

                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedItems.remove(company.companyId);
                        } else {
                          selectedItems.add(company.companyId);
                        }
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.blue : Colors.transparent,
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ), // 10/21
                      ),
                      child: isSelected
                          ? Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        company.companyNm,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: WitHomeTheme.nearlyBlue,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            company.rateNum,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: WitHomeTheme.nearlyBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedItems.remove(company.companyId);
                      } else {
                        selectedItems.add(company.companyId);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

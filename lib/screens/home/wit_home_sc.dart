import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:witibju_1/screens/home/widgets/wit_home_widgets.dart';
import 'package:witibju_1/screens/home/wit_company_detail_sc.dart';
import 'package:witibju_1/screens/home/wit_compay_view_sc_.dart';
import 'package:witibju_1/screens/home/wit_home_get_estimate.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';
import 'package:witibju_1/screens/home/wit_estimate_detail.dart';
import 'package:witibju_1/screens/home/wit_myprofile_sc.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../util/wit_api_ut.dart';
import 'models/main_view_model.dart';
import 'wit_login_pop_home_sc.dart'; // 로그인 파송창 파일을 임포트
import 'models/category.dart';
import 'models/userInfo.dart';

///메인 홈
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///로그인 상태를 true로 설정해서 테스트 (실제로는 로그인 여부를 판단하는 로직이 필요)
  bool isLogined = true;
  // SelectBox에 표시할 옵션 리스트
  Map<String, String> options = {};
  String selectedOption = ""; // 기본 선택된 옵션

  UserInfo? userInfo; // 사용자 정보를 저장할 변수
  final secureStorage = FlutterSecureStorage(); // Flutter Secure Storage 인스턴스


  @override
  void initState() {
    super.initState();
    _loadOptions();
  }
  // 데이터를 조회하는 비동기 함수
  Future<void> getUserInfo(String kakaoId) async {
    String restId = "getUserInfo";
    final param = jsonEncode({"kakaoId": kakaoId});

    try {
      final response = await sendPostRequest(restId, param);
      setState(() {
        if (response is Map<String, dynamic>) {
          userInfo = UserInfo.fromJson(response);
        } else {
          userInfo = UserInfo.fromJson(jsonDecode(response));
        }


        print('고객 번호: ' + (userInfo!.clerkNo ?? 'Unknown'));
        print('닉네임: '+(userInfo!.nickName??''));
        print('이름: '+(userInfo!.name??''));
        print('역할: '+(userInfo!.role??''));
        print('Main아파트 번호: '+(userInfo!.mainAptNo??''));
        print('Main아파트 이름: '+(userInfo!.mainAptNm??''));
        // 사용자 정보를 Flutter Secure Storage에 저장
        secureStorage.write(key: 'clerkNo', value: userInfo!.clerkNo);
        secureStorage.write(key: 'nickName', value: userInfo!.nickName);
        secureStorage.write(key: 'name', value: userInfo!.name);
        secureStorage.write(key: 'mainAptNo', value: userInfo!.mainAptNo);
        secureStorage.write(key: 'mainAptNm', value: userInfo!.mainAptNm);
        secureStorage.write(key: 'role', value: userInfo!.role);
        secureStorage.write(key: 'aptNo', value: userInfo!.aptNo?.join(',') ?? '');
        secureStorage.write(key: 'aptName', value: userInfo!.aptName?.join(',') ?? '');

        // 사용자 정보에서 아파트 이름을 가져와 옵션 리스트에 추가
        options.clear();

        for (int i = 0; i < userInfo!.aptName!.length; i++) {
          options[userInfo!.aptName![i]] = userInfo!.aptNo![i]; // 사용자 정보의 아파트 이름과 번호를 옵션으로 추가합니다 (10/19)
        }
        if (options.isNotEmpty) {

          if (userInfo!.mainAptNo != null && userInfo!.mainAptNm != null) {
            selectedOption = userInfo!.mainAptNm!;
          } else {
            selectedOption = options.keys.first;
          }
        }
      });
    } catch (e) {
      print('사용자 정보 조회 중 오류 발생: $e');
    }
  }

  Future<void> _loadOptions() async {
    String? aptNameString  = await secureStorage.read(key: 'aptName'); //아파트 명칭
    String? aptNoString  = await secureStorage.read(key: 'aptNo'); //아파트 번호

    if (aptNameString != null && aptNoString != null) {

      List<String> aptNames = aptNameString.split(',');
      List<String> aptNos = aptNoString.split(',');

      setState(() {
        for (int i = 0; i < aptNames.length; i++) {
          options[aptNames[i]] = aptNos[i];
        }
        if (options.isNotEmpty) {
          selectedOption = options.keys.first;
        }
      });
    }
  }


  Future<void> updateMyInfo(String mainAptNo) async {
    print('아파트 번호 모야???'+mainAptNo);

      String restId = "updateMyInfo";
      final param = jsonEncode({
        "clerkNo": await secureStorage.read(key: 'clerkNo'),
        "nickName": await secureStorage.read(key: 'nickName'),
        "mainAptNo": mainAptNo,
      });

      try {
        final response = await sendPostRequest(restId, param);
        if (response != null) {
          String? kakaoId = await secureStorage.read(key: 'kakaoId');
          getUserInfo('3676364728');

        } else {
          print("MY 닉네임 저장 실패: ${response['message']}");
        }
      } catch (e) {
        print('요청 상태 업데이트 중 오류 발생: $e');
      }
  }

  @override
  Widget build(BuildContext context) {
    final mainViewModel = Provider.of<MainViewModel>(context);
    return Container(
      color: WitHomeTheme.nearlyWhite,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: WitHomeTheme.nearlyWhite,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            Row(
              children: [
                // account_circle 아이콘 클릭 시 MyProfile 페이지로 이동
                IconButton(
                  iconSize: 35.0,
                  onPressed: () {
                    if (isLogined) {
                      getUserInfo("3676364728").then((_) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyProfile(), // MyProfile 페이지로 이동
                          ),
                        );
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 300,
                              padding: const EdgeInsets.all(20.0),
                              child: loingPopHome(
                                onLoginSuccess: () {
                                  setState(() {
                                    isLogined = true;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.account_circle, // account_circle 아이콘
                  ),
                ),
                /// 결제함 아이콘
                IconButton(
                  iconSize: 35.0,
                  onPressed: () {
                    if (isLogined) {
                      getUserInfo("3676364728").then((_) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EstimateScreen(), // 결제함 페이지로 이동
                          ),
                        );
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 300,
                              padding: const EdgeInsets.all(20.0),
                              child: loingPopHome(
                                onLoginSuccess: () {
                                  setState(() {
                                    isLogined = true;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.email,
                  ),
                ),
                IconButton(
                  iconSize: 35.0,
                  onPressed: () {
                    // 다른 버튼 클릭 시 동작 정의 (이메일 버튼 클릭)
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              // SelectBox 추가 (하단 파올 표시)
              if (options.isNotEmpty) GestureDetector(
                onTap: () {
                  WitHomeWidgets.showSelectBox(context, selectedOption, options.keys.toList(), (option) {
                    setState(() {
                      selectedOption = option;
                      secureStorage.write(key: 'aptName', value: option);
                    });
                    if (options.containsKey(selectedOption)) {
                      String selectedAptNo = options[selectedOption]!;
                      updateMyInfo(selectedAptNo); // updateMyInfo 호출
                    } else {
                      print('선택한 옵션에 해당하는 번호를 찾을 수 없습니다.');
                    }
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0), // 텍스트 앞에 패딩 추가
                        child: Text(
                          options.isEmpty ? "입주 할 APT 선택하세요" : selectedOption,
                          style: WitHomeTheme.title, // 폰트 스타일 적용
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // ImageBox를 화면에 표시
              SizedBox(
                height: 200,
                child: ImageBox(),
              ),
              const SizedBox(height: 2),
              Text(
                "우리 입주할때 인테리어 비교경제를 받아보세요~",
                style: WitHomeTheme.title,
              ),
              const SizedBox(height: 8),
              // 경제받으러 가기 버튼
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50.0,
                decoration: BoxDecoration(
                  color: WitHomeTheme.nearlyslowBlue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => getEstimate(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    "견적받으러 가기",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              getPopularCourseUI(),  /// 견적받으러 가기
            ],
          ),
        ),
      ),
    );
  }

  /// 최하단 카테고리 리스트 (Popular Course)
  Widget getPopularCourseUI() {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: PopularCourseListView(
              callBack: (Category category) {
                moveTo(category);
              },
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  /// 특정 카테고리 선택 시 상세 페이지로 이동
  void moveTo(Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailCompany(title: category.categoryNm, categoryId: category.categoryId),
      ),
    );
  }
}
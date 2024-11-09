import 'package:witibju_1/screens/home/models/category.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:witibju_1/util/wit_api_ut.dart';
///메인의 하단


dynamic companyInfo = {};

class PopularCourseListView extends StatefulWidget {
  const PopularCourseListView({Key? key, this.callBack}) : super(key: key);

  // 콜백 함수, 사용자가 아이템을 선택했을 때 호출됨
  final Function(Category)? callBack;

  @override
  _PopularCourseListViewState createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView> /*with TickerProviderStateMixin*/ {
  // 애니메이션 컨트롤러 변수
  // AnimationController? animationController;

  List<Category> categoryList = [];

  // 위젯이 처음 생성될 때 호출되는 메서드
  @override
  void initState() {

    super.initState();

    // 사전 점검 상세 항목 리스트 조회
    getCategoryList();
  }

  // 데이터를 비동기로 가져오는 메서드 (딜레이 200ms)
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  // 위젯의 레이아웃을 정의하는 메서드
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          // 데이터를 아직 로드 중일 때 빈 SizedBox 반환
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            int aaa = categoryList.length;
            print('이것이 왔는가????' + aaa.toString());
            // 데이터가 로드되면 GridView를 반환
            return SizedBox(
                height: 600, // 화면의 높이로 GridView 크기를 지정
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: categoryList.length, // 아이템 수
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2개의 열
                  mainAxisSpacing: 8, // 행 간격
                  crossAxisSpacing: 8, // 열 간격
                  childAspectRatio: 1.2, // 자식의 종횡비
                ),
                itemBuilder: (BuildContext context, int index) {
                  final int count = categoryList.length;

                  return CategoryView(
                    callback: () {
                      if (widget.callBack != null) {
                        widget.callBack!(categoryList[index]);
                      }
                    },
                    category: categoryList[index],

                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  // [서비스] 사전 점검 상세 항목 리스트 조회
  Future<void> getCategoryList() async {
    // REST ID
    String restId = "getCategoryList";

    // PARAM
    final param = jsonEncode({
      "inspId": companyInfo["inspId"],
    });

    // API 호출 (사전점검 상세 항목 리스트 조회)
    final _categoryList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      categoryList = Category().parseCategoryList(_categoryList)!;
    });
  }
}

// 각 카테고리 아이템의 뷰를 나타내는 StatelessWidget 클래스
class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key? key, this.category, /*this.animationController, this.animation,*/ this.callback})
      : super(key: key);

  final Function()? callback; // 아이템 클릭 시 호출될 콜백 함수
  final Category? category; // 카테고리 데이터


  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: callback, // 아이템 클릭 시 콜백 호출
      child: Padding(
        padding: const EdgeInsets.all(8.0), // 원하는 padding을 추가
        child: SizedBox(
          height: 200, // 아이템 높이
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                height: 120, // 높이 조절
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // 내부 padding 추가
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 내용물을 가운데 정렬
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 60, // 이미지 높이를 줄여서 고정
                            width: 60,
                            child: Image.asset(category!.imagePath), // 카테고리 이미지
                          ),
                          Expanded( // Expanded로 감싸서 Row 내부의 Text가 넘치지 않도록 함
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                category!.categoryNm, // 카테고리 제목
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.27,
                                  color: WitHomeTheme.darkerText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1, left: 8, right: 8, bottom: 1),
                        child: Column( // 여기서 Row를 Column으로 변경
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${category!.detail}', // 상세문구
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 12,
                                letterSpacing: 0.27,
                                color: WitHomeTheme.grey,
                              ),
                            ),
                            SizedBox(height: 4), // Text 사이의 간격을 조정
                            Row(
                              children: [
                                Text(
                                  '참여업체', // 참여업체 텍스트
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.27,
                                    color: WitHomeTheme.nearlyBlue,
                                  ),
                                ),
                                SizedBox(width: 4), // Text 사이의 간격을 조정
                                Text(
                                  '(${category!.companyCnt})', // 참여업체 갯수
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.27,
                                    color: WitHomeTheme.nearlyBlue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}

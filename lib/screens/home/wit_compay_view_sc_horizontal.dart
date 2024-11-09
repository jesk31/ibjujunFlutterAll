import 'package:witibju_1/screens/home/models/category.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:witibju_1/util/wit_api_ut.dart';

//견적받으러가기 > 견적받기 화면

dynamic companyInfo = {};

class PopularCourseListHorizontalView extends StatefulWidget {
  const PopularCourseListHorizontalView({Key? key, this.callBack}) : super(key: key);

  /// 2024-08-10: 콜백 함수가 선택 상태를 포함하도록 수정
  final Function(Category, bool)? callBack;

  @override
  _PopularCourseListHorizontalViewState createState() => _PopularCourseListHorizontalViewState();
}

class _PopularCourseListHorizontalViewState extends State<PopularCourseListHorizontalView> {
  List<Category> categoryList = [];
  List<bool> selectedList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  Future<void> getCategoryList() async {
    String restId = "getCategoryList";

    final param = jsonEncode({
      "inspId": companyInfo["inspId"],
    });

    final _categoryList = await sendPostRequest(restId, param);

    setState(() {
      categoryList = Category().parseCategoryList(_categoryList)!;
      selectedList = List<bool>.filled(categoryList.length, false);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (categoryList.isEmpty) {
      return const Center(child: Text('No companies available'));
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          height: 600, // 화면의 높이로 ListView 크기를 지정
          child: ListView.builder(
            padding: const EdgeInsets.all(1),
            physics: const BouncingScrollPhysics(),
            itemCount: categoryList.length, // 아이템 수
            itemBuilder: (BuildContext context, int index) {
              return CategoryView(
                callback: () {
                  setState(() {
                    selectedList[index] = !selectedList[index];
                    widget.callBack?.call(categoryList[index], selectedList[index]);
                    /// 2024-08-10: 선택 상태 전달을 위해 callBack에 두 인자 전달
                  });
                },
                category: categoryList[index],
                isSelected: selectedList[index],
              );
            },
          ),
        ),
      );
    }
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key, this.category, this.callback, this.isSelected}) : super(key: key);

  final Function()? callback; // 아이템 클릭 시 호출될 콜백 함수
  final Category? category; // 카테고리 데이터
  final bool? isSelected; // 선택 여부

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: callback, // 아이템 클릭 시 콜백 호출
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 화면의 80% 너비
          height: 80, // 아이템 높이
          margin: const EdgeInsets.symmetric(vertical: 3.0), // 상하 여백 추가
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected! ? WitHomeTheme.nearlysYellow : Colors.grey,
                width: isSelected! ? 3.0 : 1.0), // 선택된 경우 테두리 두께 변경
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0), // 왼쪽 여백 추가
                child: Container(
                  height: 60, // 이미지 높이를 줄여서 고정
                  width: 60,
                  child: category!.imagePath != null && category!.imagePath.isNotEmpty
                      ? Image.asset(category!.imagePath)
                      : Icon(Icons.image, size: 60), // 이미지가 없을 경우 대체 아이콘
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category!.categoryNm ?? 'No Name', // 카테고리 제목
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.27,
                        color: WitHomeTheme.darkerText,
                      ),
                    ),
                    Text(
                      category!.detail ?? 'No Detail', // 상세문구
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 12,
                        letterSpacing: 0.27,
                        color: WitHomeTheme.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '참여업체', // 참여업체 텍스트
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: WitHomeTheme.nearlyBlue,
                          ),
                        ),
                        SizedBox(width: 4), // Text 사이의 간격을 조정
                        Text(
                          '(${category!.companyCnt})개)', // 참여업체 개수
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
              Icon(Icons.chevron_right, color: Colors.grey), // ">" 아이콘 추가
            ],
          ),
        ),
      ),
    );
  }
}

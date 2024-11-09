import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../wit_home_theme.dart';

get onPressed => null;

Widget getAppBarUI() {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '멋진왕자님',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.27,
                  color: WitHomeTheme.darkerText,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          iconSize: 35.0,
          color: Colors.red,
          onPressed: onPressed,
          icon: Icon(
            Icons.email,
          ),
        ),
        IconButton(
          iconSize: 35.0,
          color: Colors.red,
          onPressed: onPressed,
          icon: Icon(
            Icons.view_agenda,
          ),
        ),
      ],
    ),
  );
}

final List<String> imgList = [
  'assets/home/image1.png',
  'assets/home/image2.png'
];

final List<Widget> imageSliders = imgList.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Image.asset(item, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
    ),
  ),
)).toList();

class ImageBox extends StatefulWidget {
  @override
  _ImageBoxState createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.18; // 화면 높이의 25%
    final double width = MediaQuery.of(context).size.width * 0.9; // 화면 너비의 90%

    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          ///color: Colors.red, // 배경색을 검정색으로 설정
          child: CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: true,  //자동재생
              autoPlayInterval: Duration(seconds: 3), // 3초 간격으로 이미지 전환
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              viewportFraction: 1.0, // 이미지가 Container를 완전히 채우도록 설정
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  _controller.animateToPage(entry.key);
                  setState(() {
                    _current = entry.key;
                  });
                },
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/*탭바 및 SelectBox*/
class WitHomeWidgets {
  // getTabBarUI 함수 작성
  static Widget getTabBarUI(TabController tabController, List<String> tabNames) {
    return TabBar(
      controller: tabController,
      tabs: tabNames.map((name) => Tab(text: name)).toList(),
      indicatorColor: Colors.blue,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
    );
  }

  // showSelectBox 함수 추가
  static void showSelectBox(BuildContext context, String selectedOption, List<String> options, Function(String) onSelect) {
    // 선택된 옵션을 맨 위로 올리기 위해 리스트를 재정렬합니다.
    List<String> sortedOptions = [
      selectedOption,
      ...options.where((option) => option != selectedOption)
    ];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '내 APT',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: sortedOptions.map((String option) {
                    return ListTile(
                      title: Container(
                        padding: EdgeInsets.all(8.0), // 테두리와 텍스트 사이에 패딩 추가
                        decoration: BoxDecoration(
                          border: option == selectedOption
                              ? Border.all(
                            color: Colors.blue,
                            width: 2.0, // 테두리 두께 설정
                          )
                              : null,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          option,
                          style: WitHomeTheme.title, // 선택된 옵션의 스타일
                        ),
                      ),
                      onTap: () {
                        onSelect(option);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget getApartmentCommunity() {
  return Center(
    child: Text('아파트 커뮤니티 탭의 내용'),
  );
}

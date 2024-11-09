import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final List<String> imageUrls; // 이미지 URL 리스트
  final int initialIndex; // 초기 이미지 인덱스

  ImageViewer({required this.imageUrls, this.initialIndex = 0});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // 초기 인덱스 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경색 검은색으로 설정
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "이미지 뷰어",
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // 좌우, 위아래 여백 추가
          child: Column(
            children: [
              // 큰 이미지 표시
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrls[currentIndex]),
                      fit: BoxFit.contain, // 이미지 비율 유지하며 크기 조절
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // 작은 이미지 리스트
              Container(
                height: 80, // 작은 이미지 리스트의 높이
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // 클릭 시 큰 이미지 변경
                        setState(() {
                          currentIndex = index; // 클릭한 이미지 인덱스로 변경
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: currentIndex == index ? Colors.red : Colors.transparent,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrls[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
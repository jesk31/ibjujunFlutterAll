import 'package:flutter/material.dart';

class SellerCommunity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2, // 탭의 개수
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 90,
            leading: Container(height: double.infinity,
                child: Center(child: Text(
                    "친철한사장님", style: TextStyle(fontSize: 15, color: Colors.black),
                    textAlign: TextAlign.center))),
            //IconButton(onPressed: () {}, icon: Icon(Icons.menu)), // 왼쪽 메뉴버튼
            title: Text("Profile"),
            centerTitle: true,
            backgroundColor: Colors.lightBlue,
            actions: [
              // 우측의 액션 버튼들
              IconButton(onPressed: () {}, icon: Icon(Icons.perm_identity)),
              IconButton(onPressed: () {}, icon: Icon(Icons.mail))
            ],
          ),
          body: Column(
            children: [
              // 탭 바 추가
              Container(
                color: Colors.grey[200],
                child: TabBar(
                  tabs: [
                    Tab(text: '업체후기'),
                    Tab(text: '테스트탭'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    reviewTab(), // 업체후기 탭 내용
                    reviewTab2(), // 업체후기 2 탭 내용
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewTab() {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '미세방충망 - 친절한 사장님',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '06/02 14:10',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 10),
        reviewCard(
          '주저리 주저리 필요한…… 괜찮고 좋았어요\n계속 구매하고 싶어요',
          reviewId: '후기 ID1',
          rating: 5,
        ),
        commentSection('사장님 댓글', '친절한 사장님: 감사합니다'), // 첫 번째 후기 댓글 섹션
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '미세방충망 - 친절한 사장님',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '06/02 14:10',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 10),
        reviewCard(
          '이번 구매는 매우 만족스러웠어요. 다음에도 또 구매할 예정입니다.',
          reviewId: '후기 ID2',
          rating: 4,
        ),
        commentInputSection(), // 댓글 입력 섹션
      ],
    );
  }

  Widget reviewTab2() {
    return ListView(
      children: [
        reviewCard(
          '두 번째 후기 내용입니다. 매우 만족합니다!',
          reviewId: '후기 ID2',
          rating: 4,
        ),
        commentSection('사장님 댓글', '친절한 사장님: 감사합니다!'), // 두 번째 후기 댓글 섹션
        SizedBox(height: 20),
        reviewCard('아주 좋은 경험이었습니다. 추천합니다.'),
        commentInputSection(), // 댓글 입력 섹션
      ],
    );
  }

  Widget reviewCard(String reviewText, {String? reviewId, int? rating}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 후기 ID와 별점 표시
            Row(
              children: [
                Text(
                  reviewId ?? '후기 ID 없음',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (rating ?? 0) ? Icons.star : Icons.star_border,
                      color: index < (rating ?? 0) ? Colors.yellow : Colors.grey,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(reviewText),
            SizedBox(height: 10),
            // 후기 영역에 사진 추가
            Container(
              width: double.infinity,
              height: 100,
              color: Colors.purple,
              child: Image.asset(
                'assets/image/image1.png', // 광고 이미지 URL
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentSection(String title, String comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Divider(color: Colors.grey, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.comment, color: Colors.grey), // 사장님 아이콘 추가
            ),
            Expanded(
              child: Divider(color: Colors.grey, thickness: 1),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.blue), // 사장님 아이콘
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      comment,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget commentInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          '댓글 입력:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '댓글을 입력하세요...',
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end, // 버튼을 우측 정렬
          children: [
            ElevatedButton(
              onPressed: () {
                // 댓글 제출 로직 (예: 입력된 댓글 저장)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // 버튼 배경색
                foregroundColor: Colors.white, // 텍스트 색상
              ),
              child: Text('댓글 달기'),
            ),
          ],
        ),
      ],
    );
  }
}


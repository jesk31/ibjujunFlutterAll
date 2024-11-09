import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:witibju_1/screens/board/wit_board_main_sc.dart';
import 'package:witibju_1/screens/chat/chatMain.dart';
import 'package:witibju_1/screens/home/models/main_view_model.dart';
import 'package:witibju_1/screens/home/wit_home_sc.dart';
import 'package:witibju_1/screens/home/wit_navigation_home_sc.dart'; // NavigationHomeScreen 임포트
import 'package:witibju_1/screens/home/wit_kakaoLogin.dart';
import 'package:witibju_1/screens/question/wit_question_main_sc.dart';
import 'package:witibju_1/screens/seller/wit_seller_profile_detail_sc.dart';
import 'package:witibju_1/screens/seller/wit_seller_profile_sc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: '7f8159a6844612331340490d87cbb0bb',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainViewModel(KaKaoLogin()), // 구체적인 KakaoLogin 구현체 사용
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      ///home: NavigationHomeScreen(),  기존 밀어서
      ///home: HomeScreen(), //현재 메인
      ///home: Board(),  //게시판
      ///home: Question(qustCd: 'Q00001'),  // 질의문
      ///home: SellerProfileDetail(sllrNo: '17'),  // 판매자
      home: Directionality(
         textDirection: TextDirection.ltr,
       child: ChatPage(),
      ),
    );
  }
}

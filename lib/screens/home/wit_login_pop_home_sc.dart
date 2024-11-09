import 'package:flutter/material.dart';
import 'package:witibju_1/screens/home/models/main_view_model.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';
import 'package:witibju_1/screens/home/wit_kakaoLogin.dart';

class loingPopHome extends StatefulWidget {
  final VoidCallback? onLoginSuccess; // 로그인 성공 시 호출되는 콜백 함수

  loingPopHome({this.onLoginSuccess});

  @override
  State<loingPopHome> createState() => _loingPopHomeState();
}

class _loingPopHomeState extends State<loingPopHome> {
  final viewModel = MainViewModel(KaKaoLogin());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '로그인하고 무료견적을 받아보세요!',
            style: WitHomeTheme.title.copyWith(
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              bool isLoginSuccessful = await viewModel.login();

              if (isLoginSuccessful) {
                // 로그인 성공 시 콜백 호출
                if (widget.onLoginSuccess != null) {
                  widget.onLoginSuccess!();
                }

                // 팝업창 닫기
                Navigator.of(context).pop();
              } else {
                // 로그인 실패 시 에러 메시지를 표시하거나 다른 처리를 할 수 있음
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('로그인에 실패했습니다.')),
                );
              }
            },
            child: Image.asset(
              'assets/home/kakao_login_medium_narrow.png',
              width: 200,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}

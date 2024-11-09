import 'package:flutter/material.dart';
import 'package:witibju_1/screens/home/carousel_slider.dart';
import 'package:witibju_1/screens/home/models/main_view_model.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';
import 'package:witibju_1/screens/home/wit_kakaoLogin.dart';

class kakoLoingHome extends StatefulWidget {
  @override
  State<kakoLoingHome> createState() => _kakoLoingHomeState();
}

class _kakoLoingHomeState extends State<kakoLoingHome> {
  final viewModel = MainViewModel(KaKaoLogin());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///Image.network(viewModel.user?.kakaoAccount?.profile?.profileImageUrl??''),
          Text(
            '${viewModel.isLogined}',
            style: WitHomeTheme.title,
          ),
          ElevatedButton(
            onPressed: () async{
              await viewModel.login();
              setState(() {  });
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () async{
              await viewModel.logout();
              setState(() {  });
            },
            child: const Text('LogOut'),
          ),
        ],
      ),
    );
  }
}

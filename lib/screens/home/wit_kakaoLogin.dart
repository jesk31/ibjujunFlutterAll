import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:witibju_1/screens/home/wit_social_login_sc.dart';

class KaKaoLogin implements SocialLogin {
  @override
  Future<bool> login() async{

    try{
      //카카오톡 어플 확인
      bool isInstalle = await isKakaoTalkInstalled();

      //카카오톡 어플 설치시
      if(isInstalle){
        //카카오톡으로 로그인
        try{
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        }catch(e){
          return false;
        }
      }else{
        //카카오톡 어플 미설치시
        //카카오톡 계정으로 로그인 시도
        try{
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        }catch(e){
          return false;
        }
      }
    }catch(e){
      return false;
    }
  }

  @override
  Future<bool> logOut() async {
    try{
      await UserApi.instance.unlink();
      return true;
    }catch(error){
      return false;
    }

  }


}
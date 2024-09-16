import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pomodoro/screen/login/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _KakaoButtonPressed() async {
    try {
      late OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      }

      print('액세스 토큰: ${token.accessToken}');
      print('리프레시 토큰: ${token.refreshToken}');

      // 사용자 정보 가져오기
      try {
        User user = await UserApi.instance.me();
        print('사용자 정보 요청 성공'
            '\n회원번호: ${user.id}'
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            '\n이메일: ${user.kakaoAccount?.email}');
      } catch (error) {
        print('사용자 정보 요청 실패 $error');
      }
    } catch (error) {
      print('카카오 로그인 실패 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 102, 89, 228),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 100, left: 65, right: 65, bottom: 70),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'images/assets/capture.PNG',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _buildInputField("Email *", "이메일을 입력해주세요"),
              const SizedBox(height: 15),
              _buildInputField("Password *", "패스워드를 입력해주세요"),
              const SizedBox(height: 25),
              _buildLoginButton(),

              const SizedBox(height: 40),
              _buildSocialButtons(context), // 새로 추가된 부분
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25, bottom: 5),
          child: Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print("Login button pressed");
        },
        child: const Text("로그인", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(70, 109, 153, 0),
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildKakaoLoginButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFEE500),
          foregroundColor: Colors.black87,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFEE500),
                foregroundColor: Colors.black87,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("카카오 로그인"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                _KakaoButtonPressed();
              }
              else if(index == 3){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationScreen()));
              }
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: _getContainerColor(index),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: index == 0 ?
                     Image.asset(
                  'images/assets/kakao_lg.png',
                ) : index == 1 ? Image.asset(
                  'images/assets/Google.png',
                ) : index == 2 ? Image.asset(
                  'images/assets/Naver.png',
                ) :Text("회원가입")
              ),
            ),
          );
        }),
      ),
    );
  }

  Color _getContainerColor(int index) {
    switch (index) {
      case 0:
        return Colors.yellow;
      case 2:
        return Colors.white;
      default:
        return Colors.white;
    }
  }
}


import 'dart:math';
import 'package:witibju_1/screens/seller/wit_seller_card_info_sc.dart';
import 'package:witibju_1/screens/seller/wit_seller_cash_history_sc.dart';
import 'package:witibju_1/screens/seller/wit_seller_esitmaterequest_directset_sc.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:witibju_1/util/wit_api_ut.dart';
import 'package:intl/intl.dart';
import 'package:witibju_1/screens/seller/wit_seller_estimaterequest_list_sc.dart';
import 'package:witibju_1/screens/seller/wit_seller_profile_modify_sc.dart';
import 'package:witibju_1/screens/board/wit_board_main_sc.dart';


dynamic sllrNo;

class SellerProfileDetail extends StatefulWidget {
  final dynamic sllrNo;
  const SellerProfileDetail({Key? key, required this.sllrNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    //sellerInfo = this.sellerId;
    return SellerProfileDetailState();
  }
}

class SellerProfileDetailState extends State<SellerProfileDetail> {
  dynamic sellerInfo;
  String storeName = "";
  Map cashInfo = {};

  @override
  void initState() {
    super.initState();
    getSellerInfo(widget.sllrNo);
    getCashInfo(); // 초기화 시 캐시정보를 가져옵니다.
  }

  Future<void> getSellerInfo(dynamic sllrNo) async {

    String restId = "getSellerInfo";
    // PARAM
    final param = jsonEncode({
      "sllrNo": sllrNo,
    });

    print("sllrNo :" + sllrNo.toString());

    // API 호출
    final response = await sendPostRequest(restId, param);

    if (response != null) {
      setState(() {
        sellerInfo = response;
        storeName = sellerInfo['storeName'];
        print('Store Name: $storeName');
      });
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("사업자 프로필 조회가 실패하였습니다.")),
      );
    }

  }

  Future<void> getCashInfo() async {
    // REST ID
    String restId = "getCashInfo";

    // PARAM
    final param = jsonEncode({
      "sllrNo": "17",
    });

    // API 호출 (사전 점검 미완료 리스트 조회)
    final _cashInfo = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      cashInfo = _cashInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leadingWidth: 90,
          leading: Container(height: double.infinity,
              child: Center(child: Text(
                  storeName, style: TextStyle(fontSize: 15, color: Colors.black),
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
        body:
        SingleChildScrollView(
            child: SafeArea(
                child: Column(
                  children: <Widget>[
                    // 광고 이미지 영역
                    Container(
                      width: double.infinity,
                      height: 200,
                      child: Image.asset(
                        'assets/seller/aaa.jpg', // 광고 이미지 URL
                        fit: BoxFit.contain,
                      ),
                    ),
                    // 입주포인트 영역
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.white, // 회색 바탕
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "입주포인트",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              ElevatedButton(onPressed: () {

                                print("sllrNo: " + widget.sllrNo.toString());

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SellerCashHistory(sllrNo: 17)),
                                );
                              },

                                child: Text('캐시충전'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(
                                      255, 3, 199, 90),
                                  surfaceTintColor: Color.fromARGB(
                                      255, 3, 199, 90),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                ),

                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  color: Colors.grey,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Text(
                                    "IBJU",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),

                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                      cashInfo['cash'] != null ? '${NumberFormat('#,###').format(int.parse(cashInfo['cash']))} C' : '0 C',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,

                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 거래내역 버튼
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          // 견적 요청 리스트 팝업 띄우기
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                insetPadding: EdgeInsets.zero, // 여백을 제거하여 가로를 꽉 차게
                                shape: RoundedRectangleBorder( // 모서리를 둥글게 설정
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Container(
                                  width: double.infinity, // 가로 꽉 차게
                                  height: MediaQuery.of(context).size.height * 0.8, // 세로 꽉 차게
                                  padding: EdgeInsets.all(16.0), // 내부 여백 추가
                                  child: SingleChildScrollView( // 스크롤 가능하게 설정
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("거래내역목록", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 10), // 제목과 리스트 사이에 간격 추가
                                        EstimateRequestList(""), // 리스트를 추가
                                        SizedBox(height: 10), // 리스트와 버튼 사이에 간격 추가
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 팝업 닫기
                                          },
                                          child: Text("닫기"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("거래내역"),
                            SizedBox(width: 5),
                            Text(
                              ('(${sellerInfo != null && sellerInfo['ingCnt'] != null ? sellerInfo['ingCnt'].toString() : '0'})'),
                              style: TextStyle(
                                  color: Colors.blue, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 거래내역 버튼
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          // 견적 요청 리스트 팝업 띄우기
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                insetPadding: EdgeInsets.zero, // 여백을 제거하여 가로를 꽉 차게
                                shape: RoundedRectangleBorder( // 모서리를 둥글게 설정
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Container(
                                  width: double.infinity, // 가로 꽉 차게
                                  height: MediaQuery.of(context).size.height * 0.8, // 세로 꽉 차게
                                  padding: EdgeInsets.all(16.0), // 내부 여백 추가
                                  child: SingleChildScrollView( // 스크롤 가능하게 설정
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("견적요청목록", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 10), // 제목과 리스트 사이에 간격 추가
                                        EstimateRequestList("02"), // 리스트를 추가
                                        SizedBox(height: 10), // 리스트와 버튼 사이에 간격 추가
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 팝업 닫기
                                          },
                                          child: Text("닫기"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("견적요청내역"),
                            SizedBox(width: 5),
                            Text(
                              ('(${sellerInfo != null && sellerInfo['reqCnt'] != null ? sellerInfo['reqCnt'].toString() : '0'})'),
                              style: TextStyle(
                                  color: Colors.blue, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 거래내역 버튼
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          // 커뮤니티 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Board('B1')),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("커뮤니티"),
                          ],
                        ),
                      ),
                    ),
                    // 거래내역 버튼
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CardInfo()),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("결재정보등록"),
                          ],
                        ),
                      ),
                    ),
                    // 거래내역 버튼
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          // 버튼 클릭 시 수행할 작업 추가
                          // 가입정보 변경 페이지로 이동

                          //int sllrNoForModity = widget.sllrNo;

                          print("sllrNo: " + widget.sllrNo.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                // builder: (context) => SellerProfileModify(sllrNo: widget.sllrNo)),
                                builder: (context) => SellerProfileModify(sllrNo: 17)),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("가입정보 변경"),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          // 버튼 클릭 시 수행할 작업 추가
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EstimateRequestDirect(sllrNo: 17)),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("바로견적 서비스"),
                          ],
                        ),
                      ),
                    ),
                    // 거래내역 버튼
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          // 커뮤니티 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Board('B1')),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("공지사항"),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}

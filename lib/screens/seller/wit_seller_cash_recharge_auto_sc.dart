import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../util/wit_api_ut.dart';

class CashRechargeAuto extends StatefulWidget {
  final dynamic sllrNo;
  const CashRechargeAuto({Key? key, required this.sllrNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CashRechargeAutoState();
  }
}

class CashRechargeAutoState extends State<CashRechargeAuto> {
  dynamic sellerInfo;
  String storeName = "";
  Map cashInfo = {};
  List<dynamic> cashRechargeList = [];
  String? selectedCash; // 선택된 캐시 금액을 저장할 변수

  @override
  void initState() {
    super.initState();
    getSellerInfo(widget.sllrNo);
    getCashInfo(); // 초기화 시 캐시정보를 가져옵니다.
    getCashRechargeList();
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

  Future<void> getCashRechargeList() async {
    // REST ID
    String restId = "getCashRechargeList";

    // PARAM
    final param = jsonEncode({
      "cashGbn": "02", // 01 : 캐시춪전, 02 : 자동충전
    });

    // API 호출 (사전 점검 미완료 리스트 조회)
    final _cashRechargeList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      cashRechargeList = _cashRechargeList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('| 자동캐시충전', style: TextStyle(fontSize: 20)),
            Text('- 충전될때마다 10% 추가 보너스캐시가 적립됩니다.'),
            SizedBox(height: 20),
            ...cashRechargeList.map((rechargeOption) {
              double totalAmount = double.parse(rechargeOption['totalCash'] ?? '0');
              String total = '${NumberFormat('#,###').format(totalAmount)} C';

              double pointRatioAmount = double.parse(rechargeOption['bonusRatio'] ?? '0');
              String fee = '${NumberFormat('#,###').format(pointRatioAmount)}%';

              // bonusCash와 total도 정수로 변환 후 포맷팅
              double bonusCashAmount = double.parse(rechargeOption['bonusCash'] ?? '0');
              String bonus = '${NumberFormat('#,###').format(bonusCashAmount)} 보너스캐시';

              double cashAmount = double.parse(rechargeOption['cash'] ?? '0');
              String amount = '${NumberFormat('#,###').format(cashAmount)}원';

              String recomYn = rechargeOption['recomYn'] ?? 'N';

              bool isRecommended = false;
              if(recomYn == "Y") {
                isRecommended = true;
              }

              return CashOption(
                amount: amount,
                fee: fee,
                total: total,
                bonus: bonus,
                isRecommended : isRecommended,
                isSelected: selectedCash == rechargeOption['totalCash'].toString(), // 선택 상태
                onSelect: () {
                  setState(() {
                    selectedCash = rechargeOption['totalCash'].toString(); // 선택된 캐시 금액 설정
                  });
                },
              );
            }).toList(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (selectedCash != null) {
                      updateCashInfo(selectedCash!); // 선택된 캐시 금액 전달
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("캐시를 선택해 주세요.")),
                      );
                    }
                  },
                  child: Text('결제하기'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // 취소 버튼 로직
                  },
                  child: Text('취소'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '자동충전 이용안내',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '・입주전 유료서비스 이용 시 잔액이 부족하면 설정한 금액으로 자동으로 캐시를 충전하여 편리하게 이용하실 수 있는 기능입니다.\n'
                  '캐시 지급량은 변경될 수 있습니다.\n'
                  '결제수단은 카드결제만 가능합니다.\n'
                  '・충전금액 또는 결제카드 변경 시에는 등록되어 있는 카드를 삭제 또는 서비스 해지 후, 다시 등록하여 변경하실 수 있습니다.\n'
                  '・자동충전 된 캐시는 입주전 서비스 이용약관 입주전 캐시 관련 내용에서 정한 바에 따릅니다.\n'
                  '・바로견적을 이용하는 경우 자동충전을 해지하면 바로견적 발송상태가 자동으로 정지되고, 이후 자동충전 설정 시 견적 발송상태로 변경됩니다.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateCashInfo(String totalCash) async {
    // REST ID
    String restId = "updateCashInfo";

    // PARAM
    final param = jsonEncode({
      "sllrNo": "17",
      "cashNo": cashInfo['cashNo'],
      "cash": totalCash,
      "cashGbn": "01", // 01 : 포인트 충전, 02 : 견적서비스
    });

    // API 호출
    final response = await sendPostRequest(restId, param);

    if (response != null) {
      int sllrNo = response; // response에서 ID 값을 가져옴

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("자동충전이 성공적으로 충전되었습니다.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("캐시 충전에 실패했습니다.")),
      );
    }
  }
}

class CashOption extends StatelessWidget {
  final String amount;
  final String fee;
  final String total;
  final String bonus;
  final bool isRecommended;
  final bool isSelected; // 선택 상태를 나타내는 변수
  final VoidCallback onSelect; // 선택 시 호출할 콜백

  CashOption({
    required this.amount,
    required this.fee,
    required this.total,
    required this.bonus,
    this.isRecommended = false,
    required this.isSelected, // 선택 상태를 필수로 설정
    required this.onSelect, // 콜백을 필수로 설정
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect, // 선택 시 콜백 호출
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow[100] : Colors.white, // 선택된 경우 배경색 변경
          border: Border.all(
            color: isRecommended ? Colors.red : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isRecommended) ...[
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 60),
                          Positioned(
                            child: Text(
                              '인기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ],
                SizedBox(height: 10),
                Text(total, style: TextStyle(fontSize: 20)),
                Text(' $fee', style: TextStyle(color: Colors.grey)),
                Text(' + $bonus', style: TextStyle(color: Colors.grey)),
              ],
            ),
            Text(
              amount,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CardInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CardInfoState();
  }
}

class CardInfoState extends State<CardInfo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친절한사장님'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // 액션 추가
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '결재카드 등록',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Radio(value: 1, groupValue: 0, onChanged: (value) {}),
                  Text('법인카드'),
                ],
              ),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: '카드 번호',
                  hintText: '0000 0000 0000 0000',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '카드 번호를 입력하세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(
                  labelText: '유효기간',
                  hintText: 'MM / YY',
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '유효기간을 입력하세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(
                  labelText: '카드비밀번호',
                  hintText: '비밀번호 앞 2자리 숫자',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '카드 비밀번호를 입력하세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(
                  labelText: '생년월일',
                  hintText: 'YYMMDD',
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '생년월일을 입력하세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center( // 버튼을 Center로 감싸서 가운데 정렬
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // 초록색 배경
                    foregroundColor: Colors.white, // 하얀색 글씨
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // 등록 로직 추가
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('카드가 등록되었습니다.')),
                      );
                    }
                  },
                  child: Text('등록하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

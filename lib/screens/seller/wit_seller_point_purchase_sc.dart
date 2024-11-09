import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('포인트 구매 팝업'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PointPurchaseDialog();
                },
              );
            },
            child: Text('포인트 구매 팝업 열기'),
          ),
        ),
      ),
    );
  }
}

class PointPurchaseDialog extends StatefulWidget {
  @override
  _PointPurchaseDialogState createState() => _PointPurchaseDialogState();
}

class _PointPurchaseDialogState extends State<PointPurchaseDialog> {
  int? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('캐치충전으로 많은 견적서비스를 이용해보세요~'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [3000, 5000, 10000, 30000].map((point) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPoint = point;
                  });
                },
                child: Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedPoint == point ? Colors.red : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('$point P'),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // 결제하기 로직 추가
            Navigator.of(context).pop();
          },
          child: Text('결제하기'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class EstimateRequestExTimePop extends StatefulWidget {
  final dynamic sllrNo;
  const EstimateRequestExTimePop({Key? key, required this.sllrNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EstimateRequestExTimePopState();
  }
}

class EstimateRequestExTimePopState extends State<EstimateRequestExTimePop> {
  bool isSettingExcluded = false; // 설정 여부
  String startTime; // 시작 시간
  String endTime; // 종료 시간

  final List<String> timeOptions = List.generate(24, (index) {
    final hour = index % 12 == 0 ? 12 : index % 12; // 1-12 시각으로 변환
    final period = index < 12 ? '오전' : '오후';
    return '$period $hour:00';
  });

  EstimateRequestExTimePopState()
      : startTime = '오전 12:00', // 기본 시작 시간
        endTime = '오전 06:00'; // 기본 종료 시간

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '견적 발송 제외 시간',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('바로견적이 발송되지 않는 시간을 설정합니다.'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: isSettingExcluded,
                  onChanged: (value) {
                    setState(() {
                      isSettingExcluded = value!;
                      // 설정이 활성화되면 기본 시간을 설정
                      startTime = '오전 12:00';
                      endTime = '오전 06:00';
                    });
                  },
                ),
                Text('설정'),
                Radio<bool>(
                  value: false,
                  groupValue: isSettingExcluded,
                  onChanged: (value) {
                    setState(() {
                      isSettingExcluded = value!;
                    });
                  },
                ),
                Text('설정 없음'),
              ],
            ),
            if (isSettingExcluded) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: timeOptions.contains(startTime) ? startTime : timeOptions[0], // 기본값 설정
                    onChanged: (String? newValue) {
                      setState(() {
                        startTime = newValue!;
                      });
                    },
                    items: timeOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Text('~'),
                  DropdownButton<String>(
                    value: timeOptions.contains(endTime) ? endTime : timeOptions[6], // 기본값 설정
                    onChanged: (String? newValue) {
                      setState(() {
                        endTime = newValue!;
                      });
                    },
                    items: timeOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '견적 발송 제외 시간 설정 시, 설정된 시간에는 바로견적이 발송되지 않습니다. 최대 8시간까지 설정할 수 있습니다.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isSettingExcluded) {
                  // 설정 완료 후 부모 위젯으로 선택한 시간 반환
                  Navigator.of(context).pop({'startTime': startTime, 'endTime': endTime});
                } else {
                  // 설정 없음일 경우
                  Navigator.of(context).pop({'startTime': '설정 없음', 'endTime': '설정 없음'});
                }
              },
              child: Text('수정'),
            ),
          ],
        ),
      ),
    );
  }
}

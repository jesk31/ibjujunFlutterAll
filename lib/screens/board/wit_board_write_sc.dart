import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:witibju_1/screens/board/wit_board_main_sc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:witibju_1/util/wit_api_ut.dart';

class BoardWrite extends StatefulWidget {

  final secureStorage = FlutterSecureStorage(); // Flutter Secure Storage 인스턴스
  final dynamic? boardInfo;
  final List<dynamic>? imageList;

  BoardWrite({Key? key, this.boardInfo, this.imageList}) : super(key: key);

  @override
  _BoardWriteState createState() => _BoardWriteState();
}

class _BoardWriteState extends State<BoardWrite> {

  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // boardInfo가 있을 경우 제목과 내용 설정
    if (widget.boardInfo != null) {
      _titleController.text = widget.boardInfo['bordTitle'] ?? '';
      _contentController.text = widget.boardInfo['bordContent'] ?? '';
    }
    // boardImageList가 있을 경우 이미지 목록 설정
    if (widget.imageList?.isNotEmpty ?? false) {

      /*widget.imageList!.forEach((item) {
        _images.add(Image.network(apiUrl + item["imagePath"]) as File);
      });*/
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "글 작성",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24, // 글자 크기 증가
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue, // 앱바 배경색
        elevation: 10, // 그림자 효과
        shadowColor: Colors.black54,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView( // ListView로 변경
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "제목",
                  border: InputBorder.none, // 테두리 없애기
                ),
                maxLines: 1,
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Container(
                height: 300, // 기본 높이 설정
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: "내용",
                    border: InputBorder.none, // 테두리 없애기
                  ),
                  maxLines: null, // 자동 조절
                  keyboardType: TextInputType.multiline,
                ),
              ),
              SizedBox(height: 16),
              // 이미지 리스트
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // 가로 스크롤 활성화
                child: Row(
                  children: _images.asMap().entries.map((entry) {
                    int index = entry.key;
                    var image = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0), // 이미지 간격
                      child: Stack(
                        children: [
                          ClipRRect( // 모서리 둥글게 만들기
                            borderRadius: BorderRadius.circular(12.0), // 원하는 둥글기 설정
                            child: Image.file(
                              image,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover, // 이미지 비율 유지
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.red), // X 아이콘
                              onPressed: () {
                                setState(() {
                                  _images.removeAt(index); // 이미지 삭제
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                children: [
                  GestureDetector(
                    onTap: () => _pickImages(ImageSource.gallery),
                    child: Column(
                      children: [
                        Icon(Icons.photo, size: 40), // 갤러리 아이콘
                      ],
                    ),
                  ),
                  SizedBox(width: 16), // 아이콘 간격
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.camera),
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt, size: 40), // 카메라 아이콘
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200], // 옅은 회색 배경
                      ),
                      child: Text("취소"),
                    ),
                  ),
                  SizedBox(width: 16), // 버튼 간격
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await saveImages();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200], // 옅은 녹색 배경
                      ),
                      child: Text("작성"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // [서비스] 이미지 저장
  Future<void> saveImages() async {

    // 제목 입력 체크
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("제목을 입력해 주세요.")),
      );
      return;
    }

    // 내용 입력 체크
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("내용을 입력해주세요.")),
      );
      return;
    }
    
    // 이미지 확인
    if (_images.isEmpty) {
      saveBoardInfo(null);
    } else {
      final fileInfo = await sendFilePostRequest("fileUpload", _images);
      if (fileInfo == "FAIL") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("파일 업로드 실패")));
      } else {
        saveBoardInfo(fileInfo);
      }
    }
  }

  // [서비스] 게시판 저장
  Future<void> saveBoardInfo(dynamic fileInfo) async {
    String? boardNo = await widget.secureStorage.read(key: 'mainAptNo');
    String? clerkNo = await widget.secureStorage.read(key: 'clerkNo');

    if (boardNo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("게시판 번호를 가져오지 못했습니다.")),
      );
      return;
    }

    String restId = "";
    var param = null;

    if (widget.boardInfo == null) {

      restId = "saveBoardInfo";
      param = jsonEncode({
        "bordNo": boardNo,
        "bordTitle": _titleController.text,
        "bordContent": _contentController.text,
        "bordType": "B1",
        "creUser":clerkNo,
        "fileInfo": fileInfo
      });

    } else {

      restId = "updateBoardInfo";
      param = jsonEncode({
        "bordTitle": _titleController.text,
        "bordContent": _contentController.text,
        "bordNo" : widget.boardInfo["bordNo"],
        "bordSeq" : widget.boardInfo["bordSeq"],
        "bordType": "B1",
        "updUser": clerkNo,
        "fileInfo": fileInfo
      });
    }

    final result = await sendPostRequest(restId, param);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("저장 성공!")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  Board('B1'), // 키 값을 넘겨줍니다.
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("저장 실패!")));
    }
  }
}

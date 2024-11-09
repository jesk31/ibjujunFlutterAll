import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:witibju_1/screens/seller/wit_seller_profile_detail_sc.dart';
import 'package:witibju_1/util/wit_api_ut.dart';
import 'package:kpostal/kpostal.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return SellerProfileState();
  }
}

class SellerProfileState extends State<SellerProfile> {
  TextEditingController storeNameController = TextEditingController();
  TextEditingController itemPrice1Controller = TextEditingController();
  TextEditingController itemPrice2Controller = TextEditingController();
  TextEditingController itemPrice3Controller = TextEditingController();
  TextEditingController sllrContentController = TextEditingController();
  TextEditingController sllrImageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ceoNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController storeCodeController = TextEditingController();
  TextEditingController storeImageController = TextEditingController();
  TextEditingController hp1Controller = TextEditingController();
  TextEditingController hp2Controller = TextEditingController();
  TextEditingController hp3Controller = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  TextEditingController receiverZipController = TextEditingController();
  TextEditingController receiverAddress1Controller = TextEditingController();
  TextEditingController receiverAddress2Controller = TextEditingController();

  List<String> selectedLocations = [];
  List<String> selectedServiceTypes = [];
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = [];

  // 샘플 이미지 경로
  final List<String> sampleImages = [
    'assets/seller/aaa.jpg',
    'assets/seller/aaa.jpg',
  ];
  final List<String> locations = [
    '용인시 기흥구',
    '용인시 수지구',
    '수원시 영통구',
    '화성시',
  ];

  final List<String> serviceTypes = [
    '미세방충망',
    '커텐',
    '탄성코드',
  ];

  String? selectedLocation;
  String? selectedServiceType;

  final TextEditingController generalPriceController = TextEditingController();
  final TextEditingController premiumPriceController = TextEditingController();
  final TextEditingController specialPriceController = TextEditingController();

  final TextEditingController contact1Controller = TextEditingController();
  final TextEditingController contact2Controller = TextEditingController();
  final TextEditingController contact3Controller = TextEditingController();

  // 새로운 변수 추가
  String? selectedPostalCode;
  String? selectedAddress;
  final TextEditingController detailAddressController = TextEditingController();

  void _addLocation() {
    if (selectedLocation != null &&
        !selectedLocations.contains(selectedLocation)) {
      setState(() {
        selectedLocations.add(selectedLocation!);
        selectedLocation = null; // 선택 후 초기화
      });
    }
  }

  void _addServiceType() {
    if (selectedServiceType != null &&
        !selectedServiceTypes.contains(selectedServiceType)) {
      setState(() {
        selectedServiceTypes.add(selectedServiceType!); // 선택한 서비스 종류 추가
        selectedServiceType = null; // 선택 후 초기화
      });
    }
  }

  Future<void> _pickImage() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles!.addAll(selectedImages);
      });
    }
  }

  Future<List<String>> fetchAddresses(String postalCode) async {
    final response = await http
        .get(Uri.parse('https://api.example.com/postalcode/$postalCode'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // 예시: 주소 목록을 반환
      return List<String>.from(data['addresses']);
    } else {
      throw Exception('주소를 가져오는 데 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 3, 199, 90),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('사업 활동명',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: storeNameController,
                decoration: InputDecoration(
                  hintText: 'Ex) 친절한사장',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Color.fromARGB(255, 3, 199, 90)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('서비스 지역 선택',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text('지역 선택'),
                      value: selectedLocation,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLocation = newValue;
                        });
                      },
                      items: locations
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addLocation,
                    child: Text('선택'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 3, 199, 90),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8.0,
                children: selectedLocations
                    .map((location) => Chip(
                  label: Text(location),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      selectedLocations.remove(location);
                    });
                  },
                ))
                    .toList(),
              ),
              SizedBox(height: 16),
              Text('서비스 종류 선택',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text('종류 선택'),
                      value: selectedServiceType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedServiceType = newValue;
                        });
                      },
                      items: serviceTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addServiceType,
                    child: Text('선택'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 3, 199, 90),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8.0,
                children: selectedServiceTypes
                    .map((serviceType) => Chip(
                  label: Text(serviceType),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      selectedServiceTypes.remove(serviceType);
                    });
                  },
                ))
                    .toList(),
              ),
              SizedBox(height: 16),
              Text('일반',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: itemPrice1Controller,
                      decoration: InputDecoration(
                        hintText: '금액 입력',
                        suffixText: '원',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('업체 설명',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: sllrContentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: '업체 홍보문구를 입력하세요~',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // 사진 추가 기능 구현
                },
                child: Text('사진 추가'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 3, 199, 90),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _imageFiles!.map((image) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: Image.file(
                      File(image.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList()
                  ..addAll(sampleImages.map((imagePath) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        imagePath,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  })),
              ),
              SizedBox(height: 16),
              Text('사업자명 (필수)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('대표자명 (필수)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: ceoNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('대표 이메일 (필수)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('사업자 등록번호 (필수)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: storeCodeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('담당자 연락처 (필수)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: hp1Controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              receiverZipTextField(),
              receiverAddress1TextField(),
              receiverAddress2TextField(),
              SizedBox(height: 20),
              Center( // Center 위젯으로 버튼을 감싸서 가운데 정렬
                child: ElevatedButton(
                  onPressed: () {
                    // 사업자 프로필 등록 로직
                    String storeName = storeNameController.text;
                    String itemPrice1 = itemPrice1Controller.text;
                    String itemPrice2 = itemPrice2Controller.text;
                    String itemPrice3 = itemPrice3Controller.text;
                    String sllrContent = sllrContentController.text;
                    String sllrImage = sllrImageController.text;
                    String name = nameController.text;
                    String ceoName = ceoNameController.text;
                    String email = emailController.text;
                    String storeCode = storeCodeController.text;
                    String storeImage = storeImageController.text;
                    String hp1 = hp1Controller.text;
                    String zipCode = receiverZipController.text;
                    String address1 = receiverAddress1Controller.text;
                    String address2 = receiverAddress2Controller.text;
                    String serviceArea = selectedLocations.join(', ');
                    String serviceItem = selectedServiceTypes.join(', ');

                    saveSellerProfile(
                      storeName,
                      itemPrice1,
                      sllrContent,
                      sllrImage,
                      name,
                      ceoName,
                      email,
                      storeCode,
                      storeImage,
                      hp1,
                      zipCode,
                      address1,
                      address2,
                      serviceArea,
                      serviceItem,
                    );
                  },
                  child: Text('프로필등록'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 3, 199, 90),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // 여백 추가
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // [서비스]견적 정보 저장
  Future<void> saveSellerProfile(
      dynamic storeName,
      dynamic itemPrice1,
      //dynamic itemPrice2,
      //dynamic itemPrice3,
      dynamic sllrContent,
      dynamic sllrImage,
      dynamic name,
      dynamic ceoName,
      dynamic email,
      dynamic storeCode,
      dynamic storeImage,
      dynamic hp1,
      dynamic zipCode,
      dynamic address1,
      dynamic address2,
      dynamic serviceArea,
      dynamic serviceItem,
      ) async {
    // REST ID
    String restId = "saveSellerProfile";

    print("aaaa: : " + "123");

    // PARAM
    final param = jsonEncode({
      "storeName": storeName,
      "serviceArea": serviceArea,
      "serviceItem": serviceItem,
      "itemPrice1": itemPrice1,
      //"itemPrice2": itemPrice2,
      //"itemPrice3": itemPrice3,
      "sllrContent": sllrContent,
      //"sllrImage": sllrImage,
      "sllrImage": "item_image1",
      "name": name,
      "ceoName": ceoName,
      "email": email,
      "storeCode": storeCode,
      //"storeImage": storeImage,
      "storeImage": "item_image2",
      "hp": hp1,
      "zipCode": zipCode,
      "address1": address1,
      "address2": address2,
    });

    // API 호출
    final response = await sendPostRequest(restId, param);

    if (response != null) {
      // 성공적으로 저장된 경우 처리

      int sllrNo = response; // response에서 ID 값을 가져옴

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("사업자 프로필이 성공적으로 저장되었습니다.")),
      );

      // 상세 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellerProfileDetail(sllrNo: sllrNo),
        ),
      );
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("사업자 프로필 저장에 실패했습니다.")),
      );
    }
  }

  Widget receiverZipTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: receiverZipController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "우편번호",
              ),
            ),
          ),
          const SizedBox(width: 15),
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return KpostalView(
                    callback: (Kpostal result) {
                      receiverZipController.text = result.postCode;

                      receiverAddress1Controller.text = result.address;
                    },
                  );
                },
              ));
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 22.0),
              child: Text("우편 번호 찾기"),
            ),
          ),
        ],
      ),
    );
  }

  Widget receiverAddress1TextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverAddress1Controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "기본 주소",
        ),
      ),
    );
  }

  Widget receiverAddress2TextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverAddress2Controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "상세 주소",
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:witibju_1/screens/seller/wit_seller_profile_detail_sc.dart';
import '../../util/wit_api_ut.dart';
import 'package:kpostal/kpostal.dart';

class SellerProfileModify extends StatefulWidget {
  final dynamic sllrNo;
  const SellerProfileModify({Key? key, required this.sllrNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SellerProfileModifyState();
  }
}

class SellerProfileModifyState extends State<SellerProfileModify> {
  dynamic sellerInfo;
  String storeName = "";
  String serviceArea = "";
  String serviceItem = "";
  String itemPrice1 = "";
  String sllrContent = "";
  String sllrImage = "";
  String name = "";
  String ceoName = "";
  String email = "";
  String storeCode = "";
  String storeImage = "";
  String hp = "";
  String zipCode = "";
  String address1 = "";
  String address2 = "";

  @override
  void initState() {
    super.initState();
    getSellerInfo(widget.sllrNo);
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
        storeNameController.text = storeName; // sellerInfo에서 가져온 sllrName 설정

        serviceArea = sellerInfo['serviceArea'];
        serviceItem = sellerInfo['serviceItem'];

        // 선택된 지역이 있으면 selectedLocations에 추가
        if (serviceArea != null) {
          selectedLocations.add(serviceArea!);
        }

        // 선택된 지역이 있으면 selectedItems에 추가
        if (serviceItem != null) {
          selectedServiceTypes.add(serviceItem!);
        }

        itemPrice1 =  sellerInfo['itemPrice1'];
        itemPrice1Controller.text = itemPrice1;

        sllrContent = sellerInfo['sllrContent'];
        sllrContentController.text = sllrContent;

        name = sellerInfo['name'];
        nameController.text = name;

        ceoName = sellerInfo['ceoName'];
        ceoNameController.text = ceoName;

        email = sellerInfo['email'];
        emailController.text = email;

        storeCode = sellerInfo['storeCode'];
        storeCodeController.text = storeCode;

        hp = sellerInfo['hp'];
        hp1Controller.text = hp;

        zipCode = sellerInfo['zipCode'];
        receiverZipController.text = zipCode;

        address1 = sellerInfo['address1'];
        receiverAddress1Controller.text = address1;

        address2 = sellerInfo['address2'];
        receiverAddress2Controller.text = address2;

        print('selectedLocation: $selectedLocation');
      });
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("사업자 프로필 조회가 실패하였습니다.")),
      );
    }

  }

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

  void _selectPostalCode() async {
    String postalCode = ''; // 여기에서 사용자가 입력한 우편번호를 가져와야 합니다.

    try {
      List<String> addresses = await fetchAddresses(postalCode);

      // 다이얼로그에서 주소 선택
      showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('주소 선택'),
            content: SingleChildScrollView(
              child: ListBody(
                children: addresses.map((address) {
                  return GestureDetector(
                    child: Text(address),
                    onTap: () {
                      Navigator.of(context).pop(address);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      ).then((value) {
        if (value != null) {
          setState(() {
            selectedPostalCode = postalCode; // 입력한 우편번호
            selectedAddress = value; // 선택한 주소
          });
        }
      });
    } catch (e) {
      // 오류 처리
      print(e.toString());
    }
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
        title: Text("가입정보 변경"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          // 우측의 액션 버튼들
          IconButton(onPressed: () {}, icon: Icon(Icons.perm_identity)),
          IconButton(onPressed: () {}, icon: Icon(Icons.mail))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: storeNameController,
                /*decoration: InputDecoration(
                  labelText: '*사업 활동명',
                  hintText: 'Ex) 친절한사장',
                ),*/
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text('서비스 지역 선택'),
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
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text('서비스 종류 선택'),
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
                  ),
                ],
              ),
              Wrap(
                spacing: 8.0,
                children: selectedServiceTypes
                    .map((location) => Chip(
                  label: Text(location),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      selectedServiceTypes.remove(location);
                    });
                  },
                ))
                    .toList(),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('일반'),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: itemPrice1Controller,
                          decoration: InputDecoration(
                            hintText: '금액 입력',
                            suffixText: '원',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  /*Row(
                    children: [
                      Expanded(
                        child: Text('고급'),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: itemPrice2Controller,
                          decoration: InputDecoration(
                            hintText: '금액 입력',
                            suffixText: '원',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text('특수'),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: itemPrice3Controller,
                          decoration: InputDecoration(
                            hintText: '금액 입력',
                            suffixText: '원',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: sllrContentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: '업체 설명',
                  hintText: '업체 홍보문구를 입력하세요~',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // 사진 추가 기능 구현
                },
                child: Text('사진 추가'),
              ),
              SizedBox(height: 10),
              // 추가된 이미지 미리보기
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
                // 샘플 이미지 추가
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
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: '사업자명 (필수)',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              TextField(
                controller: ceoNameController,
                decoration: InputDecoration(
                  labelText: '대표자명 (필수)',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: '대표 이메일 (필수)',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              TextField(
                controller: storeCodeController,
                decoration: InputDecoration(
                  labelText: '사업자 등록번호 (필수)',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              // 담당자 연락처 입력란 수정
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hp1Controller,
                      decoration: InputDecoration(
                        labelText: '담당자 연락처 (필수)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  /*SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: hp2Controller,
                      decoration: InputDecoration(
                        labelText: '담당자 연락처 2 (필수)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: hp3Controller,
                      decoration: InputDecoration(
                        labelText: '담당자 연락처 3 (필수)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),*/
                ],
              ),
              receiverZipTextField(),



              receiverAddress1TextField(),



              receiverAddress2TextField(),

              /*Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        var postalCode = value; // 사용자가 입력한 우편번호 저장
                      },
                      controller: zipCodeController,
                      decoration: InputDecoration(
                        labelText: '사업장 주소 (필수)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _selectPostalCode, // 우편번호 검색 메서드 호출
                    child: Text('우편번호 검색'),
                  ),
                ],
              ),*/
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 사업자 프로필 변경 로직
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
                  //String hp2 = hp2Controller.text;
                  //String hp3 = hp13Controller.text;
                  String zipCode = receiverZipController.text;
                  String address1 = receiverAddress1Controller.text;
                  String address2 = receiverAddress2Controller.text;
                  String serviceArea = selectedLocations.join(', '); // 리스트를 문자열로 변환
                  String serviceItem = selectedServiceTypes.join(', '); // 리스트를 문자열로 변환

                  updateSellerProfile(
                      storeName,
                      itemPrice1,
                      itemPrice2,
                      itemPrice3,
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
                      serviceArea, // 서비스 지역
                      serviceItem // 서비스 항목
                  );

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellerProfileDetail(sellerId: null,)),
                  );*/
                },
                child: Text('프로필변경'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 3, 199, 90),
                  surfaceTintColor: Color.fromARGB(255, 3, 199, 90),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // [서비스]프로필 변경
  Future<void> updateSellerProfile(
      dynamic storeName,
      dynamic itemPrice1,
      dynamic itemPrice2,
      dynamic itemPrice3,
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
    String restId = "updateSellerInfo";

    print("itemPrice1 : " + itemPrice1);
    print("sllrContent : " + sllrContent);
    print("email : " + email);

    // PARAM
    final param = jsonEncode({
      "sllrNo": widget.sllrNo,
      "storeName": storeName,
      "serviceArea": serviceArea,
      "serviceItem": serviceItem,
      "itemPrice1": itemPrice1,
      "itemPrice2": itemPrice2,
      "itemPrice3": itemPrice3,
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

      //int sllrNo = response; // response에서 ID 값을 가져옴

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("사업자 프로필이 성공적으로 변경되었습니다.")),
      );

      // 상세 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellerProfileDetail(sllrNo: widget.sllrNo),
        ),
      );
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("사업자 프로필 변경에 실패했습니다.")),
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
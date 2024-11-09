import 'dart:io';
import 'dart:convert';
import 'package:witibju_1/util/wit_code_ut.dart';
import 'package:witibju_1/util/wit_common_ut.dart';
import 'package:http/http.dart' as http;

/**
 * POST 방식 통신
 * @param restId
 * @param Json
 * @return dynamic
 */
Future<dynamic> sendPostRequest(String restId, dynamic param) async {

  Uri uri = Uri.parse(apiUrl + "/wit/" + restId);

  // Head
  final headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // API 호출
  final response = await http.post(uri, headers : headers, body : param ?? "");

  // 호출 성공
  if (response.statusCode == 200) {
    // 성공적으로 데이터를 전송했을 때의 처리
    return json.decode(utf8.decode(response.bodyBytes));

    // 호출 실패
  } else {
    throw Exception('Request failed with status: ${response.statusCode}');

  }

}

/**
 * 파일 POST 방식 통신
 * @param restId
 * @param Json
 * @return dynamic
 */
Future<dynamic> sendFilePostRequest(String restId, List<File> fileList) async {
  // request 생성
  var request = http.MultipartRequest("POST", Uri.parse(apiUrl + "/wit/" + restId));

  // request File 정보 셋팅
  for (var file in fileList) {
    // 이미지 압축
    File compressedFile = await compressImage(file);

    // 압축된 파일 추가
    request.files.add(await http.MultipartFile.fromPath("images", compressedFile.path));
  }

  // request send 호출
  var response = await request.send();

  if (response.statusCode == 200) {
    // 본문 데이터 반환
    var responseData = await http.Response.fromStream(response);
    return responseData.body;
  } else {
    return "FAIL";
  }
}
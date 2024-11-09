class RequestInfo {
  RequestInfo({
    this.reqNo = '',
    this.reqGubun = '',
    this.reqDate = '',
    this.reqDateInfo = '',
    this.reqStateNm = '',
    this.reqState = '',
    this.companyId = '',
    this.categoryId = '',
    this.categoryNm = '',
    this.companyNm = '',
    this.rate = '',
    this.reqContents = '',
    this.timeAgo = '',
    this.estimateAmount = '',
    this.estimateContents = '',
    this.seq = ''
  });

  String reqNo;
  String reqGubun;
  String reqDate;
  String reqDateInfo;
  String reqStateNm;
  String reqState;
  String companyId;
  String categoryId;
  String categoryNm;
  String rate;
  String companyNm;
  String reqContents;
  String timeAgo;
  String estimateAmount;
  String estimateContents;
  String seq;

  // CategoryList를 Category 리스트로 변환하는 함수
  List<RequestInfo>? parseRequestList(List<dynamic> rquestInfoList) {
    return rquestInfoList.map((requestInfo) {
      return RequestInfo(
        reqNo: requestInfo['reqNo'] ?? '',
        reqGubun: requestInfo['reqGubun'] ?? '',
        reqDate: requestInfo['reqDate'] ?? '',
        reqDateInfo: requestInfo['reqDateInfo'] ?? '',
        reqStateNm: requestInfo['reqStateNm'] ?? '',
        reqState: requestInfo['reqState'] ?? '',
        companyId: requestInfo['companyId'] ?? '',
        categoryId: requestInfo['categoryId'] ?? '',
        categoryNm: requestInfo['categoryNm'] ?? '',
        companyNm: requestInfo['companyNm'] ?? '',
        rate: requestInfo['rate'] ?? '',
        seq: requestInfo['seq'] ?? '',
        timeAgo: requestInfo['timeAgo'] ?? '',
        estimateAmount: requestInfo['estimateAmount'] ?? '',
          estimateContents: requestInfo['estimateContents'] ?? '',
        reqContents: requestInfo['reqContents'] ?? ''
          );
    }).toList();
  }


}



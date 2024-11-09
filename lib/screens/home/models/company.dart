class Company {
  Company({
    this.categoryId = '',
    this.companyId = '',
    this.rateNum = '',
    this.companyNm = ''
    ,

  });

  String categoryId;
  String companyId;
  String rateNum;
  String companyNm;

  // CompanyList를 Company 리스트로 변환하는 함수
  List<Company>? parseCompanyList(List<dynamic> companyList) {
    return companyList.map((company) {
      return Company(
          categoryId: company['categoryId'] ?? '',
          companyId: company['companyId'] ?? '',
          companyNm: company['companyNm'] ?? '',
          rateNum: company['rate'] ?? ''
      );
    }).toList();
  }
}

class Category {
  Category({
    this.categoryId = '',
    this.imagePath = '',
    this.detail = '',
    this.clickCount = 0,
    this.companyCnt = 0,
    this.categoryNm = ''
  });

  String categoryId;
  String detail;
  int clickCount;
  int companyCnt;
  String categoryNm;
  String imagePath;

  // CategoryList를 Category 리스트로 변환하는 함수
  List<Category>? parseCategoryList(List<dynamic> categoryList) {
    return categoryList.map((category) {
      return Category(
          categoryId: category['categoryId'] ?? '',
          imagePath: category['imagePath'] ?? 'default_image.png', // 기본 이미지 경로 설정
          categoryNm: category['categoryNm'] ?? '',
          detail: category['detail'] ?? '',
          clickCount: int.tryParse(category['clickCount'].toString()) ?? 0,
          companyCnt: int.tryParse(category['companyCnt'].toString()) ?? 0
      );
    }).toList();
  }
}

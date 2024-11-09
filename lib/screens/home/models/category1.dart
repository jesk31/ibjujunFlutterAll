class Category1 {
  Category1({
    this.title = '',
    this.imagePath = '',
    this.lessonCount = 0,
    this.money = 0,
    this.rating = 0.0
  });

  String title;
  int lessonCount;
  int money;
  double rating;
  String imagePath;

  static List<Category1> Category1List = <Category1>[
    Category1(
      imagePath: 'assets/home/interFace1.png',
      title: 'User interface Design',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Category1(
      imagePath: 'assets/home/interFace2.png',
      title: 'User interface Design',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
    Category1(
      imagePath: 'assets/home/interFace1.png',
      title: 'User interface Design',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Category1(
      imagePath: 'assets/home/interFace2.png',
      title: 'User interface Design',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
  ];

  static List<Category1> popularCourseList = <Category1>[
    Category1(
      imagePath: 'assets/home/interFace3.png',
      title: '미세방충망',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category1(
      imagePath: 'assets/home/interFace4.png',
      title: "커튼",
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category1(
      imagePath: 'assets/home/interFace3.png',
      title: '탄성코팅',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category1(
      imagePath: 'assets/home/interFace4.png',
      title: '가구/가전',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category1(
      imagePath: 'assets/home/interFace4.png',
      title: '입추청소',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category1(
      imagePath: 'assets/home/interFace4.png',
      title: '인테리어',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category1(
      imagePath: 'assets/home/interFace4.png',
      title: 'Web Design Course',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category1(
      imagePath: 'assets/home/interFace4.png',
      title: 'Web Design Course',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
  ];
}


class UserInfo {
  final String id;
  final String? nickName;
  final String? profileImageUrl;
  final String? email;
  final String? clerkNo;
  final String? kakaoId;
  final String? role;
  final String? name;
  final String? mainAptNo;
  final String? mainAptNm;
  final List<String>? aptNo;
  final List<String>? aptName;

  UserInfo({
    required this.id,
    this.nickName,
    this.profileImageUrl,
    this.email,
    this.clerkNo,
    this.kakaoId,
    this.role,
    this.name,
    this.mainAptNo,
    this.mainAptNm,
    this.aptNo,
    this.aptName,
  });

  @override
  String toString() {
    return 'UserInfo{id: $id, nickName: $nickName, profileImageUrl: $profileImageUrl, email: $email}';
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      nickName: json['nickName'],
      profileImageUrl: json['profileImageUrl'],
      email: json['email'],
      clerkNo: json['clerkNo'],
      kakaoId: json['kakaoId'],
      mainAptNo: json['mainAptNo'],
      mainAptNm: json['mainAptNm'],
      role: json['role'],
      name: json['name'],
      aptNo: json['aptNo'] != null ? List<String>.from(json['aptNo']) : null,
      aptName: json['aptName'] != null ? List<String>.from(json['aptName']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickName': nickName,
      'profileImageUrl': profileImageUrl,
      'email': email,
      'clerkNo': clerkNo,
      'kakaoId': kakaoId,
      'mainAptNo': mainAptNo,
      'mainAptNm': mainAptNm,
      'role': role,
      'name': name,
      'aptNo': aptNo,
      'aptName': aptName,
    };
  }
}

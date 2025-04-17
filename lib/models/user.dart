class User {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String? nickname;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authId;

  User({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    this.nickname,
    this.photoUrl,
    required this.authId,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      surname: map['surname'],
      nickname: map['nickname'],
      photoUrl: map['photo_url'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      authId: map['auth_id'],
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? surname,
    String? nickname,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      nickname: nickname ?? this.nickname,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authId: authId ?? this.authId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'nickname': nickname,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'auth_id': authId,
    };
  }
}

class User {
  final String id;
  final String email;
  final String name;
  final String surname;
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
    this.photoUrl,
    required this.authId,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      surname: map['surname'],
      photoUrl: map['photo_url'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      authId: map['auth_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'photo_url': photoUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'auth_id': authId,
    };
  }
}

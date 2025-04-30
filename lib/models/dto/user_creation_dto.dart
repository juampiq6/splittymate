class UserCreationDTO {
  final String email;
  final String name;
  final String surname;
  final String authId;
  final String? nickname;

  UserCreationDTO({
    required this.email,
    required this.name,
    required this.surname,
    required this.authId,
    required this.nickname,
  });

  Map<String, dynamic> toJson() {
    return {
      'auth_id': authId,
      'email': email,
      'name': name,
      'surname': surname,
      'nickname': nickname,
    };
  }
}

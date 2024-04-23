class UserCreationDTO {
  final String email;
  final String name;
  final String surname;
  final String? photoUrl;
  final String authId;

  UserCreationDTO({
    required this.email,
    required this.name,
    required this.surname,
    required this.photoUrl,
    required this.authId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'photo_url': photoUrl,
      'auth_id': authId,
    };
  }
}

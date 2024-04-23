class GroupCreationDTO {
  final String name;
  final String? description;
  final String? imageUrl;
  final String defaultCurrency;

  GroupCreationDTO({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.defaultCurrency,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'default_currency': defaultCurrency,
    };
  }
}

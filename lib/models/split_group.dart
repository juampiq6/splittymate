import 'package:splittymate/models/transactions/exports.dart';
import 'package:splittymate/models/user.dart';

class SplitGroup {
  String id;
  String name;
  String? description;
  String? imageUrl;
  String defaultCurrency;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<User> members;
  List<Transaction> transactions;

  SplitGroup({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.defaultCurrency = 'USD',
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
    required this.transactions,
  });

  factory SplitGroup.fromJson(Map<String, dynamic> json) {
    final expenses =
        (json['expenses'] as List).map((e) => Transaction.fromJson(e)).toList();
    final payments =
        (json['payments'] as List).map((e) => Transaction.fromJson(e)).toList();
    final members = (json['members'] as List)
        .map(
          (e) => User.fromJson(e['user'] as Map<String, dynamic>),
        )
        .toList();

    return SplitGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      defaultCurrency: json['default_currency'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      members: members,
      transactions: [...expenses, ...payments],
    );
  }

  SplitGroup copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? defaultCurrency,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<User>? members,
    List<Transaction>? transactions,
  }) {
    return SplitGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      members: members ?? this.members,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'default_currency': defaultCurrency,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// final exampleList = [
//   SplitGroup(
//     id: "1",
//     name: "Example Group",
//     description: "This is an example group",
//     imageUrl: "https://example.com/image.jpg",
//     createdBy: "John Doe",
//     defaultCurrency: 'USD',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     members: exampleUserList,
//     transactions: exampleEqualShareExpenses,
//   ),
//   SplitGroup(
//     id: "2",
//     name: "Another Group",
//     description: "This is another example group",
//     imageUrl: "https://example.com/another-image.jpg",
//     createdBy: "Jane Doe",
//     defaultCurrency: 'USD',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     members: exampleUserList,
//     transactions: exampleEqualShareExpenses,
//   ),
//   SplitGroup(
//     id: "3",
//     name: "Third Group",
//     description: "This is a third example group",
//     imageUrl: "https://example.com/third-image.jpg",
//     createdBy: "John Doe",
//     defaultCurrency: 'USD',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     members: exampleUserList,
//     transactions: exampleEqualShareExpenses,
//   ),
// ];

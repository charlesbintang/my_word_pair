class WordPairEntity {
  final String id;
  final String firstWord;
  final String secondWord;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  WordPairEntity({
    required this.id,
    required this.firstWord,
    required this.secondWord,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Membuat WordPair dari JSON
  factory WordPairEntity.fromJson(Map<String, dynamic> json) {
    return WordPairEntity(
      id: json['id'] as String,
      firstWord: json['firstWord'] as String,
      secondWord: json['secondWord'] as String,
      category: json['category'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Membuat copy dari WordPair dengan beberapa field yang bisa diubah
  WordPairEntity copyWith({
    String? id,
    String? firstWord,
    String? secondWord,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WordPairEntity(
      id: id ?? this.id,
      firstWord: firstWord ?? this.firstWord,
      secondWord: secondWord ?? this.secondWord,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Mengkonversi WordPair ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstWord': firstWord,
      'secondWord': secondWord,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

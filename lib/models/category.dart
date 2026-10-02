class CategoryTranslation {
  final String language;
  final String name;

  CategoryTranslation({required this.language, required this.name});

  factory CategoryTranslation.fromJson(Map<String, dynamic> json) {
    return CategoryTranslation(
      language: json['language'] as String,
      name: json['name'] as String,
    );
  }
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final List<CategoryTranslation>? translations;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.translations,
  });

  String getLocalizedName(String langCode) {
    if (langCode == 'en' || translations == null || translations!.isEmpty) return name;
    final translation = translations!.where((t) => t.language == langCode).firstOrNull;
    return translation?.name ?? name;
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => CategoryTranslation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

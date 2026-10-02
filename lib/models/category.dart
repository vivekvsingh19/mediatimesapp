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

  static const Map<String, Map<String, String>> _localTranslations = {
    'hi': {
      'bihar': 'बिहार',
      'business': 'व्यापार',
      'case-study': 'केस स्टडी',
      'cover-story': 'कवर स्टोरी',
      'crime': 'अपराध',
      'editorial': 'संपादकीय',
      'education': 'शिक्षा',
      'entertainment': 'मनोरंजन',
      'finance': 'वित्त',
      'health-fitness': 'स्वास्थ्य',
      'healthcare': 'स्वास्थ्य सेवा',
      'human-rights': 'मानव अधिकार',
      'international': 'अंतर्राष्ट्रीय',
      'india': 'भारत',
      'jharkhand': 'झारखंड',
      'job-career': 'नौकरी/करियर',
      'latest': 'नवीनतम',
      'legal': 'कानूनी',
      'life-style': 'जीवन शैली',
      'maharashtra': 'महाराष्ट्र',
      'online-gambling': 'ऑनलाइन जुआ',
      'other': 'अन्य',
      'politics': 'राजनीति',
      'sports': 'खेल',
      'technology': 'प्रौद्योगिकी',
      'tourism': 'पर्यटन',
      'world': 'विश्व',
      'uncategorized': 'अवर्गीकृत'
    },
    'mr': {
      'bihar': 'बिहार',
      'business': 'व्यापार',
      'case-study': 'केस स्टडी',
      'cover-story': 'कव्हर स्टोरी',
      'crime': 'गुन्हेगारी',
      'editorial': 'संपादकीय',
      'education': 'शिक्षण',
      'entertainment': 'मनोरंजन',
      'finance': 'वित्त',
      'health-fitness': 'आरोग्य',
      'healthcare': 'आरोग्य सेवा',
      'human-rights': 'मानवी हक्क',
      'international': 'आंतरराष्ट्रीय',
      'india': 'भारत',
      'jharkhand': 'झारखंड',
      'job-career': 'नोकरी/करिअर',
      'latest': 'नवीनतम',
      'legal': 'कायदेशीर',
      'life-style': 'जीवनशैली',
      'maharashtra': 'महाराष्ट्र',
      'online-gambling': 'ऑनलाइन जुगार',
      'other': 'इतर',
      'politics': 'राजकारण',
      'sports': 'क्रीडा',
      'technology': 'तंत्रज्ञान',
      'tourism': 'पर्यटन',
      'world': 'जग',
      'uncategorized': 'अवर्गीकृत'
    }
  };

  String getLocalizedName(String langCode) {
    if (langCode == 'en') return name;
    if (translations != null && translations!.isNotEmpty) {
      final translation = translations!.where((t) => t.language == langCode).firstOrNull;
      if (translation != null && translation.name.isNotEmpty) return translation.name;
    }
    // Fallback to local hardcoded translation
    return _localTranslations[langCode]?[slug.toLowerCase()] ?? name;
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

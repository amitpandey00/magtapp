/// Language model for visual translation
class Language {
  final String code;
  final String name;
  final String nativeName;
  final String category;
  final String colorHex;

  const Language({required this.code, required this.name, required this.nativeName, required this.category, required this.colorHex});

  static List<Language> getIndianLanguages() {
    return const [Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', category: 'indian', colorHex: '#FF9933'), Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', category: 'indian', colorHex: '#138808'), Language(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', category: 'indian', colorHex: '#FFC107'), Language(code: 'mr', name: 'Marathi', nativeName: 'मराठी', category: 'indian', colorHex: '#FF5722'), Language(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', category: 'indian', colorHex: '#E91E63'), Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', category: 'indian', colorHex: '#9C27B0')];
  }

  static List<Language> getInternationalLanguages() {
    return const [Language(code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', category: 'international', colorHex: '#FF1744'), Language(code: 'ar', name: 'اللغة العربية', nativeName: 'Arabic', category: 'international', colorHex: '#7C4DFF'), Language(code: 'az', name: 'Azərbaycan', nativeName: 'Azerbaijan', category: 'international', colorHex: '#0D47A1'), Language(code: 'bs', name: 'Bosanski', nativeName: 'Bosnian', category: 'international', colorHex: '#00B0FF'), Language(code: 'ceb', name: 'Cebuano', nativeName: 'Cebuano', category: 'international', colorHex: '#D32F2F'), Language(code: 'fil', name: 'Pilipino', nativeName: 'Filipino', category: 'international', colorHex: '#4CAF50'), Language(code: 'fr', name: 'francaise', nativeName: 'French', category: 'international', colorHex: '#7E57C2'), Language(code: 'de', name: 'Deutsche', nativeName: 'German', category: 'international', colorHex: '#FF5252'), Language(code: 'el', name: 'Ελληνικά', nativeName: 'Greek', category: 'international', colorHex: '#00BCD4'), Language(code: 'ht', name: 'Kreyòl', nativeName: 'Haitia Creole', category: 'international', colorHex: '#2962FF')];
  }

  static List<Language> getAllLanguages() {
    return [...getIndianLanguages(), ...getInternationalLanguages()];
  }

  static Language? getLanguageByCode(String code) {
    try {
      return getAllLanguages().firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => '$nativeName ($name)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is Language && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

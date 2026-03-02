class NewsCategories {
  static const String business = 'business';
  static const String entertainment = 'entertainment';
  static const String general = 'general';
  static const String health = 'health';
  static const String science = 'science';
  static const String sports = 'sports';
  static const String technology = 'technology';

  static const List<Map<String, String>> all = [
    {'id': business, 'name': 'Business', 'icon': '💼'},
    {'id': entertainment, 'name': 'Entertainment', 'icon': '🎬'},
    {'id': health, 'name': 'Health', 'icon': '🏥'},
    {'id': science, 'name': 'Science', 'icon': '🔬'},
    {'id': sports, 'name': 'Sports', 'icon': '⚽'},
    {'id': technology, 'name': 'Technology', 'icon': '💻'},
    {'id': general, 'name': 'General', 'icon': '📰'},
  ];
}

class NewsCountries {
  static const String us = 'us';
  static const String gb = 'gb';
  static const String au = 'au';
  static const String ca = 'ca';
  static const String in_ = 'in';
  static const String jp = 'jp';
  static const String kr = 'kr';
  static const String sg = 'sg';
  static const String de = 'de';
  static const String fr = 'fr';

  static const List<Map<String, String>> all = [
    {'id': us, 'name': 'United States', 'flag': '🇺🇸'},
    {'id': gb, 'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'id': au, 'name': 'Australia', 'flag': '🇦🇺'},
    {'id': ca, 'name': 'Canada', 'flag': '🇨🇦'},
    {'id': in_, 'name': 'India', 'flag': '🇮🇳'},
    {'id': jp, 'name': 'Japan', 'flag': '🇯🇵'},
    {'id': kr, 'name': 'South Korea', 'flag': '🇰🇷'},
    {'id': sg, 'name': 'Singapore', 'flag': '🇸🇬'},
    {'id': de, 'name': 'Germany', 'flag': '🇩🇪'},
    {'id': fr, 'name': 'France', 'flag': '🇫🇷'},
  ];
}

/// Shortcut model for quick access links
class Shortcut {
  final String name;
  final String url;
  final String iconUrl;
  final String category;

  const Shortcut({
    required this.name,
    required this.url,
    required this.iconUrl,
    required this.category,
  });

  static List<Shortcut> getShoppingShortcuts() {
    return const [
      Shortcut(
        name: 'Amazon',
        url: 'https://www.amazon.in',
        iconUrl: 'https://logo.clearbit.com/amazon.in',
        category: 'shopping',
      ),
      Shortcut(
        name: 'Flipkart',
        url: 'https://www.flipkart.com',
        iconUrl: 'https://logo.clearbit.com/flipkart.com',
        category: 'shopping',
      ),
      Shortcut(
        name: 'Myntra',
        url: 'https://www.myntra.com',
        iconUrl: 'https://logo.clearbit.com/myntra.com',
        category: 'shopping',
      ),
      Shortcut(
        name: 'Ajio',
        url: 'https://www.ajio.com',
        iconUrl: 'https://logo.clearbit.com/ajio.com',
        category: 'shopping',
      ),
      Shortcut(
        name: 'OLX',
        url: 'https://www.olx.in',
        iconUrl: 'https://logo.clearbit.com/olx.in',
        category: 'shopping',
      ),
      Shortcut(
        name: 'Meesho',
        url: 'https://www.meesho.com',
        iconUrl: 'https://logo.clearbit.com/meesho.com',
        category: 'shopping',
      ),
      Shortcut(
        name: 'Snapdeal',
        url: 'https://www.snapdeal.com',
        iconUrl: 'https://logo.clearbit.com/snapdeal.com',
        category: 'shopping',
      ),
      Shortcut(
        name: 'First Cry',
        url: 'https://www.firstcry.com',
        iconUrl: 'https://logo.clearbit.com/firstcry.com',
        category: 'shopping',
      ),
    ];
  }

  static List<Shortcut> getNewsShortcuts() {
    return const [
      Shortcut(
        name: 'Times of India',
        url: 'https://timesofindia.indiatimes.com',
        iconUrl: 'https://logo.clearbit.com/timesofindia.indiatimes.com',
        category: 'news',
      ),
      Shortcut(
        name: 'Aaj Tak',
        url: 'https://www.aajtak.in',
        iconUrl: 'https://logo.clearbit.com/aajtak.in',
        category: 'news',
      ),
      Shortcut(
        name: 'ABP News',
        url: 'https://www.abplive.com',
        iconUrl: 'https://logo.clearbit.com/abplive.com',
        category: 'news',
      ),
      Shortcut(
        name: 'India Today',
        url: 'https://www.indiatoday.in',
        iconUrl: 'https://logo.clearbit.com/indiatoday.in',
        category: 'news',
      ),
      Shortcut(
        name: 'CNN News',
        url: 'https://www.cnn.com',
        iconUrl: 'https://logo.clearbit.com/cnn.com',
        category: 'news',
      ),
      Shortcut(
        name: 'BBC World News',
        url: 'https://www.bbc.com/news',
        iconUrl: 'https://logo.clearbit.com/bbc.com',
        category: 'news',
      ),
      Shortcut(
        name: 'Zee News',
        url: 'https://zeenews.india.com',
        iconUrl: 'https://logo.clearbit.com/zeenews.india.com',
        category: 'news',
      ),
      Shortcut(
        name: 'NDTV',
        url: 'https://www.ndtv.com',
        iconUrl: 'https://logo.clearbit.com/ndtv.com',
        category: 'news',
      ),
    ];
  }

  static List<Shortcut> getAllShortcuts() {
    return [...getShoppingShortcuts(), ...getNewsShortcuts()];
  }
}


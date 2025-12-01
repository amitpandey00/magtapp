/// Stock Ticker Model
class StockTicker {
  final String symbol;
  final double price;
  final double changePercent;
  final bool isPositive;

  StockTicker({
    required this.symbol,
    required this.price,
    required this.changePercent,
    required this.isPositive,
  });

  factory StockTicker.fromJson(Map<String, dynamic> json) {
    return StockTicker(
      symbol: json['symbol'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      changePercent: (json['changePercent'] ?? 0).toDouble(),
      isPositive: (json['changePercent'] ?? 0) >= 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'price': price,
      'changePercent': changePercent,
      'isPositive': isPositive,
    };
  }
}


class StockDetailState {
  final bool isLoading;
  final List<StockItem> stockItems;
  final String? errorMessage;

  const StockDetailState({
    this.isLoading = false,
    this.stockItems = const [],
    this.errorMessage,
  });

  StockDetailState copyWith({
    bool? isLoading,
    List<StockItem>? stockItems,
    String? errorMessage,
  }) {
    return StockDetailState(
      isLoading: isLoading ?? this.isLoading,
      stockItems: stockItems ?? this.stockItems,
      errorMessage: errorMessage,
    );
  }
}

class StockItem {
  final String symbol;
  final String name;
  final String description;
  final double changePercent;
  final int quantity;
  final String type;
  final String provider;

  StockItem({
    required this.symbol,
    required this.name,
    required this.description,
    required this.changePercent,
    required this.quantity,
    required this.type,
    required this.provider,
  });
}
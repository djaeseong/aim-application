import 'package:flutter/foundation.dart';
import '../../utils/mock_data.dart';
import 'stock_detail_state.dart';

class StockDetailViewModel extends ChangeNotifier {
  StockDetailState _state = const StockDetailState();

  StockDetailState get state => _state;

  StockDetailViewModel() {
    loadStockData();
  }

  Future<void> loadStockData() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Get mock data
      final assetList = MockData.portfolioApiResponse['data']['asset_list'] as List;
      
      // Get all items without filtering
      final stockItems = assetList
          .map((item) => StockItem(
                symbol: item['security_symbol'] ?? '',
                name: item['security_name'] ?? '',
                description: item['security_description'] ?? '',
                changePercent: _getRandomChangePercent(item['security_symbol']),
                quantity: item['quantity'] ?? 1,
                type: item['type'] ?? '',
                provider: _getProviderByType(item['type'] ?? ''),
              ))
          .toList();

      _updateState(_state.copyWith(
        isLoading: false,
        stockItems: stockItems,
      ));
    } catch (error) {
      _updateState(_state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      ));
    }
  }

  // Mock daily change percentages based on symbol
  double _getRandomChangePercent(String symbol) {
    switch (symbol) {
      case 'EWA':
        return -0.60;
      case 'EWG':
        return -0.63;
      case 'EWH':
        return -3.71;
      case 'EWU':
        return -0.81;
      case 'IEF':
        return 0.25;
      case 'TLT':
        return 0.48;
      case 'AGG':
        return 0.12;
      case 'USD_CASH':
        return 0.00;
      default:
        return 0.0;
    }
  }
  
  // Get provider based on asset type
  String _getProviderByType(String type) {
    switch (type) {
      case 'stock':
        return 'iShares';
      case 'bond':
        return 'iShares';
      case 'etc':
        return 'Cash';
      default:
        return 'Unknown';
    }
  }

  void _updateState(StockDetailState newState) {
    _state = newState;
    notifyListeners();
  }
}
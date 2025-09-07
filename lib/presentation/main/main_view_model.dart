import 'package:flutter/foundation.dart';

import '../../utils/mock_data.dart';
import 'main_state.dart';

class MainViewModel extends ChangeNotifier {
  MainState _state = const MainState();

  MainState get state => _state;

  MainViewModel() {
    loadAssets();
  }

  Future<void> loadAssets() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Use mock API response from MockData
      final mockApiResponse = MockData.portfolioApiResponse;

      // Parse API response
      final apiResponse = ApiResponse.fromJson(mockApiResponse);

      // Check if API call was successful
      if (apiResponse.result.code == 0) {
        final assets = apiResponse.data.assetList;

        // Calculate total ratio
        double totalRatio = 0;
        for (final asset in assets) {
          totalRatio += asset.ratio;
        }

        _updateState(_state.copyWith(isLoading: false, assets: assets, totalRatio: totalRatio));
      } else {
        throw Exception(apiResponse.result.message);
      }
    } catch (error) {
      _updateState(_state.copyWith(isLoading: false, errorMessage: error.toString().replaceAll('Exception: ', '')));
    }
  }

  void setFilter(String filter) {
    _updateState(_state.copyWith(selectedFilter: filter));
  }

  void refreshAssets() {
    loadAssets();
  }

  void _updateState(MainState newState) {
    _state = newState;
    notifyListeners();
  }
}

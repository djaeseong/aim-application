import 'package:flutter/foundation.dart';

// Asset model
@immutable
class Asset {
  final String securitySymbol;
  final String type;
  final String securityDescription;
  final int quantity;
  final double ratio;
  final String securityName;

  const Asset({
    required this.securitySymbol,
    required this.type,
    required this.securityDescription,
    required this.quantity,
    required this.ratio,
    required this.securityName,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      securitySymbol: json['security_symbol'] ?? '',
      type: json['type'] ?? '',
      securityDescription: json['security_description'] ?? '',
      quantity: json['quantity'] ?? 0,
      ratio: (json['ratio'] ?? 0).toDouble(),
      securityName: json['security_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'security_symbol': securitySymbol,
      'type': type,
      'security_description': securityDescription,
      'quantity': quantity,
      'ratio': ratio,
      'security_name': securityName,
    };
  }
}

// API Response model
@immutable
class ApiResponse {
  final ApiResult result;
  final ApiData data;

  const ApiResponse({required this.result, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(result: ApiResult.fromJson(json['result'] ?? {}), data: ApiData.fromJson(json['data'] ?? {}));
  }
}

@immutable
class ApiResult {
  final String message;
  final int code;

  const ApiResult({required this.message, required this.code});

  factory ApiResult.fromJson(Map<String, dynamic> json) {
    return ApiResult(message: json['message'] ?? '', code: json['code'] ?? -1);
  }
}

@immutable
class ApiData {
  final List<Asset> assetList;

  const ApiData({required this.assetList});

  factory ApiData.fromJson(Map<String, dynamic> json) {
    final assets =
        (json['asset_list'] as List<dynamic>?)?.map((item) => Asset.fromJson(item as Map<String, dynamic>)).toList() ??
        [];
    return ApiData(assetList: assets);
  }
}

// Main screen state
@immutable
class MainState {
  final bool isLoading;
  final String? errorMessage;
  final List<Asset> assets;
  final double totalRatio;
  final String selectedFilter;

  const MainState({
    this.isLoading = false,
    this.errorMessage,
    this.assets = const [],
    this.totalRatio = 0.0,
    this.selectedFilter = 'all',
  });

  MainState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Asset>? assets,
    double? totalRatio,
    String? selectedFilter,
  }) {
    return MainState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      assets: assets ?? this.assets,
      totalRatio: totalRatio ?? this.totalRatio,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  List<Asset> get filteredAssets {
    if (selectedFilter == 'all') {
      return assets;
    }
    return assets.where((asset) => asset.type == selectedFilter).toList();
  }

  Map<String, double> get assetTypeDistribution {
    final distribution = <String, double>{};
    for (final asset in assets) {
      distribution[asset.type] = (distribution[asset.type] ?? 0) + asset.ratio;
    }
    return distribution;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MainState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        listEquals(other.assets, assets) &&
        other.totalRatio == totalRatio &&
        other.selectedFilter == selectedFilter;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^ errorMessage.hashCode ^ assets.hashCode ^ totalRatio.hashCode ^ selectedFilter.hashCode;
  }
}

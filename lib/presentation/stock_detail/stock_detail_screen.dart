import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../ui_packages/base/spacing.dart';
import 'stock_detail_state.dart';
import 'stock_detail_view_model.dart';

final stockDetailViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => StockDetailViewModel());

class StockDetailScreen extends ConsumerWidget {
  static const route = '/stock-detail';

  const StockDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(stockDetailViewModelProvider);
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFF93D9D9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF93D9D9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('ETF란?', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(),
                AimSpacing.vert4,
                Expanded(child: _buildStockList(state)),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '전체 포트폴리오',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          AimSpacing.vert2,
          const Text(
            '주식, 채권, 현금 등 전체 자산의\n상세 정보와 수익률을 확인하세요',
            style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStockList(StockDetailState state) {
    // Group items by type
    final stockItems = state.stockItems.where((item) => item.type == 'stock').toList();
    final bondItems = state.stockItems.where((item) => item.type == 'bond').toList();
    final etcItems = state.stockItems.where((item) => item.type == 'etc').toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (stockItems.isNotEmpty) ...[
          _buildCategoryTitle('주식형 자산'),
          ...stockItems.map((item) => _buildStockCard(item)),
          AimSpacing.vert4,
        ],
        if (bondItems.isNotEmpty) ...[
          _buildCategoryTitle('채권형 자산'),
          ...bondItems.map((item) => _buildStockCard(item)),
          AimSpacing.vert4,
        ],
        if (etcItems.isNotEmpty) ...[_buildCategoryTitle('기타 자산'), ...etcItems.map((item) => _buildStockCard(item))],
      ],
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildStockCard(StockItem item) {
    final isNegative = item.changePercent < 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildProviderLogo(item.provider),
                const Spacer(),
                Text('전일대비 수익률', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            AimSpacing.vert4,
            Text(
              item.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            AimSpacing.vert2,
            Text(item.description, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4)),
            AimSpacing.vert4,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${isNegative ? '' : '+'}${item.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isNegative ? Colors.blue : Colors.red,
                  ),
                ),
                AimSpacing.horiz3,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF4DD0E1), borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    _getQuantityText(item),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderLogo(String provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Text(
            provider,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          if (provider != 'Cash') Text('by BlackRock', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }

  String _getQuantityText(StockItem item) {
    if (item.type == 'etc') {
      return '${item.quantity}개';
    } else {
      return '${item.quantity}주';
    }
  }
}

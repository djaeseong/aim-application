import 'package:aim_application/presentation/login/login_screen.dart';
import 'package:aim_application/presentation/stock_detail/stock_detail_screen.dart';
import 'package:aim_application/ui_packages/base/spacing.dart';
import 'package:aim_application/ui_packages/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/injection.dart';
import '../../core/shared_preference.dart';
import 'main_state.dart';
import 'main_view_model.dart';

final mainViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => MainViewModel());

class MainScreen extends ConsumerWidget {
  static const route = '/main';
  static const _backgroundColor = Color(0xFF2B3038);
  static const _pieChartSize = 180.0;
  static const _pieChartStrokeWidth = 40.0;

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(mainViewModelProvider);
    final state = viewModel.state;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          viewModel.refreshAssets();
          // Wait for the loading to complete
          await Future.delayed(const Duration(seconds: 2));
        },
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.errorMessage != null
            ? _buildErrorView(state.errorMessage!, viewModel, theme)
            : _buildContent(context, state, viewModel, theme),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃 하시겠습니까?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('취소')),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      try {
        // Call logout function from SharedPreference
        if (GetIt.instance.isRegistered<SharedPreference>()) {
          final sharedPref = dl<SharedPreference>();
          await sharedPref.logout();

          if (context.mounted) {
            // Show success message
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('로그아웃 되었습니다'), duration: Duration(seconds: 1)));

            // Navigate to splash screen and remove all previous routes
            context.goNamed(LoginScreen.route);
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('로그아웃 실패: ${e.toString()}'), backgroundColor: Colors.red));
        }
      }
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('포트폴리오', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      backgroundColor: _backgroundColor,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => _handleLogout(context),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, MainState state, MainViewModel viewModel, ThemeData theme) {
    const assetCategories = ['주식형 자산', '채권형 자산', '기타 자산'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummarySection(context, state, theme),
          AimSpacing.vert8,
          ...assetCategories.map(
            (category) => Column(
              children: [
                _buildAssetBreakdown(state, theme, category),
                if (category != assetCategories.last) AimSpacing.vert6,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, MainState state, ThemeData theme) {
    final distribution = state.assetTypeDistribution;

    if (distribution.isEmpty) {
      return _buildEmptyDataView();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_buildPieChart(context, distribution), const Spacer(), _buildSummaryText()],
    );
  }

  Widget _buildPieChart(BuildContext context, Map<String, double> distribution) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushNamed(StockDetailScreen.route),
      child: SimplePieChart(
        data: distribution.entries
            .map(
              (entry) => PieChartData(
                label: _getTypeLabel(entry.key),
                value: entry.value,
                color: _getAssetCategoryColor(entry.key),
              ),
            )
            .toList(),
        size: _pieChartSize,
        strokeWidth: _pieChartStrokeWidth,
        showPercentage: false,
      ),
    );
  }

  Widget _buildSummaryText() {
    return Column(
      children: [
        const Text(
          '장기투자에 적합한\n적극적인 자산배분',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        AimSpacing.vert2,
        Text(
          "'평생안정 은퇴자금'에\n최적화된 자산배분입니다",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildEmptyDataView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pie_chart_outline, size: 100, color: Colors.grey[600]),
        AimSpacing.horiz4,
        const Text('데이터가 없습니다', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildAssetBreakdown(MainState state, ThemeData theme, String categoryTitle) {
    final categoryType = _getCategoryType(categoryTitle);
    final categoryAssets = state.assets.where((asset) => asset.type == categoryType).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryTitle(categoryTitle),
        AimSpacing.vert2,
        if (categoryAssets.isEmpty)
          _buildEmptyCategoryItem(categoryType)
        else
          ...categoryAssets.map((asset) => _buildAssetItem(asset, theme)),
      ],
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildEmptyCategoryItem(String categoryType) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _getCategoryEmptyLabel(categoryType),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const Text(
            '0.00%',
            style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getCategoryType(String categoryTitle) {
    if (categoryTitle.contains('주식')) return 'stock';
    if (categoryTitle.contains('채권')) return 'bond';
    return 'etc';
  }

  String _getCategoryEmptyLabel(String type) {
    const labels = {'stock': '선진시장 주식\n신흥시장 주식', 'bond': '선진시장 채권\n신흥시장 채권', 'etc': '미화 현금\n대체자산'};
    return labels[type] ?? '';
  }

  Widget _buildAssetItem(Asset asset, ThemeData theme) {
    final typeColor = _getAssetCategoryColor(asset.type);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildColorIndicator(typeColor),
          AimSpacing.horiz3,
          Expanded(
            child: Text(asset.securityName, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
          _buildPercentageText(asset.ratio, typeColor),
        ],
      ),
    );
  }

  Widget _buildColorIndicator(Color color) {
    return Container(
      width: 4,
      height: 20,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _buildPercentageText(double ratio, Color color) {
    return Text(
      '${ratio.toStringAsFixed(2)}%',
      style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Color _getAssetCategoryColor(String type) {
    const colors = {
      'stock': Color(0xFF5AC8FA), // Light blue
      'bond': Color(0xFF4CD964), // Green
      'etc': Color(0xFFFFCC00), // Yellow
    };
    return colors[type] ?? Colors.grey;
  }

  Widget _buildErrorView(String error, MainViewModel viewModel, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            AimSpacing.vert4,
            Text('오류가 발생했습니다', style: theme.textTheme.headlineSmall),
            AimSpacing.vert2,
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
            AimSpacing.vert6,
            ElevatedButton(onPressed: viewModel.refreshAssets, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(String type) {
    const labels = {'stock': '주식', 'bond': '채권', 'etc': '기타'};
    return labels[type] ?? type;
  }
}

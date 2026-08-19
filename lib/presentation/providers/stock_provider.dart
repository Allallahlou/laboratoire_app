import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/stock_model.dart';

class StockNotifier extends StateNotifier<AsyncValue<List<StockItem>>> {
  StockNotifier() : super(const AsyncValue.data([]));

  void loadStock() {
    state = const AsyncValue.data([]);
  }
}

final stockProvider = StateNotifierProvider<StockNotifier, AsyncValue<List<StockItem>>>((ref) => StockNotifier());

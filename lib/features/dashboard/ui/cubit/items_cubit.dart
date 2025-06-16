import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_simple/core/functions/get_invoice_total.dart';
import 'package:invoice_simple/features/settings/data/model/item_model.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsState.initial());

  void addItems(List<ItemModel> items) {
    final updatedItems = List<ItemModel>.from(state.selectedItems);
    updatedItems.addAll(items);
    emit(state.copyWith(selectedItems: updatedItems));
  }

  void removeItem(ItemModel item) {
    final updatedItems = List<ItemModel>.from(state.selectedItems);
    updatedItems.remove(item);
    emit(state.copyWith(selectedItems: updatedItems));
  }

  void clearItems() {
    if (state.selectedItems.isNotEmpty) {
      final updatedItems = List<ItemModel>.from(state.selectedItems);
      updatedItems.clear();
      emit(state.copyWith(selectedItems: updatedItems));
    }
  }

  void clearAllItems() {
    emit(state.copyWith(selectedItems: []));
  }

  double getTotalAmount() {
    return state.selectedItems.fold(
      0.0,
      (sum, item) => sum + ((item.unitPrice ?? 0) * (item.quantity ?? 1)),
    );
  }
}

// ✅ 2️⃣ Items State
class ItemsState {
  final List<ItemModel> selectedItems;

  const ItemsState({required this.selectedItems});

  factory ItemsState.initial() {
    return const ItemsState(selectedItems: []);
  }

  ItemsState copyWith({
    List<ItemModel>? selectedItems,
  }) {
    return ItemsState(
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }

  // ✅ Total Amount Calculation inside State
  double get totalAmount {
    final total = calculateInvoiceTotals(selectedItems);
    return total.total;
  }
}

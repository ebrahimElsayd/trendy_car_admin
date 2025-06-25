import '../../data/models/item_model.dart';

enum ItemState { initial, loading, success, error }

class ItemRiverpodState {
  final ItemState state;
  final List<ItemModel> items;
  final ItemModel? currentItem;
  final String? error;
  final bool isSuccess;

  ItemRiverpodState({
    required this.state,
    this.items = const [],
    this.currentItem,
    this.error,
    this.isSuccess = false,
  });

  factory ItemRiverpodState.initial() {
    return ItemRiverpodState(
      state: ItemState.initial,
      items: [],
      currentItem: null,
      error: null,
      isSuccess: false,
    );
  }

  ItemRiverpodState copyWith({
    ItemState? state,
    List<ItemModel>? items,
    ItemModel? currentItem,
    String? error,
    bool? isSuccess,
  }) {
    return ItemRiverpodState(
      state: state ?? this.state,
      items: items ?? this.items,
      currentItem: currentItem ?? this.currentItem,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  bool operator ==(covariant ItemRiverpodState other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        other.items == items &&
        other.currentItem == currentItem &&
        other.error == error &&
        other.isSuccess == isSuccess;
  }

  @override
  int get hashCode {
    return state.hashCode ^
        items.hashCode ^
        currentItem.hashCode ^
        error.hashCode ^
        isSuccess.hashCode;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/item_model.dart';
import '../../data/repository/item_repository.dart';
import 'item_state.dart';

final itemControllerProvider =
    StateNotifierProvider<ItemController, ItemRiverpodState>((ref) {
      return ItemController(repository: ref.watch(itemRepositoryProvider));
    });

class ItemController extends StateNotifier<ItemRiverpodState> {
  final ItemRepository _repository;

  ItemController({required ItemRepository repository})
    : _repository = repository,
      super(ItemRiverpodState.initial());

  Future<void> getAllItems() async {
    state = state.copyWith(state: ItemState.loading);

    final result = await _repository.getAllItems();
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: ItemState.error,
            error: failure.message,
          ),
      (items) =>
          state = state.copyWith(
            state: ItemState.success,
            items: items,
            isSuccess: true,
          ),
    );
  }

  Future<void> getItemById(String id) async {
    state = state.copyWith(state: ItemState.loading);

    final result = await _repository.getItemById(id);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: ItemState.error,
            error: failure.message,
          ),
      (item) =>
          state = state.copyWith(
            state: ItemState.success,
            currentItem: item,
            isSuccess: true,
          ),
    );
  }

  Future<void> createItem(ItemModel item) async {
    state = state.copyWith(state: ItemState.loading);

    final result = await _repository.createItem(item);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: ItemState.error,
            error: failure.message,
          ),
      (_) {
        state = state.copyWith(state: ItemState.success, isSuccess: true);
        // Refresh the items list
        getAllItems();
      },
    );
  }

  Future<void> updateItem(String id, ItemModel item) async {
    state = state.copyWith(state: ItemState.loading);

    final result = await _repository.updateItem(id, item);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: ItemState.error,
            error: failure.message,
          ),
      (_) {
        state = state.copyWith(state: ItemState.success, isSuccess: true);
        // Refresh the items list
        getAllItems();
      },
    );
  }

  Future<void> deleteItem(String id) async {
    state = state.copyWith(state: ItemState.loading);

    final result = await _repository.deleteItem(id);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: ItemState.error,
            error: failure.message,
          ),
      (_) {
        state = state.copyWith(state: ItemState.success, isSuccess: true);
        // Refresh the items list
        getAllItems();
      },
    );
  }

  void resetState() {
    state = ItemRiverpodState.initial();
  }
}

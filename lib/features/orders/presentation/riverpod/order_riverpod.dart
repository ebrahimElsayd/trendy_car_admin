import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_order_model.dart';
import '../../data/repository/order_repository.dart';
import 'order_state.dart';

final orderControllerProvider =
    StateNotifierProvider<OrderController, OrderRiverpodState>((ref) {
      return OrderController(repository: ref.watch(orderRepositoryProvider));
    });

class OrderController extends StateNotifier<OrderRiverpodState> {
  final OrderRepository _repository;

  OrderController({required OrderRepository repository})
    : _repository = repository,
      super(OrderRiverpodState.initial());

  Future<void> getAllOrders() async {
    state = state.copyWith(state: OrderState.loading);

    final result = await _repository.getAllOrders();
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: OrderState.error,
            error: failure.message,
          ),
      (orders) =>
          state = state.copyWith(
            state: OrderState.success,
            orders: orders,
            isSuccess: true,
          ),
    );
  }

  Future<void> getOrdersByState(String orderState) async {
    state = state.copyWith(state: OrderState.loading);

    final result = await _repository.getOrdersByState(orderState);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: OrderState.error,
            error: failure.message,
          ),
      (orders) =>
          state = state.copyWith(
            state: OrderState.success,
            orders: orders,
            isSuccess: true,
          ),
    );
  }

  Future<void> getOrderById(String orderId) async {
    state = state.copyWith(state: OrderState.loading);

    final result = await _repository.getOrderById(orderId);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: OrderState.error,
            error: failure.message,
          ),
      (order) =>
          state = state.copyWith(
            state: OrderState.success,
            currentOrder: order,
            isSuccess: true,
          ),
    );
  }

  Future<void> getOrdersSummary() async {
    state = state.copyWith(state: OrderState.loading);

    final result = await _repository.getOrdersSummary();
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: OrderState.error,
            error: failure.message,
          ),
      (summary) =>
          state = state.copyWith(
            state: OrderState.success,
            ordersSummary: summary,
            isSuccess: true,
          ),
    );
  }

  Future<void> getRecentOrders({int limit = 10}) async {
    state = state.copyWith(state: OrderState.loading);

    final result = await _repository.getRecentOrders(limit: limit);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: OrderState.error,
            error: failure.message,
          ),
      (orders) =>
          state = state.copyWith(
            state: OrderState.success,
            orders: orders,
            isSuccess: true,
          ),
    );
  }

  void resetState() {
    state = OrderRiverpodState.initial();
  }
}

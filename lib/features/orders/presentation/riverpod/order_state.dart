import '../../data/models/user_order_model.dart';

enum OrderState { initial, loading, success, error }

class OrderRiverpodState {
  final OrderState state;
  final List<UserOrderModel> orders;
  final UserOrderModel? currentOrder;
  final Map<String, dynamic>? ordersSummary;
  final String? error;
  final bool isSuccess;

  OrderRiverpodState({
    required this.state,
    this.orders = const [],
    this.currentOrder,
    this.ordersSummary,
    this.error,
    this.isSuccess = false,
  });

  factory OrderRiverpodState.initial() {
    return OrderRiverpodState(
      state: OrderState.initial,
      orders: [],
      currentOrder: null,
      ordersSummary: null,
      error: null,
      isSuccess: false,
    );
  }

  OrderRiverpodState copyWith({
    OrderState? state,
    List<UserOrderModel>? orders,
    UserOrderModel? currentOrder,
    Map<String, dynamic>? ordersSummary,
    String? error,
    bool? isSuccess,
  }) {
    return OrderRiverpodState(
      state: state ?? this.state,
      orders: orders ?? this.orders,
      currentOrder: currentOrder ?? this.currentOrder,
      ordersSummary: ordersSummary ?? this.ordersSummary,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  bool operator ==(covariant OrderRiverpodState other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        other.orders == orders &&
        other.currentOrder == currentOrder &&
        other.ordersSummary == ordersSummary &&
        other.error == error &&
        other.isSuccess == isSuccess;
  }

  @override
  int get hashCode {
    return state.hashCode ^
        orders.hashCode ^
        currentOrder.hashCode ^
        ordersSummary.hashCode ^
        error.hashCode ^
        isSuccess.hashCode;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../data_source/order_data_source.dart';
import '../models/user_order_model.dart';

final orderRepositoryProvider = Provider.autoDispose<OrderRepository>((ref) {
  return OrderRepository(dataSource: ref.watch(orderDataSourceProvider));
});

class OrderRepository {
  final OrderDataSource dataSource;

  OrderRepository({required this.dataSource});

  Future<Either<Failure, List<UserOrderModel>>> getAllOrders() async {
    return executeTryAndCatchForRepository(() async {
      final ordersData = await dataSource.getAllOrders();
      final orders =
          ordersData.map((data) => UserOrderModel.fromMap(data)).toList();
      return orders;
    });
  }

  Future<Either<Failure, List<UserOrderModel>>> getOrdersByState(
    String state,
  ) async {
    return executeTryAndCatchForRepository(() async {
      final ordersData = await dataSource.getOrdersByState(state);
      final orders =
          ordersData.map((data) => UserOrderModel.fromMap(data)).toList();
      return orders;
    });
  }

  Future<Either<Failure, UserOrderModel>> getOrderById(String orderId) async {
    return executeTryAndCatchForRepository(() async {
      final orderData = await dataSource.getOrderById(orderId);
      return UserOrderModel.fromMap(orderData);
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getOrdersSummary() async {
    return executeTryAndCatchForRepository(() async {
      return await dataSource.getOrdersSummary();
    });
  }

  Future<Either<Failure, List<UserOrderModel>>> getRecentOrders({
    int limit = 10,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final ordersData = await dataSource.getRecentOrders(limit: limit);
      final orders =
          ordersData.map((data) => UserOrderModel.fromMap(data)).toList();
      return orders;
    });
  }
}

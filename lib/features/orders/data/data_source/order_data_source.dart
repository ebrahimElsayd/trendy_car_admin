import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/try_and_catch.dart';

final supabaseClientProvider = Provider.autoDispose<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final orderDataSourceProvider = Provider.autoDispose<OrderDataSource>(
  (ref) => OrderDataSourceImpl(ref.watch(supabaseClientProvider)),
);

abstract interface class OrderDataSource {
  Future<List<Map<String, dynamic>>> getAllOrders();
  Future<List<Map<String, dynamic>>> getOrdersByState(String state);
  Future<Map<String, dynamic>> getOrderById(String orderId);
  Future<Map<String, dynamic>> getOrdersSummary();
  Future<List<Map<String, dynamic>>> getRecentOrders({int limit = 10});
}

class OrderDataSourceImpl implements OrderDataSource {
  final SupabaseClient supabaseClient;

  OrderDataSourceImpl(this.supabaseClient);

  @override
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('user_orders')
          .select('*')
          .order('order_created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getOrdersByState(String state) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('user_orders')
          .select('*')
          .eq('state', state)
          .order('order_created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    return executeTryAndCatchForDataLayer(() async {
      final response =
          await supabaseClient
              .from('user_orders')
              .select('*')
              .eq('order_id', orderId)
              .single();

      return response;
    });
  }

  @override
  Future<Map<String, dynamic>> getOrdersSummary() async {
    return executeTryAndCatchForDataLayer(() async {
      // Get total orders count
      final totalOrdersResponse = await supabaseClient
          .from('user_orders')
          .select('*');

      // Get active orders count
      final activeOrdersResponse = await supabaseClient
          .from('user_orders')
          .select('*')
          .eq('state', 'pending');

      // Get completed orders count
      final completedOrdersResponse = await supabaseClient
          .from('user_orders')
          .select('*')
          .eq('state', 'completed');

      // Get return orders count
      final returnOrdersResponse = await supabaseClient
          .from('user_orders')
          .select('*')
          .eq('state', 'returned');

      return {
        'total_orders': totalOrdersResponse.length,
        'active_orders': activeOrdersResponse.length,
        'completed_orders': completedOrdersResponse.length,
        'return_orders': returnOrdersResponse.length,
      };
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentOrders({int limit = 10}) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('user_orders')
          .select('*')
          .order('order_created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    });
  }
}

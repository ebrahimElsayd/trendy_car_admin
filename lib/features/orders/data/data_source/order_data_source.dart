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
      // Get all orders to count states dynamically
      final allOrdersResponse = await supabaseClient
          .from('user_orders')
          .select('state');

      // Count orders by state
      Map<String, int> stateCounts = {};
      for (var order in allOrdersResponse) {
        String state = order['state']?.toString().toLowerCase() ?? 'unknown';
        stateCounts[state] = (stateCounts[state] ?? 0) + 1;
      }

      // Map common state variations to our expected states
      int pendingCount = 0;
      int completedCount = 0;
      int cancelledCount = 0;

      for (var entry in stateCounts.entries) {
        String state = entry.key.toLowerCase();
        int count = entry.value;

        if (state.contains('pending') ||
            state.contains('waiting') ||
            state.contains('processing')) {
          pendingCount += count;
        } else if (state.contains('completed') ||
            state.contains('delivered') ||
            state.contains('finished') ||
            state.contains('done')) {
          completedCount += count;
        } else if (state.contains('cancelled') ||
            state.contains('canceled') ||
            state.contains('rejected')) {
          cancelledCount += count;
        }
      }

      return {
        'total_orders': allOrdersResponse.length,
        'pending_orders': pendingCount,
        'completed_orders': completedCount,
        'cancelled_orders': cancelledCount,
        'all_states': stateCounts, // Include this for debugging
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

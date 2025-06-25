import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/orders/presentation/riverpod/order_riverpod.dart';
import '../../features/orders/presentation/riverpod/order_state.dart';
import '../../features/orders/data/models/user_order_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int totalOrders = 0;
  int pendingCount = 0;
  int completedCount = 0;
  int cancelledCount = 0;
  List<UserOrderModel> recentOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay the provider call until after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOrderData();
    });
  }

  Future<void> fetchOrderData() async {
    setState(() {
      isLoading = true;
    });

    // Fetch orders summary
    await ref.read(orderControllerProvider.notifier).getOrdersSummary();

    // Fetch recent orders for the list
    await ref.read(orderControllerProvider.notifier).getRecentOrders(limit: 5);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to order state changes
    ref.listen<OrderRiverpodState>(orderControllerProvider, (previous, next) {
      if (next.ordersSummary != null) {
        // Debug: Print all states found in database
        if (next.ordersSummary!['all_states'] != null) {
          print(
            'DEBUG - All order states in database: ${next.ordersSummary!['all_states']}',
          );
        }

        setState(() {
          totalOrders = next.ordersSummary!['total_orders'] ?? 0;
          pendingCount = next.ordersSummary!['pending_orders'] ?? 0;
          completedCount = next.ordersSummary!['completed_orders'] ?? 0;
          cancelledCount = next.ordersSummary!['cancelled_orders'] ?? 0;
          isLoading = false;
        });

        print(
          'DEBUG - Counts: Total=$totalOrders, Pending=$pendingCount, Completed=$completedCount, Cancelled=$cancelledCount',
        );
      }

      if (next.orders.isNotEmpty) {
        setState(() {
          recentOrders = next.orders;
        });
      }
    });

    double pendingOrders = totalOrders == 0 ? 0 : pendingCount / totalOrders;
    double completedOrders =
        totalOrders == 0 ? 0 : completedCount / totalOrders;
    double cancelledOrders =
        totalOrders == 0 ? 0 : cancelledCount / totalOrders;

    return Scaffold(
      backgroundColor: Color(0xFFBDBDBD),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: fetchOrderData,
                    icon: Icon(Icons.refresh, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child:
                      isLoading
                          ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(50),
                              child: CircularProgressIndicator(),
                            ),
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: buildInfoCard(
                                      icon: Icons.pending,
                                      title: "Pending Orders",
                                      value: "$pendingCount",
                                      percentage:
                                          "${((pendingCount / (totalOrders == 0 ? 1 : totalOrders)) * 100).toInt()}%",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildInfoCard(
                                      icon: Icons.shopping_cart,
                                      title: "Total Orders",
                                      value: "$totalOrders",
                                      percentage: "100%",
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: buildInfoCard(
                                      icon: Icons.check_circle,
                                      title: "Completed",
                                      value: "$completedCount",
                                      percentage:
                                          "${((completedCount / (totalOrders == 0 ? 1 : totalOrders)) * 100).toInt()}%",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              buildOrderSummary(
                                pendingOrders,
                                completedOrders,
                                cancelledOrders,
                              ),
                              SizedBox(height: 16),
                              buildOrderList(),
                            ],
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String percentage,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16),
              Spacer(),
              Icon(Icons.more_vert, size: 16),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.arrow_upward, color: Colors.green, size: 14),
              SizedBox(width: 4),
              Text(
                "$percentage",
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
              SizedBox(width: 4),
              Text(
                "vs last month",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildOrderSummary(
    double pendingOrders,
    double completedOrders,
    double cancelledOrders,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Summary", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          buildProgress(
            "Pending Orders",
            pendingOrders,
            Colors.orange,
            pendingCount,
          ),
          buildProgress(
            "Completed Orders",
            completedOrders,
            Colors.green,
            completedCount,
          ),
          buildProgress(
            "Cancelled Orders",
            cancelledOrders,
            Colors.red,
            cancelledCount,
          ),
        ],
      ),
    );
  }

  Widget buildProgress(String title, double progress, Color color, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text("${(progress * 100).toInt()}%")],
          ),
          SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 4),
          Text(
            "$count/$totalOrders Orders",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget buildOrderList() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Orders", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (recentOrders.isEmpty)
            Center(
              child: Text(
                "No orders found",
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          else
            ...recentOrders
                .map(
                  (order) => buildOrderRow(
                    _formatDate(order.orderCreatedAt),
                    order.itemName,
                    "Order",
                    order.orderId,
                    "${order.address}, ${order.region}",
                    _capitalizeFirst(order.orderState),
                    _getStatusColor(order.orderState),
                  ),
                )
                .toList(),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildOrderRow(
    String date,
    String title,
    String category,
    String orderId,
    String location,
    String status,
    Color statusColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                orderId,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                category,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(location, style: TextStyle(fontSize: 12)),
              Container(
                margin: EdgeInsets.only(top: 4),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

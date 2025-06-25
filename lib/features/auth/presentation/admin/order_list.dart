import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tendy_cart_admin/features/orders/presentation/riverpod/order_riverpod.dart';
import 'package:tendy_cart_admin/features/orders/presentation/riverpod/order_state.dart';
import 'package:tendy_cart_admin/features/orders/data/models/user_order_model.dart';

class OrdersListScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends ConsumerState<OrdersListScreen> {
  List<UserOrderModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay the provider call until after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOrders();
    });
  }

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
    });

    // Fetch all orders
    await ref.read(orderControllerProvider.notifier).getAllOrders();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[100]!;
      case 'completed':
      case 'delivered':
        return Colors.green[100]!;
      case 'cancelled':
      case 'canceled':
        return Colors.red[100]!;
      default:
        return Colors.grey[300]!;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    String ordinal(int number) {
      if (number >= 11 && number <= 13) return 'th';
      switch (number % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    return '${months[date.month - 1]} ${date.day}${ordinal(date.day)}, ${date.year}';
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to order state changes
    ref.listen<OrderRiverpodState>(orderControllerProvider, (previous, next) {
      if (next.orders.isNotEmpty) {
        setState(() {
          orders = next.orders;
          isLoading = false;
        });
      }

      if (next.state == OrderState.error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? 'Error loading orders')),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Orders List',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: fetchOrders,
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orders.isEmpty
              ? const Center(
                child: Text(
                  'No orders found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 16.w,
                    columns: const [
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Order ID')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Customer Name')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('')),
                    ],
                    rows:
                        orders.map((order) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  order.itemName.isNotEmpty
                                      ? order.itemName
                                      : 'N/A',
                                ),
                              ),
                              DataCell(
                                Text(
                                  order.orderId.isNotEmpty
                                      ? order.orderId
                                      : 'N/A',
                                ),
                              ),
                              DataCell(Text(_formatDate(order.orderCreatedAt))),
                              DataCell(
                                Text(
                                  order.userName.isNotEmpty
                                      ? order.userName
                                      : 'N/A',
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order.orderState),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _capitalizeFirst(order.orderState),
                                  ),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  child: const Text("View"),
                                  onPressed: () {
                                    // Note: OrdersDetailsScreen might need to be updated to accept UserOrderModel
                                    // For now, we'll just show a snackbar or you can update the details screen
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Order ID: ${order.orderId}',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
    );
  }
}

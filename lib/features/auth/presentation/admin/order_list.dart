import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/order_details.dart';

class OrderModel {
  final String orderId;
  final String date;
  final String customerName;
  final String productName;
  final String status;
  bool isSelected;

  OrderModel({
    required this.orderId,
    required this.date,
    required this.customerName,
    required this.productName,
    this.status = 'Pending',
    this.isSelected = false,
  });
}

class OrdersListScreen extends StatefulWidget {
  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  List<OrderModel> orders = [
    OrderModel(
      orderId: '#25424',
      date: 'Sep 6th,2024',
      customerName: 'Esraa',
      productName: 'Item name',
      status: 'Pending',
    ),
    OrderModel(
      orderId: '#25344',
      date: 'Sep 5th,2024',
      customerName: 'Osama',
      productName: 'Item name',
      status: 'Delivered',
    ),
    OrderModel(
      orderId: '#29874',
      date: 'Sep 3th,2024',
      customerName: 'Ahmed',
      productName: 'Item name',
      status: 'Cancelled',
    ),
    OrderModel(
      orderId: '#25424',
      date: 'Sep 6th,2024',
      customerName: 'Esraa',
      productName: 'Item name',
      status: 'Pending',
    ),
    OrderModel(
      orderId: '#25344',
      date: 'Sep 5th,2024',
      customerName: 'Osama',
      productName: 'Item name',
      status: 'Delivered',
    ),
    OrderModel(
      orderId: '#29874',
      date: 'Sep 3th,2024',
      customerName: 'Ahmed',
      productName: 'Item name',
      status: 'Cancelled',
    ),
    OrderModel(
      orderId: '#25424',
      date: 'Sep 6th,2024',
      customerName: 'Esraa',
      productName: 'Item name',
      status: 'Pending',
    ),
    OrderModel(
      orderId: '#25344',
      date: 'Sep 5th,2024',
      customerName: 'Osama',
      productName: 'Item name',
      status: 'Delivered',
    ),
    OrderModel(
      orderId: '#29874',
      date: 'Sep 3th,2024',
      customerName: 'Ahmed',
      productName: 'Item name',
      status: 'Cancelled',
    ),
    OrderModel(
      orderId: '#25424',
      date: 'Sep 6th,2024',
      customerName: 'Esraa',
      productName: 'Item name',
      status: 'Pending',
    ),
    OrderModel(
      orderId: '#25344',
      date: 'Sep 5th,2024',
      customerName: 'Osama',
      productName: 'Item name',
      status: 'Delivered',
    ),
    OrderModel(
      orderId: '#29874',
      date: 'Sep 3th,2024',
      customerName: 'Ahmed',
      productName: 'Item name',
      status: 'Cancelled',
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange[100]!;
      case 'Delivered':
        return Colors.green[100]!;
      case 'Cancelled':
        return Colors.red[100]!;
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Orders List',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
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
                    selected: order.isSelected,
                    onSelectChanged: (value) {
                      setState(() {
                        order.isSelected = value ?? false;
                      });
                    },
                    cells: [
                      DataCell(Text(order.productName)),
                      DataCell(Text(order.orderId)),
                      DataCell(Text(order.date)),
                      DataCell(Text(order.customerName)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(order.status),
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          child: Text("View"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        OrdersDetailsScreen(order: order),
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

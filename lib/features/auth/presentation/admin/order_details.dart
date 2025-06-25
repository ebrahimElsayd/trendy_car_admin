import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tendy_cart_admin/features/orders/data/models/user_order_model.dart';

class OrdersDetailsScreen extends StatelessWidget {
  final UserOrderModel order;

  OrdersDetailsScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Orders Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 1.sw,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Orders ID: ${order.orderId}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(order.orderState),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.calendar_today, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.yMMMd().format(order.orderCreatedAt),
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          style: ButtonStyle(
                            iconSize: WidgetStatePropertyAll(10),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Change Status',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          child: Icon(Icons.print),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(onPressed: () {}, child: Text('Save')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    'Full Name: ${order.userName}\nEmail: esraa@gmail.com\nPhone: 01068704149',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text('View profile'),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.local_shipping),
                  title: Text(
                    'Shipping: Next express\nPayment Method: Mastercard\nStatus: ${order.orderState}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text('Download Info'),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Address: Alashraf street, Tanta, Gharbia'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text('View profile'),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.payment),
                  title: Text(
                    'Master Card **** **** 6557\nBusiness name: ${order.userName}\nPhone: 01068704149',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Products',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Order ID')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Total')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('Airpods Pro')),
                        DataCell(Text('#27670')),
                        DataCell(Text('2')),
                        DataCell(Text('\$800')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Bose Headphone')),
                        DataCell(Text('#26524')),
                        DataCell(Text('1')),
                        DataCell(Text('\$200')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

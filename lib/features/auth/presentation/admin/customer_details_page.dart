import 'package:flutter/material.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/customer_management_screen.dart';

import '../../../user/data/model/user_model_test.dart';

class CustomerDetailsPage extends StatelessWidget {
  final userModelTest customer;

  const CustomerDetailsPage({required this.customer, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Customer Details"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    customer.name.isNotEmpty
                        ? customer.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 24,
                    ),
                  ),
                  radius: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  customer.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.credit_card),
                        Text(
                          "Customer ID\n${customer.id}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.email),
                        Text(
                          "E-mail\n${customer.email}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const Icon(Icons.location_on),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _statCard(Icons.history, "Total Orders", "25,00"),
          Row(
            children: [
              Expanded(child: _statCard(Icons.list_alt, "All Orders", "10")),
              Expanded(child: _statCard(Icons.timelapse, "Pending", "2")),
              Expanded(child: _statCard(Icons.check_circle, "Completed", "8")),
            ],
          ),
          Row(
            children: [
              Expanded(child: _statCard(Icons.cancel, "Cancelled", "0")),
              Expanded(child: _statCard(Icons.reply, "Returned", "0")),
              Expanded(child: _statCard(Icons.warning, "Damaged", "0")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

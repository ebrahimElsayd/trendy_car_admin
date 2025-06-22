import 'package:flutter/material.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/customer_details_page.dart';

class Customer {
  final String name;
  final String email;
  final String status; // "Active", "Blocked"
  final int orders;
  final String balance;
  final String id;
  final String avatarPath;

  Customer({
    required this.name,
    required this.email,
    required this.status,
    required this.orders,
    required this.balance,
    required this.id,
    required this.avatarPath,
  });
}

class CustomerManagementPage extends StatelessWidget {
  final List<Customer> customers = [
    Customer(
      name: "Osama Ahmed",
      email: "osama@mail.com",
      status: "Active",
      orders: 191,
      balance: "\$12,091",
      id: "ID-011220",
      avatarPath: "assets/avatars/avatar1.png",
    ),
    Customer(
      name: "Esraa Abdo",
      email: "esraaabd@mail.com",
      status: "Active",
      orders: 501,
      balance: "\$15,091",
      id: "ID-011221",
      avatarPath: "assets/avatars/avatar2.png",
    ),
    // Add more customers...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Customer",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search order...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B57F4),
                  ),
                  child: const Text("+ Add Customer"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _filterChip("All", true),
                _filterChip("Active", false),
                _filterChip("Blocked", false),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children:
                    customers.map((c) => _customerCard(context, c)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Colors.blue[50],
      ),
    );
  }

  Widget _customerCard(BuildContext context, Customer customer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerDetailsPage(customer: customer),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(customer.avatarPath),
                radius: 28,
              ),
              const SizedBox(height: 8),
              Text(
                customer.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      customer.status == "Active"
                          ? Colors.blue[50]
                          : Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  customer.status,
                  style: TextStyle(
                    color:
                        customer.status == "Active" ? Colors.blue : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text("Orders: ${customer.orders}"),
              Text("Balance: ${customer.balance}"),
            ],
          ),
        ),
      ),
    );
  }
}

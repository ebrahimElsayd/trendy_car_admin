import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tendy_cart_admin/features/user/presentation/riverpods/user_riverpod.dart';
import 'package:tendy_cart_admin/features/user/presentation/riverpods/user_state.dart';
import 'package:tendy_cart_admin/features/user/data/model/user_model_test.dart';

class CustomerManagementPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<CustomerManagementPage> createState() =>
      _CustomerManagementPageState();
}

class _CustomerManagementPageState
    extends ConsumerState<CustomerManagementPage> {
  List<userModelTest> customers = [];
  bool isLoading = true;
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    // Delay the provider call until after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUsers();
    });
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    await ref.read(userProvider.notifier).getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to user state changes
    ref.listen<UserRiverpodState>(userProvider, (previous, next) {
      if (next.users.isNotEmpty) {
        setState(() {
          customers = next.users;
          isLoading = false;
        });
      }

      if (next.state == userState.error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Error loading users')),
        );
      }
    });

    // Filter customers based on selected filter
    List<userModelTest> filteredCustomers = customers;
    if (selectedFilter == "Active") {
      filteredCustomers = customers.where((c) => c.state != 1).toList();
    } else if (selectedFilter == "Blocked") {
      filteredCustomers = customers.where((c) => c.state == 9).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Customer",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: fetchUsers,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search customer...",
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
                _filterChip("All", selectedFilter == "All"),
                _filterChip("Active", selectedFilter == "Active"),
                _filterChip("Blocked", selectedFilter == "Blocked"),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredCustomers.isEmpty
                      ? const Center(
                        child: Text(
                          'No customers found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio:
                            0.85, // Better ratio to prevent overflow
                        children:
                            filteredCustomers
                                .map((c) => _customerCard(context, c))
                                .toList(),
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
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              selectedFilter = label;
            });
          }
        },
      ),
    );
  }

  Widget _customerCard(BuildContext context, userModelTest customer) {
    String status =
        customer.state == 1
            ? "Active"
            : (customer.state == 9 ? "Blocked" : "Active");

    return GestureDetector(
      onTap: () {
        // Note: CustomerDetailsPage might need to be updated to accept userModelTest
        // For now, we'll just show a snackbar
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Customer: ${customer.name}')));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    fontSize: 16,
                  ),
                ),
                radius: 22,
              ),
              Flexible(
                child: Text(
                  customer.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: status == "Active" ? Colors.blue[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == "Active" ? Colors.blue : Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "ID: ${customer.id}",
                      style: const TextStyle(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      customer.email,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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

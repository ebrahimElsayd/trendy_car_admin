import 'package:flutter/material.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/all_productOfAdmin.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/customer_management_screen.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/dashboard.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/order_list.dart';

class HomeAdmin extends StatefulWidget {
  HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeState();
}

class _HomeState extends State<HomeAdmin> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[700],
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "All Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Order List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Customer Management",
          ),
        ],
      ),
    );
  }

  List<Widget> items = [
    DashboardScreenAdmin(),
    ProductListPageAdmin(),
    OrdersListScreen(),
    CustomerManagementPage(),
  ];
}

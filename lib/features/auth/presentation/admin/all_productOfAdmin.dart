import 'package:flutter/material.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/add_new_product_screen_admin.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/details_screen_of_product_admin.dart';

class ProductListPageAdmin extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: 'Apple 13" Macbook Pro',
      category: "electronics",
      summary: 'Rewarding Products',
      price: 2600.99,
      sales: 215,

      remaining: 122,
      imagePath: 'assets/images/cool boy.png',
      colors: ['#000000', '#CCCCCC', '#FF69B4'],
    ),
    Product(
      name: 'Apple 13" Macbook Pro',
      category: "electronics",
      summary: 'Rewarding Products',
      price: 2600.99,
      sales: 215,

      remaining: 122,
      imagePath: 'assets/images/cool boy.png',
      colors: ['#000000', '#CCCCCC', '#FF69B4'],
    ),
    Product(
      name: 'Apple 13" Macbook Pro',
      category: "electronics",
      summary: 'Rewarding Products',
      price: 2600.99,
      sales: 215,

      remaining: 122,
      imagePath: 'assets/images/cool boy.png',
      colors: ['#000000', '#CCCCCC', '#FF69B4'],
    ),
    Product(
      name: 'Apple 13" Macbook Pro',
      category: "electronics",
      summary:
          'Rewarding Productsuhggggggggggggggggggggggggggggggggggggggggggggggf',
      price: 2600.99,
      sales: 215,

      remaining: 122,
      imagePath: 'assets/images/cool boy.png',
      colors: ['#000000', '#CCCCCC', '#FF69B4'],
    ),
    Product(
      name: 'Apple 13" Macbook Pro',
      category: "electronics",
      summary: 'Rewarding Products',
      price: 2600.99,
      sales: 215,

      remaining: 122,
      imagePath: 'assets/images/cool boy.png',
      colors: ['#000000', '#CCCCCC', '#FF69B4'],
    ),
    Product(
      name: 'Apple 13" Macbook Pro',
      category: "electronics",
      summary: 'Rewarding Products',
      price: 2600.99,
      sales: 215,

      remaining: 122,
      imagePath: 'assets/images/cool boy.png',
      colors: ['#000000', '#CCCCCC', '#FF69B4'],
    ),
    Product(
      name: 'Apple 13" Macbook Pro',
      category: "electronics",
      summary: 'Rewarding Products',
      price: 2600.99,
      sales: 215,

      remaining: 122,
      imagePath: 'assets/images/cool boy.png',
      colors: ['#000000', '#CCCCCC', '#FF69B4'],
    ),
    Product(
      name: 'Apple 13" Macbook Pro',
      category: "electronics",
      summary: 'Rewarding Products',
      price: 2600.99,
      sales: 215,

      remaining: 122,
      imagePath: 'assets/images/product4.png',
      colors: ['#000000', '#CCCCCC', '#FF69B4'],
    ),

    // Add more if needed...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('All Products', style: TextStyle(color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductPage()),
                );
              },
              icon: Icon(Icons.add, color: Colors.white, size: 20),
              label: Text(
                "Add New Product",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 250,
            crossAxisSpacing: 2,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(product: product),
                  ),
                );
              },
              child: ProductCard(product: products[index]),
            );
          },
        ),
      ),
    );
  }
}

///////////////////

////////////
class ProductCard extends StatelessWidget {
  Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row (Image + name/category + more icon)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      product.imagePath,
                      height: 60,
                      width: 60,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.more_horiz),
                ],
              ),
              const SizedBox(height: 16),

              // Summary
              const Text(
                "Summary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(product.summary, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 5),

              // Sales and Remaining
              Expanded(
                child: Column(
                  children: [
                    // Sales
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          Text("Sales", style: TextStyle(color: Colors.black)),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_upward,
                            color: Colors.orange,
                            size: 18,
                          ),
                          Text(
                            product.sales.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(width: 5),

                    // Remaining
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          Text(
                            "Remaining Products",
                            style: TextStyle(color: Colors.black),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.horizontal_rule,
                            color: Colors.orange,
                            size: 18,
                          ),
                          Text(
                            product.remaining.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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

class SideDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'title': 'Electronics', 'count': 32},
    {'title': 'Lorem Ipsum', 'count': 18},
    {'title': 'Lorem Ipsum', 'count': 15},
    {'title': 'Lorem Ipsum', 'count': 10},
    {'title': 'Lorem Ipsum', 'count': 12},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: 60),
          Text(
            "ecommerce",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          DrawerItem(icon: Icons.dashboard, title: "Dashboard"),
          DrawerItem(icon: Icons.list, title: "All Products", selected: true),
          DrawerItem(icon: Icons.receipt, title: "Order List"),
          DrawerItem(icon: Icons.people, title: "Customer Management"),
          Divider(height: 40),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Categories",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ...categories.map(
            (cat) => ListTile(
              title: Text(cat['title']),
              trailing: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black,
                child: Text(
                  cat['count'].toString(),
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;

  const DrawerItem({
    required this.icon,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: Colors.black12,
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {},
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Product {
  final String name;
  final String category;
  final String summary;
  final double price;
  final int sales;
  final int remaining;
  final String imagePath;
  List<String> colors;

  Product({
    required this.name,
    required this.category,
    required this.summary,
    required this.price,
    required this.sales,
    required this.remaining,
    required this.imagePath,
    required this.colors,
  });
}

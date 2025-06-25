import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/add_new_product_screen_admin.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/details_screen_of_product_admin.dart';
import 'package:tendy_cart_admin/features/items/data/models/item_model.dart';
import 'package:tendy_cart_admin/features/items/presentation/riverpod/item_riverpod.dart';
import 'package:tendy_cart_admin/features/items/presentation/riverpod/item_state.dart';

class ProductListPageAdmin extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProductListPageAdmin> createState() =>
      _ProductListPageAdminState();
}

class _ProductListPageAdminState extends ConsumerState<ProductListPageAdmin> {
  @override
  void initState() {
    super.initState();
    // Load items when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(itemControllerProvider.notifier).getAllItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemState = ref.watch(itemControllerProvider);

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
        child: _buildBody(itemState),
      ),
    );
  }

  Widget _buildBody(ItemRiverpodState itemState) {
    switch (itemState.state) {
      case ItemState.loading:
        return const Center(child: CircularProgressIndicator());
      case ItemState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error loading products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                itemState.error ?? 'Unknown error occurred',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(itemControllerProvider.notifier).getAllItems();
                },
                child: Text('Retry'),
              ),
            ],
          ),
        );
      case ItemState.success:
        if (itemState.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No products found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Add your first product to get started',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.read(itemControllerProvider.notifier).getAllItems();
          },
          child: GridView.builder(
            itemCount: itemState.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 280,
              crossAxisSpacing: 2,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final item = itemState.items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(item: item),
                    ),
                  );
                },
                child: ProductCard(item: item),
              );
            },
          ),
        );
      default:
        return const Center(child: Text('Loading...'));
    }
  }
}

///////////////////

////////////
class ProductCard extends StatelessWidget {
  final ItemModel item;

  const ProductCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row (Image + name/category + more icon)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      item.imageUrl.isNotEmpty
                          ? Image.network(
                            item.imageUrl,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 60,
                                width: 60,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported),
                              );
                            },
                          )
                          : Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported),
                          ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Category ID: ${item.categoryId}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 8),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${item.retailPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.green,
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
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                item.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),

            // Wholesale Price and Stock Quantity
            Column(
              children: [
                // Wholesale Price
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      "Wholesale",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.attach_money,
                      color: Colors.blue,
                      size: 18,
                    ),
                    Text(
                      "\$${item.wholesalePrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Stock Quantity
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      "Stock",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    const Spacer(),
                    Icon(
                      item.quantity > 0 ? Icons.check_circle : Icons.warning,
                      color: item.quantity > 0 ? Colors.green : Colors.orange,
                      size: 18,
                    ),
                    Text(
                      item.quantity.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: item.quantity > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
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

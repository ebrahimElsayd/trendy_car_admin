import 'package:flutter/material.dart';
import 'package:tendy_cart_admin/features/items/data/models/item_model.dart';
import 'package:tendy_cart_admin/features/auth/presentation/admin/update_product_screen_admin.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ItemModel item;

  const ProductDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          children: [
            // Image area with back arrow and carousel
            Container(
              height: 250,
              child: Stack(
                children: [
                  Center(
                    child:
                        item.imageUrl.isNotEmpty
                            ? Image.network(
                              item.imageUrl,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: Colors.grey[600],
                                  ),
                                );
                              },
                            )
                            : Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image_not_supported,
                                size: 64,
                                color: Colors.grey[600],
                              ),
                            ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              ),
            ),

            // Page indicators (3 dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  width: index == 1 ? 10 : 6,
                  height: index == 1 ? 10 : 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 1 ? Colors.white : Colors.grey,
                  ),
                );
              }),
            ),

            // Product detail container
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),

                    // Category ID
                    const Text(
                      'Category ID',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      item.categoryId.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    // Retail Price
                    const Text(
                      'Retail Price',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${item.retailPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Wholesale Price
                    const Text(
                      'Wholesale Price',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${item.wholesalePrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Stock Quantity
                    const Text(
                      'Stock Quantity',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      item.quantity.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: item.quantity > 0 ? Colors.green : Colors.red,
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    contentPadding: const EdgeInsets.all(10),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,

                                      children: [
                                        const Text(
                                          "Are you sure \nyou want to delete this\n product",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // YES Button
                                            ElevatedButton(
                                              onPressed: () {
                                                // Perform delete logic here
                                                Navigator.of(
                                                  context,
                                                ).pop(); // Close dialog
                                                // Optionally show success Snackbar or go back
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text("YES"),
                                            ),

                                            // NO Button
                                            OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pop(); // Close dialog
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                  color: Colors.grey,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text("NO"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "DELETE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => const UpdateProductScreenAdmin(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,

                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "UPDATE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

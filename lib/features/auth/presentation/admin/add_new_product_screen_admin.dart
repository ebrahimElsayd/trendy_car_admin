import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:tendy_cart_admin/features/items/data/models/item_model.dart';
import 'package:tendy_cart_admin/features/items/presentation/riverpod/item_riverpod.dart';
import 'package:tendy_cart_admin/features/items/presentation/riverpod/item_state.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _retailPriceController = TextEditingController();
  final _wholesalePriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _imageUrlController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _handleAddProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        final item = ItemModel(
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          categoryId: int.parse(_categoryController.text.trim()),
          imageUrl: _imageUrlController.text.trim(),
          retailPrice: double.parse(_retailPriceController.text.trim()),
          wholesalePrice: double.parse(_wholesalePriceController.text.trim()),
          quantity: int.parse(_quantityController.text.trim()),
          createdAt: DateTime.now().toIso8601String(),
        );

        await ref.read(itemControllerProvider.notifier).createItem(item);

        // Listen to state changes
        ref.listen<ItemRiverpodState>(itemControllerProvider, (previous, next) {
          if (next.state == ItemState.success && next.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (next.state == ItemState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.error ?? 'Failed to add product'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _retailPriceController.dispose();
    _wholesalePriceController.dispose();
    _quantityController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Add New Product'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Product Gallery",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _pickImage,
                child: DottedBorder(
                  dashPattern: [8, 4],
                  color: Colors.grey,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child:
                        _selectedImage == null
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.image, size: 36, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  "Drop your image here, or browse",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  "Jpeg, png are allowed",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                            : Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Product Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Enter product name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: _inputDecoration("Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),
              const Text(
                "Category ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _categoryController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Enter category ID"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category ID';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),
              const Text(
                "Retail Price",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _retailPriceController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("\$10.40"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter retail price';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),
              const Text(
                "Wholesale Price",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _wholesalePriceController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("\$8.00"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter wholesale price';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),
              const Text(
                "Quantity",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Enter quantity"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),
              const Text(
                "Image URL",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _imageUrlController,
                decoration: _inputDecoration("Enter image URL"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),
              Consumer(
                builder: (context, ref, child) {
                  final itemState = ref.watch(itemControllerProvider);
                  final isLoading = itemState.state == ItemState.loading;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _actionButton(
                        isLoading ? "ADDING..." : "ADD",
                        Colors.green,
                        Colors.white,
                        isLoading ? null : () => _handleAddProduct(),
                      ),
                      const SizedBox(width: 20),
                      _actionButton("CANCEL", Colors.white, Colors.black, () {
                        Navigator.pop(context);
                      }, border: true),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _actionButton(
    String text,
    Color bg,
    Color fg,
    VoidCallback? onPressed, {
    bool border = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side:
              border ? const BorderSide(color: Colors.black) : BorderSide.none,
        ),
        elevation: 0,
      ),
      child: Text(text),
    );
  }
}

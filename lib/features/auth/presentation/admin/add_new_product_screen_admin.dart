import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(''),
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
                decoration: _inputDecoration("enter product name"),
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
              ),

              const SizedBox(height: 18),
              const Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _categoryController,
                decoration: _inputDecoration("category"),
              ),

              const SizedBox(height: 18),
              const Text(
                "Regular Price",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("\$10.40"),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _actionButton("ADD", Colors.green, Colors.white, () {
                    // ADD logic
                  }),
                  const SizedBox(width: 20),
                  _actionButton("CANCEL", Colors.white, Colors.black, () {
                    Navigator.pop(context);
                  }, border: true),
                ],
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
    VoidCallback onPressed, {
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

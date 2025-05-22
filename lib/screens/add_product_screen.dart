import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../models/product.dart';
import '../services/database_helper.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  const AddProductScreen({Key? key, this.product}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _imagePath = widget.product?.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<String?> _saveImage(String? tempImagePath, int? productId) async {
    if (tempImagePath == null) return null;
    final imagesDir = await _dbHelper.imagesDir;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final imageName = 'product_${productId ?? timestamp}_$timestamp.jpg';
    final newImagePath = path.join(imagesDir, imageName);
    final newImageFile = await File(tempImagePath).copy(newImagePath);
    return newImageFile.path;
  }

  Future<void> _saveProduct() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (name.isEmpty || description.isEmpty || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    final savedImagePath = await _saveImage(_imagePath, widget.product?.id);

    if (widget.product?.image != null && savedImagePath != null && savedImagePath != widget.product?.image) {
      final oldImage = File(widget.product!.image!);
      if (await oldImage.exists()) {
        await oldImage.delete();
      }
    }

    final product = Product(
      id: widget.product?.id,
      name: name,
      description: description,
      price: price,
      image: savedImagePath ?? _imagePath,
    );

    if (widget.product == null) {
      await _dbHelper.insertProduct(product.toMap());
    } else {
      await _dbHelper.updateProduct(product.toMap());
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: _imagePath != null
                  ? Image.file(
                File(_imagePath!),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 150),
              )
                  : Container(
                width: 150,
                height: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.add_a_photo, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
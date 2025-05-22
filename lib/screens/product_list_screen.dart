import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_helper.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _dbHelper.productsNotifier.addListener(_onProductsUpdated);
    _dbHelper.loadProducts();
  }

  @override
  void dispose() {
    _dbHelper.productsNotifier.removeListener(_onProductsUpdated);
    super.dispose();
  }

  void _onProductsUpdated() {
    setState(() {});
  }

  Future<bool> _confirmDelete() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _editProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductScreen(product: product)),
    ).then((_) => _dbHelper.loadProducts());
  }

  void _viewImageFullScreen(String? imagePath) {
    if (imagePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Image.file(File(imagePath), fit: BoxFit.contain)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ValueListenableBuilder<List<Product>>(
        valueListenable: _dbHelper.productsNotifier,
        builder: (context, products, _) {
          if (products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Dismissible(
                key: Key(product.id.toString()),
                direction: DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    _editProduct(product);
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return await _confirmDelete();
                  }
                  return false;
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    _dbHelper.deleteProduct(product.id!);
                  }
                },
                background: Container(
                  color: Colors.blue,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  onTap: () => _editProduct(product),
                  onLongPress: () => _viewImageFullScreen(product.image),
                  title: Text(product.name),
                  subtitle: Text('Price: \$${product.price.toStringAsFixed(2)}'),
                  leading: product.image != null
                      ? GestureDetector(
                    onTap: () => _viewImageFullScreen(product.image),
                    child: Image.file(
                      File(product.image!),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  )
                      : const Icon(Icons.image),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
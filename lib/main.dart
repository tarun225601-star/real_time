
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

// ---------------------------
// Model
// ---------------------------
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final bool outOfStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.outOfStock,
  });

  factory Product.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      outOfStock: data['outOfStock'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'description': description,
        'outOfStock': outOfStock,
      };
}

// ---------------------------
// Firestore Service
// ---------------------------
class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Products collection
  static Stream<List<Product>> productStream() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromDoc(doc)).toList());
  }

  static Future<void> addProduct(Product product) async {
    await _db.collection('products').add(product.toMap());
  }

  static Future<void> updateProduct(Product product) async {
    await _db.collection('products').doc(product.id).update(product.toMap());
  }

  static Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }

  // Shop status (single document)
  static DocumentReference get _shopStatusRef =>
      _db.collection('settings').doc('shopStatus');

  static Stream<bool> shopStatusStream() {
    return _shopStatusRef.snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      return data?['isOpen'] ?? true;
    });
  }

  static Future<void> setShopOpen(bool isOpen) async {
    await _shopStatusRef.set({'isOpen': isOpen}, SetOptions(merge: true));
  }
}

// ---------------------------
// Main
// ---------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MarketplaceApp());
}

// ---------------------------
// Root Widget
// ---------------------------
class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiâRole Marketplace',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const RoleSwitcher(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---------------------------
// Role Switcher (Customer / Admin)
// ---------------------------
class RoleSwitcher extends StatefulWidget {
  const RoleSwitcher({Key? key}) : super(key: key);

  @override
  State<RoleSwitcher> createState() => _RoleSwitcherState();
}

class _RoleSwitcherState extends State<RoleSwitcher> {
  bool _isAdmin = false;

  Future<void> _promptAdminLogin() async {
    final TextEditingController _passCtrl = TextEditingController();
    final bool? success = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Admin Login'),
        content: TextField(
          controller: _passCtrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Enter admin password'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Simple hardâcoded password (change as needed)
              if (_passCtrl.text == 'admin123') {
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context, false);
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );

    if (success == true) {
      setState(() => _isAdmin = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdmin ? 'Shopkeeper Admin Panel' : 'Marketplace'),
        actions: [
          IconButton(
            icon: Icon(_isAdmin ? Icons.person : Icons.admin_panel_settings),
            tooltip: _isAdmin ? 'Customer View' : 'Admin Login',
            onPressed: () {
              if (_isAdmin) {
                setState(() => _isAdmin = false);
              } else {
                _promptAdminLogin();
              }
            },
          ),
        ],
      ),
      body: _isAdmin ? const AdminPanel() : const CustomerView(),
    );
  }
}

// ---------------------------
// Customer View
// ---------------------------
class CustomerView extends StatefulWidget {
  const CustomerView({Key? key}) : super(key: key);

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  // Map of productId -> quantity selected
  final Map<String, int> _cart = {};

  // WhatsApp number (include country code, e.g., 91 for India)
  static const String _whatsappNumber = '919876543210';

  void _addToCart(String productId) {
    setState(() {
      _cart.update(productId, (qty) => qty + 1, ifAbsent: () => 1);
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      final qty = _cart[productId] ?? 0;
      if (qty <= 1) {
        _cart.remove(productId);
      } else {
        _cart[productId] = qty - 1;
      }
    });
  }

  Future<void> _checkout(List<Product> products) async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }

    double total = 0;
    final StringBuffer orderMsg = StringBuffer('New Order:\n');
    _cart.forEach((productId, qty) {
      final prod = products.firstWhere((p) => p.id == productId);
      total += prod.price * qty;
      orderMsg.writeln('- ${prod.name} (Qty: $qty) - â¹${(prod.price * qty).toStringAsFixed(2)}');
    });
    orderMsg.writeln('Total: â¹${total.toStringAsFixed(2)}');

    final Uri whatsappUri = Uri.parse(
        'https://wa.me/$_whatsappNumber?text=${Uri.encodeComponent(orderMsg.toString())}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: FirestoreService.shopStatusStream(),
        builder: (context, shopSnap) {
          final bool isOpen = shopSnap.data ?? true;
          return Column(
            children: [
              if (!isOpen)
                Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Shop is currently CLOSED',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: FirestoreService.productStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading products'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final p = products[index];
                        final inCartQty = _cart[p.id] ?? 0;
                        return Card(
                          margin:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: p.imageUrl.isNotEmpty
                                ? Image.network(p.imageUrl,
                                    width: 60, height: 60, fit: BoxFit.cover)
                                : const Icon(Icons.image_not_supported),
                            title: Text(p.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.description),
                                const SizedBox(height: 4),
                                Text('â¹${p.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                if (p.outOfStock)
                                  const Text('Out of Stock',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                              ],
                            ),
                            trailing: p.outOfStock
                                ? null
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.add_shopping_cart),
                                        onPressed: () => _addToCart(p.id),
                                      ),
                                      if (inCartQty > 0)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () => _removeFromCart(p.id),
                                            ),
                                            Text('$inCartQty'),
                                          ],
                                        ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  label: const Text('Checkout via WhatsApp'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: isOpen
                      ? () async {
                          final products = await FirestoreService.productStream()
                              .first;
                          await _checkout(products);
                        }
                      : null,
                ),
              ),
            ],
          );
        });
  }
}

// ---------------------------
// Admin Panel
// ---------------------------
class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  // Controllers for Add Product form
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  Future<void> _showAddProductDialog() async {
    _nameCtrl.clear();
    _priceCtrl.clear();
    _imageCtrl.clear();
    _descCtrl.clear();

    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Add New Product'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _priceCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Price'),
                    ),
                    TextField(
                      controller: _imageCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Image URL (optional)'),
                    ),
                    TextField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () async {
                      final name = _nameCtrl.text.trim();
                      final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;
                      if (name.isEmpty || price <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Name and valid price required')));
                        return;
                      }
                      final product = Product(
                        id: '',
                        name: name,
                        price: price,
                        imageUrl: _imageCtrl.text.trim(),
                        description: _descCtrl.text.trim(),
                        outOfStock: false,
                      );
                      await FirestoreService.addProduct(product);
                      Navigator.pop(context);
                    },
                    child: const Text('Add')),
              ],
            ));
  }

  Future<void> _toggleShopStatus(bool current) async {
    await FirestoreService.setShopOpen(!current);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: FirestoreService.shopStatusStream(),
        builder: (context, shopSnap) {
          final bool isOpen = shopSnap.data ?? true;
          return Column(
            children: [
              SwitchListTile(
                title: const Text('Shop Status'),
                subtitle: Text(isOpen ? 'OPEN' : 'CLOSED'),
                value: isOpen,
                onChanged: (_) => _toggleShopStatus(isOpen),
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
              ),
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: FirestoreService.productStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading products'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final p = products[index];
                        return Card(
                          margin:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: p.imageUrl.isNotEmpty
                                ? Image.network(p.imageUrl,
                                    width: 60, height: 60, fit: BoxFit.cover)
                                : const Icon(Icons.image_not_supported),
                            title: Text(p.name),
                            subtitle: Text('â¹${p.price.toStringAsFixed(2)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: !p.outOfStock,
                                  onChanged: (val) async {
                                    final updated = Product(
                                      id: p.id,
                                      name: p.name,
                                      price: p.price,
                                      imageUrl: p.imageUrl,
                                      description: p.description,
                                      outOfStock: !val,
                                    );
                                    await FirestoreService.updateProduct(updated);
                                  },
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.grey,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text('Delete Product'),
                                              content: Text(
                                                  'Are you sure you want to delete "${p.name}"?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, false),
                                                    child: const Text('Cancel')),
                                                ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, true),
                                                    child: const Text('Delete')),
                                              ],
                                            ));
                                    if (confirm == true) {
                                      await FirestoreService.deleteProduct(p.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(

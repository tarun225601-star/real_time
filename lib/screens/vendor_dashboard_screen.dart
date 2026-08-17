import 'package:flutter/material.dart';
import 'package:real_time/models/vendor_model.dart';
import 'package:real_time/services/firebase_service.dart';
import 'package:real_time/services/shared_preferences_service.dart';
import 'package:real_time/widgets/vendor_order_card.dart';
import 'package:real_time/widgets/vendor_product_card.dart';

class VendorDashboardScreen extends StatefulWidget {
  final VendorModel vendor;

  const VendorDashboardScreen({Key? key, required this.vendor}) : super(key: key);

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Save API Keys'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'API Key',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _sharedPreferencesService.saveApiKey(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'API Secret',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _sharedPreferencesService.saveApiSecret(value);
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Save'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Orders'),
                Tab(text: 'Products'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder(
                    stream: _firebaseService.getOrders(widget.vendor.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return VendorOrderCard(
                              order: snapshot.data!.docs[index],
                              vendor: widget.vendor,
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: _firebaseService.getProducts(widget.vendor.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return VendorProductCard(
                              product: snapshot.data!.docs[index],
                              vendor: widget.vendor,
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
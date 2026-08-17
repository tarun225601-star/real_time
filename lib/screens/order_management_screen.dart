import 'package:real_time/models/order_model.dart';
import 'package:real_time/models/vendor_model.dart';
import 'package:real_time/services/firestore_service.dart';
import 'package:real_time/services/shared_preferences_service.dart';
import 'package:real_time/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  @override
  Widget build(BuildContext context) {
    final VendorModel vendor = Provider.of<VendorModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestoreService.getOrdersByVendor(vendor.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrderModel> orders = snapshot.data;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: orders[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        final _apiKeyController = TextEditingController();
        final _apiSecretController = TextEditingController();

        return AlertDialog(
          title: Text('Settings'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _apiKeyController,
                  decoration: InputDecoration(
                    labelText: 'API Key',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter API key';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apiSecretController,
                  decoration: InputDecoration(
                    labelText: 'API Secret',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter API secret';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _sharedPreferencesService.saveApiKeys(_apiKeyController.text, _apiSecretController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
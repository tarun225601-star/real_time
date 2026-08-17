import 'package:flutter/material.dart';
import 'package:real_time/models/product_model.dart';
import 'package:real_time/services/api_service.dart';
import 'package:real_time/services/shared_preferences_service.dart';
import 'package:real_time/widgets/categories_grid.dart';
import 'package:real_time/widgets/instant_delivery_banner.dart';
import 'package:real_time/widgets/product_search.dart';
import 'package:real_time/widgets/shopping_cart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Commerce'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Save API Keys'),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'API Key',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _sharedPreferencesService.saveApiKey(value);
                            },
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          InstantDeliveryBanner(),
          Expanded(
            child: Column(
              children: [
                CategoriesGrid(),
                ProductSearch(),
                Expanded(
                  child: FutureBuilder(
                    future: _apiService.getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ProductModel> products = snapshot.data;
                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(products[index].name),
                              subtitle: Text(products[index].description),
                              trailing: Text('\$${products[index].price}'),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ShoppingCart(),
    );
  }
}
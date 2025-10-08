import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // contoh dummy orders
    final orders = [
      {"id": "ORD001", "customer": "Budi", "total": 120000},
      {"id": "ORD002", "customer": "Siti", "total": 90000},
      {"id": "ORD003", "customer": "Andi", "total": 150000},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text("Order ID: ${order['id']}"),
            subtitle: Text("Customer: ${order['customer']}"),
            trailing: Text("Rp${order['total']}"),
          );
        },
      ),
    );
  }
}

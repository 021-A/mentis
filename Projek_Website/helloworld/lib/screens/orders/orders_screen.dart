// lib/screens/orders/orders_screen.dart
import 'package:flutter/material.dart';
import '../../utils/formatters.dart'; // ✨ NEW: Import formatters

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // contoh dummy orders - ✨ ENHANCED: Tambah date & status
    final orders = [
      {
        "id": "ORD001",
        "customer": "Budi Santoso",
        "total": 120000.0,
        "date": DateTime.now().subtract(const Duration(days: 2)),
        "status": "completed",
        "items": 3,
      },
      {
        "id": "ORD002",
        "customer": "Siti Nurhaliza",
        "total": 90000.0,
        "date": DateTime.now().subtract(const Duration(days: 5)),
        "status": "processing",
        "items": 2,
      },
      {
        "id": "ORD003",
        "customer": "Andi Wijaya",
        "total": 150000.0,
        "date": DateTime.now().subtract(const Duration(days: 1)),
        "status": "completed",
        "items": 5,
      },
      {
        "id": "ORD004",
        "customer": "Dewi Lestari",
        "total": 250000.0,
        "date": DateTime.now().subtract(const Duration(hours: 3)),
        "status": "pending",
        "items": 1,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders Management"),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        actions: [
          // ✨ NEW: Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Filter feature coming soon!")),
              );
            },
          ),
        ],
      ),
      body: orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No orders yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // ✨ NEW: Summary card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                        "Total Orders",
                        orders.length.toString(),
                        Icons.receipt_long,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      _buildSummaryItem(
                        "Total Revenue",
                        AppFormatters.formatCurrency(
                          orders.fold(0.0, (sum, order) => sum + (order['total'] as double)),
                        ),
                        Icons.attach_money,
                      ),
                    ],
                  ),
                ),

                // Orders list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showOrderDetail(context, order);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header: Order ID & Status
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.receipt_long,
                                            color: Color(0xFF0D9488),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order['id'] as String,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              AppFormatters.formatRelativeTime(
                                                order['date'] as DateTime,
                                              ),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // ✨ ENHANCED: Status badge with color
                                    _buildStatusBadge(order['status'] as String),
                                  ],
                                ),

                                const SizedBox(height: 12),
                                const Divider(height: 1),
                                const SizedBox(height: 12),

                                // Customer & Items
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        order['customer'] as String,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${order['items']} items",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Total Price - ✨ ENHANCED: Format dengan Rupiah
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total:",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      AppFormatters.formatCurrency(order['total'] as double),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0D9488),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // ✨ NEW: Summary item widget
  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ✨ NEW: Status badge with color coding
  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle;
        break;
      case 'processing':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        icon = Icons.hourglass_empty;
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        icon = Icons.pending;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            AppFormatters.capitalize(status),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ✨ NEW: Show order detail dialog
  void _showOrderDetail(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Order ${order['id']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Customer", order['customer'] as String),
            _buildDetailRow("Items", "${order['items']} items"),
            _buildDetailRow(
              "Total",
              AppFormatters.formatCurrency(order['total'] as double),
            ),
            _buildDetailRow(
              "Date",
              AppFormatters.formatDateTime(order['date'] as DateTime),
            ),
            _buildDetailRow("Status", AppFormatters.capitalize(order['status'] as String)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
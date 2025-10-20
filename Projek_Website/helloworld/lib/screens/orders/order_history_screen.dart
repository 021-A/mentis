// lib/screens/orders/order_history_screen.dart

import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import '../../models/order.dart';
import '../../utils/formatters.dart';
import '../../utils/image_helper.dart';

class OrderHistoryScreen extends StatefulWidget {
  static const routeName = '/order-history';

  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Order> _orders = [];
  bool _isLoading = false;
  String _filter = 'all'; // all, processing, completed, refunded, failed

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    await CartService.loadOrders();
    if (!mounted) return;
    setState(() {
      _orders = CartService.getOrders();
      _isLoading = false;
    });
  }

  List<Order> get _filteredOrders {
    if (_filter == 'all') return _orders;
    return _orders.where((o) => o.status.toString().split('.').last == _filter).toList();
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.failed:
        return Colors.red;
      case OrderStatus.refunded:
        return Colors.purple;
    }
  }

  String _statusLabel(OrderStatus status) => status.toString().split('.').last.toUpperCase();

  Future<void> _changeStatus(Order order, OrderStatus newStatus) async {
    // 1) Update status (async)
    final ok = await CartService.updateOrderStatus(order.id, newStatus);
    
    // 2) Segera cek mounted setelah await agar tidak menggunakan context jika widget sudah di-unmount
    if (!mounted) return;

    if (ok) {
      // 3) Reload orders (async) — cek mounted lagi setelah await
      await CartService.loadOrders();
      if (!mounted) return;

      // 4) Safe to update UI and use context
      setState(() => _orders = CartService.getOrders());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ${order.id} -> ${newStatus.toString().split('.').last}'),
        ),
     );
    } else {
      // ok == false, tidak ada await tambahan, tetapi kita tetap cek mounted sebelum menggunakan context
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void _showOrderDetail(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: controller,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _statusColor(order.status).withAlpha(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: order.product.imageUrl != null && order.product.imageUrl!.isNotEmpty
                          ? ImageHelper.getImageWidget(order.product.imageUrl!, width: 56, height: 56, fit: BoxFit.cover)
                          : Icon(Icons.inventory, color: _statusColor(order.status)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.product.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(order.product.category, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(_statusLabel(order.status)),
                    backgroundColor: _statusColor(order.status).withValues(alpha: 0.12),
                    labelStyle: TextStyle(color: _statusColor(order.status)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Order ID', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              SelectableText(order.id),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 6),
                      Text(AppFormatters.formatCurrency(order.amount), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Created', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 6),
                      Text('${order.createdAt.toLocal()}'.split('.').first, style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (order.licenseKey != null && order.licenseKey!.isNotEmpty) ...[
                Text('License Key', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 6),
                SelectableText(order.licenseKey!),
                SizedBox(height: 12),
              ],
              Text('Customer', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              Text('${order.customerName} • ${order.customerEmail}'),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: order.status == OrderStatus.completed
                          ? null
                          : () => _changeStatus(order, OrderStatus.completed),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0D9488)),
                      child: Text('Mark as Completed'),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: order.status == OrderStatus.refunded
                        ? null
                        : () => _changeStatus(order, OrderStatus.refunded),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    child: Icon(Icons.undo),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final statusColor = _statusColor(order.status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showOrderDetail(order),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // image
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: statusColor.withAlpha(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: order.product.imageUrl != null && order.product.imageUrl!.isNotEmpty
                      ? ImageHelper.getImageWidget(order.product.imageUrl!, width: 64, height: 64, fit: BoxFit.cover)
                      : Icon(Icons.inventory, color: statusColor),
                ),
              ),

              const SizedBox(width: 12),

              // info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.product.title, style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text(order.product.category, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(AppFormatters.formatCurrency(order.amount), style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
                        SizedBox(width: 8),
                        Text('• ${order.createdAt.toLocal().toString().split('.').first}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              // status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Chip(
                    label: Text(_statusLabel(order.status)),
                    backgroundColor: statusColor.withValues(alpha: 0.12),
                    labelStyle: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  IconButton(
                    onPressed: () => _showOrderDetail(order),
                    icon: Icon(Icons.chevron_right),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final options = ['all', 'processing', 'completed', 'failed', 'refunded'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: options.map((opt) {
          final selected = _filter == opt;
          final color = selected ? Color(0xFF0D9488) : Colors.grey.shade300;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(opt.toUpperCase()),
              selected: selected,
              onSelected: (_) => setState(() => _filter = opt),
              selectedColor: Color(0xFF0D9488),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
              side: BorderSide(color: color),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Color(0xFF0D9488),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFF0D9488).withValues(alpha: 0.06),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_orders.length} total orders', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                  IconButton(
                    onPressed: _loadOrders,
                    icon: Icon(Icons.refresh),
                  )
                ],
              ),
            ),

            _buildFilterChips(),

            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredOrders.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.history, size: 80, color: Colors.grey[300]),
                                SizedBox(height: 16),
                                Text('No orders yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                SizedBox(height: 8),
                                Text('Your recent purchases will appear here.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
                                SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0D9488)),
                                  child: Text('Browse Products'),
                                )
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          itemCount: _filteredOrders.length,
                          itemBuilder: (ctx, i) => _buildOrderCard(_filteredOrders[i]),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:bar_code/barcode/item.dart';
import 'package:bar_code/screens/widgets/item_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class OrderRequest {
  final DateTime createdAt;
  final List<Item> items;

  OrderRequest({required this.createdAt, required this.items});

  Map<String, dynamic> toMap() => {
    'createdAt': createdAt.toIso8601String(),
    'items': items.map((item) => item.toMap()).toList(),
  };

  factory OrderRequest.fromMap(Map<String, dynamic> map) {
    return OrderRequest(
      createdAt: DateTime.parse(map['createdAt']),
      items: (map['items'] as List).map((e) => Item.fromMap(e)).toList(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<OrderRequest> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ordersJson = prefs.getString('orders');
    if (ordersJson != null) {
      final List decoded = jsonDecode(ordersJson);
      setState(() {
        orders = decoded.map((e) => OrderRequest.fromMap(e)).toList();
      });
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String ordersJson = jsonEncode(orders.map((e) => e.toMap()).toList());
    await prefs.setString('orders', ordersJson);
  }

  // Add or Edit an entire order (new or edit)
  Future<void> _addOrEditOrder({OrderRequest? order, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemForm(items: order?.items ?? []),
      ),
    );
    if (result != null && result is List<Item>) {
      setState(() {
        if (index != null) {
          orders[index] = OrderRequest(
            createdAt: order!.createdAt,
            items: result,
          );
        } else {
          orders.add(OrderRequest(
            createdAt: DateTime.now(),
            items: result,
          ));
        }
      });
      await _saveOrders();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(index != null
              ? 'تم تعديل الطلب بنجاح!'
              : 'تمت إضافة الطلب بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteOrder(int index) async {
    setState(() {
      orders.removeAt(index);
    });
    await _saveOrders();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف الطلب بنجاح!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _orderSummary(OrderRequest order, int index) {
    final itemCount = order.items.length;
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final orderNumber =
    firstItem != null ? firstItem.salesOrderNumber : '—';
    final itemName =
    firstItem != null ? firstItem.itemName : '—';
    final orderDate =
        "${order.createdAt.year}-${order.createdAt.month.toString().padLeft(2, '0')}-${order.createdAt.day.toString().padLeft(2, '0')}";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.qr_code, color: Colors.deepPurple),
        title: Text(
          itemName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text('عدد المنتجات: $itemCount   رقم أمر البيع: $orderNumber   التاريخ: $orderDate'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.amber),
              onPressed: () => _addOrEditOrder(order: order, index: index),
              tooltip: 'تعديل الطلب',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteOrder(index),
              tooltip: 'حذف الطلب',
            ),
          ],
        ),
        onTap: () => _showOrderDetails(order), // Optional: expand or show order details
      ),
    );
  }

  void _showOrderDetails(OrderRequest order) {
    // Show all details in a dialog or another page if needed
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('تفاصيل الطلب'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: order.items.map((item) => ListTile(
                  title: Text(item.itemName),
                  subtitle: Text('كود: ${item.itemCode}\nكمية: ${item.requestedQuantity}'),
                )).toList(),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('إغلاق'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          title: const Text('الطلبات'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: orders.isEmpty
            ? const Center(child: Text('لا توجد طلبات بعد.'))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) =>
              _orderSummary(orders[index], index),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _addOrEditOrder(),
          icon: const Icon(Icons.add),
          label: const Text('إضافة طلب'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

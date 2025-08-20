import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loginsystem/screen/OrderReview.dart';
import 'dart:convert';

class ReceivingPage extends StatefulWidget {
  @override
  _ReceivingPageState createState() => _ReceivingPageState();
}

class _ReceivingPageState extends State<ReceivingPage> with SingleTickerProviderStateMixin {
  List<dynamic> completedOrders = [];
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
    fetchCompletedOrders(); // ใช้ API สำหรับดึงคำสั่งซื้อที่สถานะสำเร็จ
  }

  Future<void> fetchCompletedOrders() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to view your orders')),
      );
      return;
    }

    final email = user.email;

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/getCompletedOrdersByEmailRecipient?email=$email'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          completedOrders = data['orders'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : completedOrders.isEmpty
              ? Center(child: Text('ไม่มีคำสั่งซื้อสำเร็จ'))
              : ListView.builder(
                  itemCount: completedOrders.length,
                  itemBuilder: (context, index) {
                    final order = completedOrders[index];
                    return OrderCard(order: order);
                  },
                ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,##0.00", "th");
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    order['profile_picture'] ?? '',
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  order['ordered_by'] ?? 'Unknown',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                Text(
                  "คำสั่งซื้อสำเร็จ",
                  style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Image.network(
              order['product_image'] ?? 'https://via.placeholder.com/300',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              order['productName'] ?? 'No product name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("ตัวเลือก: ${order['product_option'] ?? 'ไม่มี'}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("x ${order['quantity']}"),
Text(
  "${formatter.format(double.tryParse(order['product_price']?.toString() ?? '0') ?? 0.00)}",
  style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("1 ชิ้น"),
Text(
  "รวมทั้งหมด: ฿${order['total'] != null ? formatter.format(double.tryParse(order['total'].toString()) ?? 0.00) : '0.00'}",
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "หมายเลขคำสั่งซื้อ: ${order['order_ref'] ?? '-'}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "เลขพัสดุ: ${order['trackingnumber'] ?? 'ยังไม่มีเลขพัสดุ'}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ), 

            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [



              ],
            ),
          ],
        ),
      ),
    );
  }
}

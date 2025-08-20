import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginsystem/screen/Addbank.dart';

class MyBankScreen extends StatefulWidget {
  const MyBankScreen({super.key});

  @override
  _MyBankScreenState createState() => _MyBankScreenState();
}

class _MyBankScreenState extends State<MyBankScreen> {
  List bankAccounts = [];
  String firebaseUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchBankAccounts();
  }

  // ✅ ดึงบัญชีธนาคาร
  Future<void> fetchBankAccounts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/bank-accounts/$firebaseUid'));
    if (response.statusCode == 200) {
      setState(() {
        bankAccounts = json.decode(response.body);
      });
    }
  }

  // ✅ ฟังก์ชันลบบัญชีธนาคาร
  Future<void> deleteBankAccount(int id) async {
    try {
      final response = await http.delete(Uri.parse('http://10.0.2.2:3000/bank-accounts/$id'));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบบัญชีธนาคารสำเร็จ!')),
        );
        fetchBankAccounts(); // รีโหลดข้อมูลใหม่
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการลบ')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  // ✅ แสดง Dialog ยืนยันการลบ
  void confirmDeleteBankAccount(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันการลบ"),
        content: const Text("คุณแน่ใจหรือไม่ว่าต้องการลบบัญชีธนาคารนี้?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteBankAccount(id);
            },
            child: const Text("ลบ", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("บัญชีธนาคารของฉัน")),
      body: ListView.builder(
        itemCount: bankAccounts.length,
        itemBuilder: (context, index) {
          final bank = bankAccounts[index];
          String bankLogoPath = 'assets/banks/${bank['bankname'].toLowerCase().replaceAll(" ", "")}.png';

          return Card(
            child: ListTile(
              leading: Image.asset(
                bankLogoPath,
                width: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.account_balance, size: 40, color: Colors.grey);
                },
              ),
              title: Text("${bank['bankname']} (${bank['fullname']})"),
              subtitle: Text("•••• ${bank['banknumber'].substring(bank['banknumber'].length - 4)}"),
              trailing: bank['is_default'] == 1
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text("ค่าเริ่มต้น"),
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => confirmDeleteBankAccount(bank['id']),
                    ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBankScreen()),
          );
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

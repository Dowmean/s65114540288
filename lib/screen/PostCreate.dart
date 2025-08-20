import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'PostService.dart';

class PostCreatePage extends StatefulWidget {
  @override
  _PostCreatePageState createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _shippingController = TextEditingController();
  final TextEditingController _carryController = TextEditingController();
  String? _selectedCategory;
  File? _selectedImageFile;

  List<DropdownMenuItem<String>> get _categoryItems {
    return [
      DropdownMenuItem(value: 'เสื้อผ้า', child: Text('เสื้อผ้า')),
      DropdownMenuItem(value: 'รองเท้า', child: Text('รองเท้า')),
      DropdownMenuItem(value: 'ความงาม', child: Text('ความงาม')),
      DropdownMenuItem(value: 'กระเป๋า', child: Text('กระเป๋า')),
    ];
  }

  // ✅ ฟังก์ชันบีบอัดรูปภาพ
  Future<Uint8List?> compressImage(File imageFile) async {
    final originalBytes = await imageFile.readAsBytes();
    final compressedBytes = await FlutterImageCompress.compressWithList(
      originalBytes,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );

    // ✅ เช็คขนาดไฟล์ก่อนส่ง
    if (compressedBytes != null && compressedBytes.length > 5 * 1024 * 1024) {
      print("⚠️ รูปภาพใหญ่เกิน 5MB หลังจากบีบอัด");
      return null;
    }
    return compressedBytes;
  }

  // ✅ ฟังก์ชันเลือกรูปภาพ
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File originalFile = File(pickedFile.path);
      final Uint8List? compressedBytes = await compressImage(originalFile);

      if (compressedBytes != null) {
        setState(() {
          _selectedImageFile = originalFile;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('รูปภาพใหญ่เกินไป กรุณาเลือกรูปใหม่')),
        );
      }
    }
  }

  // ✅ ฟังก์ชันส่งโพสต์
  Future<void> _submitPost() async {
    if (_selectedCategory == null ||
        _productNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _shippingController.text.isEmpty ||
        _carryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User not logged in');
        return;
      }
      final String firebaseUid = user.uid;

      String? base64Image;
      if (_selectedImageFile != null) {
        base64Image = base64Encode(await _selectedImageFile!.readAsBytes());

        // ✅ ป้องกันไม่ให้ส่งรูปใหญ่เกินไป
        if (base64Image.length > 5000000) {
          print("⚠️ Image file is too large after encoding");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ไฟล์รูปภาพใหญ่เกินไป กรุณาเลือกรูปใหม่')),
          );
          return;
        }
      }

      // ✅ ตรวจสอบการแปลงค่า `double`
      double? price = double.tryParse(_priceController.text);
      double? shipping = double.tryParse(_shippingController.text);
      double? carry = double.tryParse(_carryController.text);

      if (price == null || shipping == null || carry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กรุณากรอกค่าราคาที่ถูกต้อง')),
        );
        return;
      }

      await PostService().createPost(
        firebaseUid: firebaseUid,
        category: _selectedCategory!,
        productName: _productNameController.text,
        productDescription: _productDescriptionController.text,
        price: price,
        shipping: shipping,
        carry: carry,
        imageFile: base64Image,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('สร้างโพสต์สำเร็จ!')),
      );

      // ✅ หลังจากโพสต์เสร็จให้กลับไปยังหน้าก่อนหน้า
      Navigator.pop(context);

    } catch (e) {
      print('Error while creating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("สร้างโพสต์ใหม่"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ ส่วนอัปโหลดรูปภาพ
              if (_selectedImageFile != null)
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(_selectedImageFile!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 50),
                        SizedBox(height: 10),
                        Text("เพิ่มรูปภาพของคุณ", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),

              // ✅ อินพุตข้อมูล
              TextFormField(controller: _productNameController, decoration: InputDecoration(labelText: 'ชื่อสินค้า')),
              SizedBox(height: 20),
              TextFormField(controller: _productDescriptionController, decoration: InputDecoration(labelText: 'รายละเอียดสินค้า')),
              SizedBox(height: 20),
              TextFormField(controller: _priceController, decoration: InputDecoration(labelText: 'ราคา'), keyboardType: TextInputType.number),
              SizedBox(height: 20),
              TextFormField(controller: _shippingController, decoration: InputDecoration(labelText: 'ค่าขนส่ง'), keyboardType: TextInputType.number),
              SizedBox(height: 20),
              TextFormField(controller: _carryController, decoration: InputDecoration(labelText: 'ค่าบริการ'), keyboardType: TextInputType.number),
              SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categoryItems,
                hint: Text("เลือกหมวดหมู่"),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 20),

              // ✅ ปุ่มโพสต์
              ElevatedButton(
                onPressed: _submitPost,
                child: Text("โพสต์", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

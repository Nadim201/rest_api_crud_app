import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../widget.dart';

class addProduct extends StatefulWidget {
  const addProduct({super.key});

  @override
  State<addProduct> createState() => _addProductState();
}

class _addProductState extends State<addProduct> {
  bool inProgress = false;
  final _key = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController imgController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController createdDateController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    productNameController.dispose();
    productCodeController.dispose();
    imgController.dispose();
    unitPriceController.dispose();
    qtyController.dispose();
    totalPriceController.dispose();
    createdDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildForm(),
          ),
        ),
      ),
    );
  }

  void _clearTextFields() {
    imgController.clear();
    productCodeController.clear();
    productNameController.clear();
    qtyController.clear();
    totalPriceController.clear();
    unitPriceController.clear();
    createdDateController.clear();
  }

  Form buildForm() {
    return Form(
      key: _key,
      child: Column(
        children: [
          buildTextFormField(),
          SizedBox(
            width: double.infinity,
            child: inProgress
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _onTabAddProductButton,
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _onTabAddProductButton() {
    if (_key.currentState!.validate()) {
      addProductFetch();
    }
  }

  Future<void> addProductFetch() async {
    setState(() {
      inProgress = true;
    });
    Uri uri = Uri.parse('http://164.68.107.70:6060/api/v1/CreateProduct');
    Map<String, dynamic> requestBody = {
      "Img": imgController.text,
      "ProductCode": productCodeController.text,
      "ProductName": productNameController.text,
      "Qty": qtyController.text,
      "TotalPrice": totalPriceController.text,
      "UnitPrice": unitPriceController.text
    };

    Response response = await post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      _clearTextFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product add successfully'),
        ),
      );
    }
    setState(() {
      inProgress = false;
    });
  }

  Column buildTextFormField() {
    return Column(
      children: [
        TextFormFild(
          hintText: 'Product name',
          label: 'Name',
          controller: productNameController,
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormFild(
          hintText: 'Enter Your id',
          label: 'Id',
          controller: idController,
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormFild(
          hintText: 'Product Image',
          label: 'Image',
          controller: imgController,
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormFild(
          hintText: 'Enter product code',
          label: 'Code No',
          controller: productCodeController,
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormFild(
          hintText: 'Enter Price ',
          label: 'Price',
          controller: unitPriceController,
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormFild(
          hintText: 'Enter quantity',
          label: 'Quantity',
          controller: qtyController,
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormFild(
          hintText: 'Enter total price',
          label: 'Total Price',
          controller: totalPriceController,
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormFild(
          hintText: 'Enter date',
          label: 'Date',
          controller: createdDateController,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

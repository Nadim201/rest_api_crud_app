import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_crud_app/model/product.dart';

Future<void> getProductList(List<Product> items) async {
  const url = 'http://164.68.107.70:6060/api/v1/ReadProduct';
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  print(response.body);
  print(response.statusCode);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body) as Map;
    final data = json['data'] as List;

    items.clear();
    for (var productData in data) {
      Product product = Product(
        productName: productData['ProductName'] ?? '',
        productId: productData['_id'] ?? '',
        productCode: productData['ProductCode'] ?? '',
        productQuantity: productData['Qty'] ?? '',
        productPrice: productData['UnitPrice'] ?? '',
        productTotalPrice: productData['TotalPrice'] ?? '',
        creationDate: productData['CreatedDate'] ?? '',
        image: productData['Img'] ?? '',
      );
      items.add(product);
    }
  } else {
    print('Failed to load products. Status code: ${response.statusCode}');
  }
}
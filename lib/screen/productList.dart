import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_crud_app/apikey.dart';
import 'package:rest_api_crud_app/model/product.dart';
import 'package:rest_api_crud_app/screen/addProduct.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> items = [];
  bool isLoading = true;
  bool isEdit = true;

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  Future<void> fetchApi() async {
    await getProductList(items);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await fetchApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                fetchApi();
              },
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Colors.indigoAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => const addProduct(
                  product: null,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    color: Colors.grey.shade100,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildImageSection(item),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(width: 10),
                          buildProductDetails(item, context),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget buildProductDetails(Product item, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${item.productName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 5),
            Text('Id: ${item.productId}'),
            const SizedBox(height: 5),
            Text('Code: ${item.productCode}'),
            const SizedBox(height: 5),
            Text('Quantity: ${item.productQuantity}'),
            const SizedBox(height: 5),
            Text('Price: \$${item.productPrice}'),
            const SizedBox(height: 5),
            Text('Total: \$${item.productTotalPrice}'),
            const SizedBox(height: 5),
            Text('Date: ${item.creationDate}'),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 40),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => addProduct(
                      product: item,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.indigoAccent,
              ),
            ),
            const SizedBox(height: 50),
            IconButton(
              onPressed: () {
                setState(() {
                  deleteItem(item.productId);
                });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildImageSection(Product item) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(item.image, scale: 1),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> deleteItem(String id) async {
    final url = 'http://164.68.107.70:6060/api/v1/DeleteProduct/$id';

    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        fetchApi();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item deletion complete')));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item delete field'),
        ),
      );
    }
  }
}
//
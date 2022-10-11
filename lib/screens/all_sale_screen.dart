import 'package:flutter/material.dart';

import '../helpers/api.dart';
import '../models/product_group_model.dart';
import '../models/product_model.dart';
import '../models/sale_model.dart';

class AllSaleScreen extends StatefulWidget {
  const AllSaleScreen({Key? key}) : super(key: key);

  @override
  _AllSaleScreenState createState() => _AllSaleScreenState();
}

class _AllSaleScreenState extends State<AllSaleScreen> {
  var api = Api();
  List<SaleModel> _sales = [];
  List<ProductModel> _products = [];
  List<ProductGroupModel> _productGroups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tüm Satışlar"),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) {
          var item = _sales[i];
          return Card(
            child: ListTile(
              title: Text("${item.productName}x${item.amount}=${((item.priceRow??0)*(item.amount??0)).toStringAsFixed(2)}"),
              subtitle: Text("${item.date}"),
            ),
          );
        },
        itemCount: _sales.length,
      ),
    );
  }

  Future<void> getDataas() async {
    final result = await api.getSales();

    _sales = result;
    await getDatas();
    _sales.forEach((sale) {
      sale.productName = _products
          .firstWhere((element) => element.id == sale.productId,
              orElse: () => ProductModel())
          .name;
    });
    setState(() {});
  }

  @override
  void initState() {
    getDataas();
    super.initState();
  }

  Future<void> getDatas() async {
    final result = await api.getProducts();
    await getProductGroups();
    _products = result;
    _products.forEach((product) {
      product.productGroupName = _productGroups
          .firstWhere((pg) => pg.id == product.productGroupId,
              orElse: () => ProductGroupModel())
          .name;
    });
    setState(() {});
  }

  Future<void> getProductGroups() async {
    final result = await api.getProductGroups();
    _productGroups = result;
    setState(() {});
  }
}

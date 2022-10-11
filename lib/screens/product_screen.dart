import 'package:flutter/material.dart';
import 'package:marketapp/helpers/api.dart';
import 'package:marketapp/models/product_model.dart';
import 'package:marketapp/screens/new_product_screen.dart';

import '../models/product_group_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var api = Api();
  List<ProductGroupModel> _productGroups = [];

  List<ProductModel> _products = [];
  num _selectedPg = -1;

  @override
  void initState() {
    getDatas();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ürünler"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navi(null);
          },
          child: Icon(Icons.add)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedPg = -1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedPg == -1
                            ? Colors.red
                            : Theme.of(context).primaryColor),
                    child: Text("Tümü")),
                for (var i = 0; i < _productGroups.length; i++)
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedPg = _productGroups[i].id ?? 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedPg == _productGroups[i].id
                              ? Colors.red
                              : Theme.of(context).primaryColor),
                      child: Text("${_productGroups[i].name}"))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                var item = _products
                    .where((element) => _selectedPg == -1
                        ? true
                        : element.productGroupId == _selectedPg)
                    .toList()[i];
                return Card(
                  child: ListTile(
                    leading: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text("${item.name}"),
                                    content: Text(
                                        "Bu ürünü silmek istediğinize emin misiniz?"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Vazgeç")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await api.deleteProduct(
                                                id: item.id ?? 0);
                                            await getDatas();
                                          },
                                          child: Text("Sil")),
                                    ],
                                  ));
                        },
                        child: Icon(Icons.delete)),
                    onTap: () {
                      navi(item);
                    },
                    title: Text("${item.name}"),
                    subtitle: Text("${item.productGroupName}"),
                  ),
                );
              },
              itemCount: _products
                  .where((element) => _selectedPg == -1
                      ? true
                      : element.productGroupId == _selectedPg)
                  .length,
            ),
          ),
        ],
      ),
    );
  }

  void navi(ProductModel? item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => NewProductScreen(
                  model: item,
                  pgs: _productGroups,
                ))).then((value) {
      if (value == true) {
        getDatas();
      }
    });
  }
}

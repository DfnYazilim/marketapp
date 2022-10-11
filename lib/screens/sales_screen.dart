import 'package:flutter/material.dart';
import 'package:marketapp/helpers/api.dart';
import 'package:marketapp/models/sale_model.dart';
import 'package:marketapp/screens/all_sale_screen.dart';

import '../models/product_group_model.dart';
import '../models/product_model.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  var api = Api();
  List<ProductGroupModel> _productGroups = [];
  List<SaleModel> _sales = [];
  List<ProductModel> _products = [];
  num _selectedPg = -1;
  num _selectedProduct = -1;

  List<SaleModel> _saleBox = [];

  @override
  void initState() {
    getDataas();
    super.initState();
  }

  Future<void> getDataas() async {
    final result = await api.getSales();

    _sales = result;
    await getDatas();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Satış ekranı"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> AllSaleScreen()));
          }, icon: Icon(Icons.list))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (var i = 0;
                      i <
                          _products
                              .where((element) => _selectedPg == -1
                                  ? true
                                  : element.productGroupId == _selectedPg)
                              .length;
                      i++)
                    ElevatedButton(
                        onPressed: () {
                          var item = _products
                              .where((element) => _selectedPg == -1
                                  ? true
                                  : element.productGroupId == _selectedPg)
                              .toList()[i];

                          boxAddOrRemove(item, 1);
                        },
                        child: Text("${_products[i].name}"))
                ],
              ),
            ),
            Text("Toplam Fiyat : ${sumOfBox()}"),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, i) {
                var item = _saleBox[i];
                return ListTile(
                  title: Text("${item.productName}"),
                  subtitle: Text(
                      "Birim fiyat :${item.priceRow}\nSatır Fiyatı:${((item.priceRow ?? 0) * (item.amount ?? 0)).toStringAsFixed(2)}"),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Icon(Icons.add),
                          onTap: () {
                            var pr = _products.firstWhere(
                                (element) => element.id == item.productId);
                            boxAddOrRemove(pr, 1);
                          },
                        ),
                        GestureDetector(
                          child: Icon(Icons.remove),
                          onTap: () {
                            var pr = _products.firstWhere(
                                (element) => element.id == item.productId);
                            boxAddOrRemove(pr, -1);
                          },
                        ),
                        Text("${item.amount}"),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _saleBox.length,
            )),
            ElevatedButton(
                onPressed: () {
                  sendSale();
                },
                child: Text("Satış Yap"))
          ],
        ),
      ),
    );
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

  void boxAddOrRemove(ProductModel item, num amount) {
    setState(() {
      var obj = SaleModel(
          amount: amount,
          productName: item.name,
          priceRow: item.price,
          productId: item.id);
      var check = _saleBox.where((element) => element.productId == item.id);
      if (check.isEmpty) {
        _saleBox.add(obj);
      } else {
        if (amount < 0 && (check.first.amount ?? 0) == 1) {
          _saleBox.removeWhere((element) => element.productId == item.id);
        } else {
          check.first.amount = (check.first.amount ?? 0) + amount;
        }
      }
    });
  }

  sumOfBox() {
    num sum = 0;
    _saleBox.forEach((element) {
      var ii = (element.priceRow ?? 0) * (element.amount ?? 0);
      sum += ii;
    });
    return sum.toStringAsFixed(2);
  }

  Future<void> sendSale() async {
    List<num> ids = [];
    for (var element in _saleBox) {
      final r = await api.newSale(model: element);
      if (r) {
        ids.add((element.productId ?? 0));
      }
    }
    ids.forEach((a) {
      _saleBox.removeWhere((element) => element.productId == a);
    });
    setState(() {});
  }
}

import 'package:flutter/material.dart';
import 'package:marketapp/helpers/api.dart';
import 'package:marketapp/models/product_group_model.dart';
import 'package:marketapp/screens/new_product_group_screen.dart';

class ProductGroupScreen extends StatefulWidget {
  const ProductGroupScreen({Key? key}) : super(key: key);

  @override
  State<ProductGroupScreen> createState() => _ProductGroupScreenState();
}

class _ProductGroupScreenState extends State<ProductGroupScreen> {
  List<ProductGroupModel> _productGroups = [];
  var api = Api();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ürün Grupları"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navi(null);
          },
          child: Icon(Icons.add)),
      body: ListView.builder(
          itemBuilder: (context, i) {
            var item = _productGroups[i];
            return Card(
              child: ListTile(
                onTap: () {
                  navi(item);
                },
                title: Text("${item.name}"),
                leading: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(item.name ?? ""),
                              content: Text(
                                  "Bu ürün grubunu silmek istediğinize emin misiniz?"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Vazgeç")),
                                ElevatedButton(
                                    onPressed: () async {
                                      await api.deleteProductGroup(
                                          id: item.id ?? 0);
                                      await getProductGroups();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Sil")),
                              ],
                            ));
                  },
                  child: Icon(Icons.delete),
                ),
              ),
            );
          },
          itemCount: _productGroups.length),
    );
  }

  @override
  void initState() {
    getProductGroups();
    super.initState();
  }

  Future<void> getProductGroups() async {
    final result = await api.getProductGroups();
    _productGroups = result;
    setState(() {});
  }

  void navi(ProductGroupModel? item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => NewProductGroupScreen(
                  model: item,
                ))).then((value) {
      if (value == true) {
        getProductGroups();
      }
    });
  }
}

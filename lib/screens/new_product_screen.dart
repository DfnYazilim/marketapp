import 'package:flutter/material.dart';
import 'package:marketapp/helpers/api.dart';
import 'package:marketapp/models/product_group_model.dart';
import 'package:marketapp/models/product_model.dart';

class NewProductScreen extends StatefulWidget {
  final ProductModel? model;
  final List<ProductGroupModel> pgs;

  const NewProductScreen({Key? key, this.model, required this.pgs})
      : super(key: key);

  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  var api = Api();
  final _saveKey = GlobalKey<FormState>();
  ProductGroupModel? _selectedPg = ProductGroupModel();
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      _name.text = widget.model?.name ?? "";
      _price.text = (widget.model?.price ?? 0).toString();
      _selectedPg = widget.pgs.firstWhere(
          (element) => element.id == (widget.model?.productGroupId ?? 0),
          orElse: () => ProductGroupModel());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${widget.model == null ? "Yeni Ürün" : "Ürün Güncelleme"}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _saveKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text("Ürün Adı")),
                controller: _name,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Zorunlu alan";
                  }

                },
              ),
              SizedBox(
                height: 8,
              ),
              DropdownButtonFormField<ProductGroupModel>(
                decoration: InputDecoration(
                  label: Text("Ürün Grubu")
                ),
                  items: widget.pgs
                      .map((e) => DropdownMenuItem(
                            child: Text(e.name ?? ""),
                            value: e,
                          ))
                      .toList(),
                  value: widget.model == null ? null : _selectedPg,
                  validator: (v) {
                    if (v == null) {
                      return "Zorunlu alan";
                    }
                  },
                  onChanged: (v) {
                    if (v != null) {
                      _selectedPg = v;
                      setState(() {});
                    }
                  }),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(label: Text("Ürün Fiyatı")),
                controller: _price,
                validator: (v) {
                  if (v == null || double.tryParse(v) == null) {
                    return "Zorunlu alan";
                  }
                },
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  onPressed: () async {
                    _saveKey.currentState!.save();
                    if (_saveKey.currentState!.validate()) {
                      if (widget.model == null) {
                        final r = await api.newProduct(
                            model: ProductModel(
                                name: _name.text,
                                price: double.tryParse(_price.text) ?? 0,
                                productGroupId: _selectedPg?.id ?? 0));
                        if (r) {
                          Navigator.pop(context,true);
                        }
                      } else {
                        final r = await api.updateProduct(
                            model: ProductModel(
                                name: _name.text,
                                price: double.tryParse(_price.text) ?? 0,
                                productGroupId: _selectedPg?.id ?? 0),
                            id: widget.model?.id ?? 0);
                        Navigator.pop(context,true);
                      }
                    }
                  },
                  child:
                      Text("${widget.model == null ? 'Kaydet' : 'Güncelle'}"))
            ],
          ),
        ),
      ),
    );
  }
}

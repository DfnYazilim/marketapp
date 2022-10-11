import 'package:flutter/material.dart';
import 'package:marketapp/helpers/api.dart';
import 'package:marketapp/models/product_group_model.dart';

class NewProductGroupScreen extends StatefulWidget {
  final ProductGroupModel? model;

  const NewProductGroupScreen({Key? key, this.model}) : super(key: key);

  @override
  _NewProductGroupScreenState createState() => _NewProductGroupScreenState();
}

class _NewProductGroupScreenState extends State<NewProductGroupScreen> {
  TextEditingController _name = TextEditingController();
  final _saveKey = GlobalKey<FormState>();
var api  =Api();
  @override
  void initState() {
    super.initState();
    if(widget.model !=null){
      _name.text = widget.model?.name??"";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.model == null ? 'Yeni Ürün Grubu' : 'Ürün Grubu Güncelle'}"),
      ),
      body: Padding(

        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _saveKey,
          child: Column(
            children: [
              TextFormField(decoration: InputDecoration(
                label: Text("Ürün Grubu Adı"),

              ),controller: _name,validator: (v){
                if(v == null){
                  return "Zorunlu alan";
                }
              },),
              SizedBox(height: 8,),
              ElevatedButton(onPressed: () async {
                _saveKey.currentState!.save();
                if(_saveKey.currentState!.validate()){
                  if(widget.model != null){
                    widget.model!.name = _name.text;
                    final r = await api.updateProductGroup(model: widget.model!, id: widget.model?.id ?? 0);
                    if(r) Navigator.pop(context,true);
                  } else {
                    final r = await api.newProductGroup(model: ProductGroupModel(name: _name.text));
                    if(r) Navigator.pop(context,true);
                  }
                }
              }, child: Text("${widget.model == null ? "Kaydet" : 'Güncelle'}"))
            ],
          ),
        ),
      ),
    );
  }
}

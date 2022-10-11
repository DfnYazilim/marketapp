import 'package:dio/dio.dart';
import 'package:marketapp/models/product_group_model.dart';
import 'package:marketapp/models/product_model.dart';
import 'package:marketapp/models/sale_model.dart';

class Api {
  String baseUrl = "http://localhost:3004/";
  var dio = Dio();
  Future<List<ProductGroupModel>> getProductGroups() async {
    try {
      var response = await Dio().get(baseUrl+'productGroups');
      var _datas = <ProductGroupModel>[];
      Iterable _iterable = response.data;
      _datas = _iterable.map((e) => ProductGroupModel.fromJson(e)).toList();

      return _datas;
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<List<ProductModel>> getProducts() async {
    try {
      var response = await Dio().get(baseUrl+'products');
      var _datas = <ProductModel>[];
      Iterable _iterable = response.data;
      _datas = _iterable.map((e) => ProductModel.fromJson(e)).toList();

      return _datas;
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<List<SaleModel>> getSales() async {
    try {
      var response = await Dio().get(baseUrl+'sales');
      var _datas = <SaleModel>[];
      Iterable _iterable = response.data;
      _datas = _iterable.map((e) => SaleModel.fromJson(e)).toList();

      return _datas;
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<bool> newProductGroup({required ProductGroupModel model}) async {
    try {
      var response = await dio.post(baseUrl + 'productGroups',data: model.toJson());
      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> newProduct({required ProductModel model}) async {
    try {
      var response = await dio.post(baseUrl + 'products',data: model.toJson());
      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> newSale({required SaleModel model}) async {
    try {
      var response = await dio.post(baseUrl + 'sales',data: model.toJson());
      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProductGroup({required ProductGroupModel model, required num id}) async {
    try {
      var response = await dio.put(baseUrl + 'productGroups/$id',data: model.toJson());
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> updateProduct({required ProductModel model, required num id}) async {
    try {
      var response = await dio.put(baseUrl + 'products/$id',data: model.toJson());
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> updateSale({required SaleModel model, required num id}) async {
    try {
      var response = await dio.put(baseUrl + 'sales/$id',data: model.toJson());
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteProductGroup({required num id}) async {
    try {
      var response = await dio.delete(baseUrl + 'productGroups/$id',);
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> deleteProduct({required num id}) async {
    try {
      var response = await dio.delete(baseUrl + 'products/$id',);
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> deleteSale({required num id}) async {
    try {
      var response = await dio.delete(baseUrl + 'sales/$id',);
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
import 'package:donutplugin/models/DonutApiModel.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
Future<List<DonutApiModel>> getDonutCategories() async {
       var cat= await http.get("https://zyngltest.getsandbox.com/spendingCategories");
    if (cat.statusCode==200) {
      Map<String, dynamic> jsonDecode = convert.jsonDecode(cat.body);
      return (jsonDecode['spendingCategories'] as List).map((item)=>DonutApiModel.fromJson(item)).toList();
    }
    else{
      throw Exception;
    }

}
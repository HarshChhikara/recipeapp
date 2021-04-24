import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipeapp/models/hits.dart';

class Recipie {
  List<Hits> hits = [];

  Future<void> getReceipe(String query) async {
    String url = "https://api.edamam.com/search?q=$query&app_id=a753f9ad&app_key=98987e362a90c2cd5f25e2bb7151e8ab";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element) {
      Hits hits = Hits(
        recipeModel: element['recipe'],
      );
      // hits.recipeModel = add(Hits.fromMap(hits.recipeModel));
    });
  }
}
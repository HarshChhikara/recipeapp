import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe_model.dart';
import 'package:recipeapp/views/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<RecipeModel> recipes = <RecipeModel>[];
  TextEditingController textEditingController = new TextEditingController();

  String applicationId="a753f9ad";
  String applicationKey="98987e362a90c2cd5f25e2bb7151e8ab";

  getRecipes(String query) async{

    String url ="https://api.edamam.com/search?q=$query&app_id=a753f9ad&app_key=98987e362a90c2cd5f25e2bb7151e8ab";

    String source="https://api.edamam.com/search?q=$query&app_id=a753f9ad&app_key=98987e362a90c2cd5f25e2bb7151e8ab";
    String image="https://api.edamam.com/search?q=$query&app_id=a753f9ad&app_key=98987e362a90c2cd5f25e2bb7151e8ab";
    String label="https://api.edamam.com/search?q=$query&app_id=a753f9ad&app_key=98987e362a90c2cd5f25e2bb7151e8ab";

    //did change line 23 original http.get(url);//
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element){
      print(element.toString());

      RecipeModel recipeModel = new RecipeModel(url: url, source: source, image: image, label: label);
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);

    });

    setState(() {});
    print("${recipes.toString()}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      const Color(0xff213A50),
                      const Color(0xff071930),
                    ]
                )
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical:!kIsWeb? 60 : 24, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Row(
                    mainAxisAlignment: kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Recipe", style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),),
                      Text("App", style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue
                      ),)
                    ],
                  ),
                  SizedBox(height: 35,),
                  Text("Looking for a Recipe?", style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),),
                  SizedBox(height: 8,),
                  Text("Enter the ingredients you have and wait for the best results.", style: TextStyle(
                      fontSize: 15,
                      color: Colors.white
                  ),),
                  SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: "Enter the Ingredient",
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.5)
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        InkWell(
                          onTap: (){
                            if(textEditingController.text.isNotEmpty){
                              getRecipes(textEditingController.text);
                              print("just do it");
                            }
                            else{
                              print("just dont do it");

                            }
                          },
                          child: Container(
                            child: Icon(Icons.search, color: Colors.white,),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: GridView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:200,
                        mainAxisSpacing: 10.0,
                      ),
                      children: List.generate(recipes.length, (index) {
                        return RecipieTile(
                          title: recipes[index].label,
                          desc: recipes[index].source,
                          imgUrl: recipes[index].image,
                          url: recipes[index].url,
                      );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({required this.title,required this.desc,required this.imgUrl,required this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

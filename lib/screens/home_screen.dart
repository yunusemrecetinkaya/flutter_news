import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/models/news_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import 'news_detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bitcoinUrl =
      'http://newsapi.org/v2/everything?q=bitcoin&from=2020-10-18&sortBy=publishedAt&apiKey=9992da085b5442adadd8c2e5bf3ac06d';
  final businessUrl =
      'http://newsapi.org/v2/everything?country=tr&category=business&apiKey=9992da085b5442adadd8c2e5bf3ac06d';
  Future<NewsModel> _newsModel;
  Future<NewsModel> _sliderNews;

  Future<NewsModel> verileriAl() async {
    final response = await http.get(businessUrl);
    if (response.statusCode == 200) {
      return newsModelFromJson(response.body);
    } else {
      throw Exception('Failed to load NewsModel');
    }
  }

  Future<NewsModel> sliderData() async {
    final response2 = await http.get(bitcoinUrl);
    if (response2.statusCode == 200) {
      return newsModelFromJson(response2.body);
    } else {
      throw Exception('Failed to load NewsModel');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _newsModel = verileriAl();
    _sliderNews = sliderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ///APPBAR
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                title: Text('NEWS',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                leading: Icon(Icons.menu,color: Colors.white,),
                trailing: Icon(Icons.account_box_outlined,color: Colors.white,),
              ),
            ),
          ),
          /// SLİDER
          Expanded(
            flex: 1,
            child: FutureBuilder<NewsModel>(
                future: _newsModel,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    default:
                      if (snapshot.hasData) {
                        return Carousel(
                          showIndicator: true,
                          animationCurve: Curves.decelerate,
                          autoplay: true,
                          dotBgColor: Colors.transparent,
                          dotColor: Colors.grey,
                          dotIncreasedColor: Colors.red,
                          dotPosition: DotPosition.topCenter,
                          dotSize: 5,
                          boxFit: BoxFit.fill,
                          images: [1, 2, 3, 4, 5, 6, 7, 8, 9,10].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NewsDetail(snapshot.data.articles[i])));
                                          },
                                          splashColor: Colors.red,
                                          child: Image.network(
                                            snapshot.data.articles[i].urlToImage,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ListTile(
                                        title: AutoSizeText(
                                          snapshot.data.articles[i].title,

                                          style:
                                              TextStyle(color: Colors.black),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                        tileColor: Colors.white70,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return null;
                      }
                  }
                }),
          ),
          ///CONTEXT
          Expanded(
            flex: 2,
            child: FutureBuilder<NewsModel>(
              future: _sliderNews,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  default:
                    if (snapshot.hasData) {
                      return StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: snapshot.data.articles.length,
                        itemBuilder: (BuildContext context, int index) =>
                            new Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 10,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NewsDetail(snapshot.data.articles[index])));
                                        },
                                        splashColor: Colors.red,
                                        child: Image.network(
                                          snapshot
                                              .data.articles[index].urlToImage,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ListTile(
                                        title: Text(
                                          snapshot.data.articles[index].title,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white),
                                        ),
                                        tileColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                )),
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(
                                2, index.isEven ? 1.5 : 2.5),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      );
                    } else {
                      return null;
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

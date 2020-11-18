import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_news/models/news_model.dart';
import 'package:stretchy_header/stretchy_header.dart';

class NewsDetail extends StatelessWidget {
  Article article;
  NewsDetail(Article article){
    this.article = article;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: StretchyHeader.singleChild(
        headerData: HeaderData(
          headerHeight: MediaQuery.of(context).size.height * .5,
          header: Image.network(
            article.urlToImage,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(article.source.name),
                  Text(DateFormat('yyyy/MM/dd - kk:mm').format(article.publishedAt)),
                ],
              ),
              SizedBox(height: 10),
              Text(article.title,style: TextStyle(fontSize: 30),),
              SizedBox(height: 10),
              Text(article.description,style: TextStyle(fontSize: 18),),
              SizedBox(height: 10),
              Text(article.content,style: TextStyle(fontSize: 18),),
            ],
          ),
        ),
      ),
    );
  }


}


import 'dart:math';
import 'package:flutter/material.dart';
import 'package:instatube/widgets/appbar.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> videos = new List();
  ScrollController _scrollController = ScrollController();

  @override
  void initState()
  {
    super.initState();
    fetchFive();
    _scrollController.addListener(()
    {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent)
      {
        fetchFive();
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      body: GridView.builder (
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        controller: _scrollController,
        itemCount: videos.length,
        itemBuilder: (BuildContext context, int index)
        {
          return Container(
            constraints: BoxConstraints.tightFor(height:150.0),
            child: Text(videos[index]),

          );
        },

      ),
    );
  }

  fetch() async
  {
    Random r = Random();
    videos.add(r.nextInt(200).toString());
  }

  fetchFive()
  {
    for(int i =0; i< 5; i++)
    {
      fetch();
    }
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
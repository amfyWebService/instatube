
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:instatube/widgets/appbar.dart';
import 'package:instatube/widgets/list_item_video.dart';
import 'package:video_player/video_player.dart';

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
            child: index == 0 ? ChewieListItem(videoPlayerController: VideoPlayerController.network(videos[index]),ratio: 16/9,autoPlay: true, ): ChewieListItem(videoPlayerController: VideoPlayerController.network(videos[index]),ratio: 4/3,autoPlay: false,),

          );
        },

      ),
    );
  }

  fetch() async
  {
    videos.add( "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4");
  }

  fetchFive()
  {
    for(int i =0; i< 9; i++)
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
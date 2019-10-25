
import 'package:flutter/material.dart';
import 'package:instatube/widgets/appbar.dart';
import 'package:instatube/widgets/drawer.dart';
import 'package:instatube/widgets/list_item_video.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text("Search");
  String title ;
  ScrollController _controller;
  final textFieldController = TextEditingController();

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  
  }

  
  
  @override
  Widget build(BuildContext context) {
  
  return new Scaffold(
        appBar: AppBar(
        actions: <Widget>[
            IconButton(
              onPressed: (){
                setState(() {
                  if(this.customIcon.icon == Icons.search){
                    this.customIcon =Icon(Icons.cancel);
                    this.customSearchBar = TextField(
                      controller: textFieldController,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Term"
                      ),
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      )
                    );

                  }else{
                     this.customIcon = Icon(Icons.search);
                     this.customSearchBar = Text("Search");
                  } 
                });
              },
              icon:customIcon,
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.more_vert)
            )
          ],
          title: customSearchBar,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Color(0xFF5E0075),
                    Color(0xFFFC0002),
                    Color(0xFFFFAD00),
                  ],
                  ),
                ),
              ),
            ),
             body:  ListView(
        controller: _controller,
    
        children: <Widget>[
           CircularProgressIndicator(),
          ChewieListItem(
            videoPlayerController: VideoPlayerController.network(
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
            ),
            looping: true,
          ),
          ChewieListItem(
            videoPlayerController: VideoPlayerController.network(
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            ),
          ),
          ChewieListItem(
            // This URL doesn't exist - will display an error
            videoPlayerController: VideoPlayerController.network(
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
            ),
        
          ),
          ChewieListItem(
            // This URL doesn't exist - will display an error
            videoPlayerController: VideoPlayerController.network(
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
            ),
        
          ),
          ChewieListItem(
            // This URL doesn't exist - will display an error
            videoPlayerController: VideoPlayerController.network(
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
            ),
        
          ),
          ChewieListItem(
            // This URL doesn't exist - will display an error
            videoPlayerController: VideoPlayerController.network(
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
            ),
        
          )
        ]
      ),
      drawer: AppDrawer(),
    );
  }
}
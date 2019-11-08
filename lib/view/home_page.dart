import 'package:flutter/material.dart';
import 'package:instatube/core/service/videos_service.dart';
import 'package:instatube/widgets/drawer.dart';
import 'package:instatube/widgets/floatting_button_menu.dart';
import 'package:instatube/widgets/list_item_video.dart';
import 'package:instatube/widgets/my_app_bar.dart';

class HomePage extends StatefulWidget {
  static String title = "home_title";

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text("Search");
  String title;
  final textFieldController = TextEditingController();

  bool isLoading =false;
                      

  List<String> _videosLink= [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
  ];

    @override


  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMore();
      } else {
        isLoading = false;
      }
    });
  }

  _loadMore() {
    setState(() {
      print('loading more,...');

      _videosLink..addAll(List<String>.from(_videosLink));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (this.customIcon.icon == Icons.search) {
                  this.customIcon = Icon(Icons.cancel);
                  this.customSearchBar = TextField(
                      controller: textFieldController,
                      autofocus: true,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Search Term"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ));
                } else {
                  this.customIcon = Icon(Icons.search);
                  this.customSearchBar = Text("Search");
                }
              });
            },
            icon: customIcon,
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
        title: customSearchBar,
      ),
      body: ListView.builder(
        addSemanticIndexes: false,
        addRepaintBoundaries: false,
        addAutomaticKeepAlives: false,
        controller: _scrollController,
        itemCount: _videosLink.length,
        itemBuilder: (BuildContext context, int index) {
          return ChewieListItem(
            url: _videosLink[index],
            ratio: 16 / 9,
            autoPlay: index == 0,
          );
        },
      ),
      drawer: AppDrawer(),
      floatingActionButton: FancyFab(),
      
      // floatingActionButton: Align(
      //     child: FloatingActionButton(
      //       onPressed: () {
      //         VideoService.uploadVideoFromCamera();
      //       },
      //       child: Icon(Icons.videocam),
      //       backgroundColor: Colors.red,
      //     ),
      //     alignment: FractionalOffset(0.55, 1.0)),
          
      // ButtonTheme(
      //   minWidth: 200.0,
      //   height: 100.0,
      //     child: RaisedButton(
      //       color: Colors.red,
      //       shape: CircleBorder(),
      //       onPressed: () {},
      //       child: Icon(Icons.videocam),

      //     ),
      //   ),
    );
  }
}

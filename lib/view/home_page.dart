
import 'package:flutter/material.dart';
import 'package:instatube/widgets/drawer.dart';
import 'package:instatube/widgets/list_item_video.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text("Search");
  String title ;
  final textFieldController = TextEditingController();
  bool isLoading =false;
                      
  
  List<String> _videosLink= [

   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
  ];
    @override
  
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }else {
        isLoading =false;
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
        body: ListView.builder(
          addSemanticIndexes: false,
          addRepaintBoundaries: false,
              addAutomaticKeepAlives: false,
              controller: _scrollController,
              itemCount: _videosLink.length,
              itemBuilder: (BuildContext context, int index) {
                return ChewieListItem(url: _videosLink[index],ratio: 16/9,autoPlay: index == 0, );
              },
          ),
        drawer: AppDrawer(),
    );
  }
}
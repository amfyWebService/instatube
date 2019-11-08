import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/core/model/video.dart';
import 'package:instatube/widgets/drawer.dart';
import 'package:instatube/widgets/list_item_video.dart';

import '../core/utils/preference_service.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScrollController _scrollController = ScrollController();
  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text("Search");
  String title;
  final textFieldController = TextEditingController();
  bool isLoading = false;

  List<String> _videosLink = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
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
    List<Video> userVideo = new List<Video>();
    String fetchAll = """query {videosByUserId(user_id : "5db5ad4bab396941b9d073cd"){
    id}}""";

    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
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
      body: Column(
        children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
          )),
          Padding(
            padding: EdgeInsets.only(left: 25.0, top: 10.0),
            child: Center(
              child: new Text(PreferenceService.user.username,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: 'sans-serif-light',
                      color: Colors.black)),
            ),
          ),
          Query(
              options: QueryOptions(
                document: fetchAll,
              ),
              builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                if (result.hashCode != null) {
                  print(result.errors.toString());
                }
                if (result.loading) {
                  return Text('Loading');
                }
//                for(int i =0; i < 10;i++)
//                {
//                  Video v = new Video("test.mov","b5d5de","description","test");
//                  userVideo.add(v);
//
//                }
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: ListView.builder(
                      addSemanticIndexes: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      addRepaintBoundaries: false,
                      addAutomaticKeepAlives: false,
                      controller: _scrollController,
                      itemCount: userVideo.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChewieListItem(
//                          url: userVideo[index].getVideoLink(),
                          url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                          ratio: 16 / 9,
                          autoPlay: index == 0,
                        );
                      },
                    ),
                  ),
                );
              }),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}

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
  bool isLoading = false;

  List<Map> _videos = [];

  String getVideos = '''
    query GetVideos(\$limit: Int!, \$cursor: Int!){
        videos(last: \$limit, cursor: \$cursor, where: {user_id: "${PreferenceService.user.id}"}) {
            totalCount
            edges {
                node {
                    id
                    title
                    filename
                    user_id
                }
                cursor
            }
            pageInfo {
                hasNextPage
            }
        }
    }
  ''';
  FetchMore fetchMore;
  int lastCursor;

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
    if (this.fetchMore != null) {
      this.fetchMore(FetchMoreOptions(
          variables: {'cursor': this.lastCursor},
          updateQuery: (previousResultData, fetchMoreResultData) =>
              this.updateQuery(previousResultData, fetchMoreResultData)));
    }
  }

  updateQuery(previousResultData, fetchMoreResultData) {
    final List edges = fetchMoreResultData['videos']['edges'];
    if (edges.length > 0) this.lastCursor = edges.last['cursor'];
    var videos = edges.map((item) => item['node'] as Map).toList();

//    // this function will be called so as to combine both the original and fetchMore results
//    // it allows you to combine them as you would like
//    final Iterable<dynamic> videos = [
//      ...previousResultData['videos']['edges'] as Iterable<dynamic>,
//      ...edges.map((item) => serializers.deserialize(item['node']) as Video)
//    ];
//
    // to avoid a lot of work, lets just update the list of repos in returned
    // data with new data, this also ensure we have the endCursor already set
    // correctly
    fetchMoreResultData['videos']['edges'] = videos;

    return fetchMoreResultData;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: getVideos, variables: {'limit': 5, 'cursor': 0}),
        builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
          if (!result.hasErrors && !result.loading) {
            this.fetchMore = fetchMore;
            var data = result.data;
            if (lastCursor == null) {
              data = this.updateQuery({
                'videos': {'edges': []}
              }, result.data);
            }
            this._videos = [..._videos, ...(data['videos']['edges'] as List)];
          } else {
            this.fetchMore = null;
          }

          return Scaffold(
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
            body: Column(children: <Widget>[
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: ListView.builder(
                    addSemanticIndexes: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    addRepaintBoundaries: false,
                    addAutomaticKeepAlives: false,
                    controller: _scrollController,
                    itemCount: _videos.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("hhh" + Video.getLink(context, _videos[index]));
                      return ChewieListItem(
                        url: Video.getLink(context, _videos[index]),
                        ratio: 16 / 9,
                        autoPlay: index == 0,
                      );
                    },
                  ),
                ),
              ),
            ]),
            drawer: AppDrawer(),
          );
        });
  }
}

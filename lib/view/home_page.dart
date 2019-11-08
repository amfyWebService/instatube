import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instatube/core/model/video.dart';
import 'package:instatube/core/service/videos_service.dart';
import 'package:instatube/widgets/drawer.dart';
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

  bool isLoading = false;

  List<String> _videosLink = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
  ];

  List<Map> _videos = [];

  String getVideos = '''
    query GetVideos(\$limit: Int!, \$cursor: Int!){
        videos(last: \$limit, cursor: \$cursor) {
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
    this.lastCursor = edges.last['cursor'];
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
              itemCount: _videos.length,
              itemBuilder: (BuildContext context, int index) {
                return ChewieListItem(
                  url: Video.getLink(context, _videos[index]),
                  ratio: 16 / 9,
                  autoPlay: index == 0,
                );
              },
            ),
            drawer: AppDrawer(),
            floatingActionButton: Align(
                child: FloatingActionButton(
                  onPressed: () {
                    VideoService.uploadVideoFromCamera();
                  },
                  child: Icon(Icons.videocam),
                  backgroundColor: Colors.red,
                ),
                alignment: FractionalOffset(0.55, 1.0)),
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
        });
  }
}

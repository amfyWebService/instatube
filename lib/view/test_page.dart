import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String getUser = """
  query user(\$id: String!) {
      user(id: \$id) {
        id
        username
        email
    }  
  }
""";

    return Query(
      options: QueryOptions(
        document: getUser, // this is the query string you just created
        variables: {
          'id': "5db196d24546043b32856adc",
        },
//        pollInterval: 10,
      ),
      // Just like in apollo refetch() could be used to manually trigger a refetch
      // while fetchMore() can be used for pagination purpose
      builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.errors != null) {
          return Text(result.errors.toString());
        }

        if (result.loading) {
          return Text('Loading');
        }

        Map<String, dynamic> user = result.data['user'] as Map;
        List keys = user.keys.toList();

        return Scaffold(
          body: ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                String key = keys[index];
                String value = user[key];
                return Text("$key : $value");
              }),
        );

        // it can be either Map or List
//        List repositories = result.data['viewer']['repositories']['nodes'];
//
//        return ListView.builder(
//            itemCount: repositories.length,
//            itemBuilder: (context, index) {
//              final repository = repositories[index];
//
//              return Text(repository['name']);
//            });
      },
    );
  }
}

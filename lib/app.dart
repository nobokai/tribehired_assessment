import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tribehired_assessment/providers/posts.dart';
import 'package:tribehired_assessment/screens/filter_comments.dart';
import 'package:tribehired_assessment/screens/home.dart';
import 'package:tribehired_assessment/screens/post_details.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Posts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        theme: ThemeData(fontFamily: 'Lato'),
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          PostDetailScreen.routeName: (context) => const PostDetailScreen(),
          FilteredCommentScreen.routeName: (context) =>
              const FilteredCommentScreen(),
        },
      ),
    );
  }
}

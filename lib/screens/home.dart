import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tribehired_assessment/models/post.dart';
import 'package:tribehired_assessment/providers/posts.dart';
import 'package:tribehired_assessment/screens/post_details.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<Post> posts = [];
  List<String> imageUrls = [];

  void getPosts() {
    Provider.of<Posts>(context, listen: false).getPosts().then((_) {
      setState(() {
        posts = Provider.of<Posts>(context, listen: false).posts;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    imageUrls.shuffle();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Posts',
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(posts.length, (index) {
                    var selectedColor = Colors
                        .primaries[Random().nextInt(Colors.primaries.length)];
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(
                              postId: posts[index].id,
                              color: selectedColor,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          left: 16.0,
                          right: 16.0,
                          bottom: index == posts.length - 1 ? 16.0 : 0.0,
                        ),
                        child: Card(
                          elevation: 8,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 175,
                                decoration: BoxDecoration(
                                  color: selectedColor.withOpacity(0.5),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Positioned(
                                right: 16.0,
                                top: 16.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "POST",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      posts[index].id.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 16.0,
                                right: 16.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      posts[index].title,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      posts[index].body,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Written by ${posts[index].userId.toString()}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
      ),
    );
  }
}

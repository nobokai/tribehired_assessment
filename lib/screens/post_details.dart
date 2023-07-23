import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tribehired_assessment/models/post.dart';
import 'package:tribehired_assessment/providers/posts.dart';
import 'package:tribehired_assessment/screens/filter_comments.dart';

class PostDetailScreen extends StatefulWidget {
  static const routeName = "/post_details";
  const PostDetailScreen({
    Key? key,
    this.postId,
    this.color,
  }) : super(key: key);

  final Color? color;
  final int? postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? currentPostDetail;
  bool isLoading = true;
  var comments = [];

  void getPostByPostId() {
    Provider.of<Posts>(context, listen: false)
        .getPostByPostId(widget.postId)
        .then((_) {
      setState(() {
        currentPostDetail = Provider.of<Posts>(context, listen: false).post;
      });
    });
  }

  void getCommentsByPostId() {
    Provider.of<Posts>(context, listen: false)
        .getCommentsByPostId(widget.postId)
        .then((value) {
      setState(() {
        comments = Provider.of<Posts>(context, listen: false).comments;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getPostByPostId();
    getCommentsByPostId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: widget.color,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "POST",
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              currentPostDetail?.id.toString() ?? "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return FilteredCommentScreen(
                      postId: widget.postId!,
                      color: widget.color!,
                    );
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.color?.withOpacity(0.5),
                        ),
                        height: deviceSize.height * 0.4,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentPostDetail?.title ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Written by ${currentPostDetail?.userId.toString() ?? ""}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentPostDetail?.body ?? "",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Divider(
                          height: 0,
                          thickness: 0,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Comments',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //comments
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Material(
                                      shape: CircleBorder(),
                                      elevation: 8,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        foregroundImage: AssetImage(
                                          'assets/images/man_avatar.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comments[index].name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            comments[index].email,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16.0,
                                          ),
                                          Text(comments[index].body),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 16,
                            );
                          },
                          itemCount: comments.length,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

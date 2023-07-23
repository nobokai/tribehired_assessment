import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import 'package:tribehired_assessment/providers/posts.dart';

class FilteredCommentScreen extends StatefulWidget {
  static const routeName = "/filter_post_comments";
  const FilteredCommentScreen({
    Key? key,
    this.postId,
    this.color,
  }) : super(key: key);

  final int? postId;
  final Color? color;

  @override
  State<FilteredCommentScreen> createState() => _FilteredCommentScreenState();
}

class _FilteredCommentScreenState extends State<FilteredCommentScreen> {
  bool isLoading = true;
  var filtered = [];

  void getFilteredComments(String text) {
    setState(() {
      if (text.isEmpty) {
        filtered = [];
        isLoading = true;
      } else {
        filtered = Provider.of<Posts>(context, listen: false)
            .getRelevantCommentsByValue(postId: widget.postId!, text: text);
        isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: widget.color,
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            getFilteredComments(value);
          },
          decoration: const InputDecoration(
            isDense: true,
            filled: true,
            contentPadding: EdgeInsets.all(10),
            fillColor: Colors.white,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: 'Search by name, email or body',
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Lottie.asset("assets/animations/search.json"),
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filtered[index].name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                filtered[index].email,
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Text(filtered[index].body),
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
              itemCount: filtered.length,
            ),
    );
  }
}

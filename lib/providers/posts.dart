import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tribehired_assessment/models/comment.dart';
import 'package:tribehired_assessment/models/post.dart';

class Posts with ChangeNotifier {
  Post? _post;
  List<Post> _posts = [];
  List<Comment> _comments = [];

  Post? get post {
    return _post;
  }

  List<Post> get posts {
    return [..._posts];
  }

  List<Comment> get comments {
    return [..._comments];
  }

  Future<void> getPosts() async {
    try {
      const url = "https://jsonplaceholder.typicode.com/posts";
      final response = await http.get(
        Uri.parse(url),
      );
      var responseData = json.decode(response.body);
      convertToPostType(responseData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getPostByPostId(int? postId) async {
    try {
      final url = "https://jsonplaceholder.typicode.com/posts/$postId";
      var response = await http.get(
        Uri.parse(url),
      );
      var responseData = json.decode(response.body);
      convertToPostType(responseData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getCommentsByPostId(int? postId) async {
    try {
      final url =
          'https://jsonplaceholder.typicode.com/comments?postId=$postId';
      var response = await http.get(Uri.parse(url));
      var responseData = json.decode(response.body);
      convertToCommentType(responseData);
    } catch (error) {
      rethrow;
    }
  }

  List<Comment> getRelevantCommentsByValue({required int postId, var text}) {
    return _comments.where((element) {
      return element.postId == postId &&
          (element.name.contains(text) ||
              element.email.contains(text) ||
              element.body.contains(text));
    }).toList();
  }

  void convertToPostType(var data) {
    if (data is List) {
      List<Post> convertedData = data.map(
        (each) {
          return Post.fromJson(each);
        },
      ).toList();
      _posts = convertedData;
    } else {
      _post = Post.fromJson(data);
    }
  }

  void convertToCommentType(var data) {
    if (data is List) {
      List<Comment> convertedData = data.map(
        (each) {
          return Comment(
            postId: each['postId'],
            id: each['id'],
            name: each['name'],
            email: each['email'],
            body: each['body'],
          );
        },
      ).toList();
      _comments = convertedData;
    }
  }
}

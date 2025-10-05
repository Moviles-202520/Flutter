import 'package:flutter/material.dart';
import '../domain/repositories/news_repository.dart';
import '../domain/models/news_item.dart';
import '../domain/models/rating_item.dart';
import '../domain/models/comment.dart';

class NewsDetailViewModel extends ChangeNotifier {
  final NewsRepository _repository;
  final String news_item_id;

  NewsItem? _news_item;
  List<Comment> _comments = [];
  bool _is_loading = true;
  bool _is_submitting_rating = false;
  bool _is_submitting_comment = false;

  NewsDetailViewModel(this._repository, this.news_item_id) {
    _loadData();
  }

  NewsItem? get news_item => _news_item;
  List<Comment> get comments => _comments;
  bool get is_loading => _is_loading;
  bool get is_submitting_rating => _is_submitting_rating;
  bool get is_submitting_comment => _is_submitting_comment;

  Future<void> _loadData() async {
    try {
      _is_loading = true;
      notifyListeners();
      
      _news_item = await _repository.getNewsDetail(news_item_id);
      _comments = await _repository.getComments(news_item_id);
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<void> submitRating(double score, String? comment_text) async {
    _is_submitting_rating = true;
    notifyListeners();

    try {
      final rating_item = RatingItem(
        rating_item_id: 'rating_${DateTime.now().millisecondsSinceEpoch}',
        news_item_id: news_item_id,
        user_profile_id: 'current_user',
        assigned_reliability_score: score,
        comment_text: comment_text ?? '',
        rating_date: DateTime.now(),
        is_completed: true,
      );
      
      await _repository.submitRating(rating_item);
    } catch (e) {
      print('Error submitting rating: $e');
    } finally {
      _is_submitting_rating = false;
      notifyListeners();
    }
  }

  Future<void> submitComment(String content) async {
  _is_submitting_comment = true;
  notifyListeners();

  try {
    final comment = Comment(
      comment_id: DateTime.now().millisecondsSinceEpoch.toString(),
      news_item_id: news_item_id, // Esto ya es string como "1", "2", etc.
      user_profile_id: '1', // ✅ USAR IDs EXISTENTES COMO STRING
      user_name: 'You',
      content: content,
      timestamp: DateTime.now(),
    );
    await _repository.submitComment(comment);
    _comments.insert(0, comment);
  } catch (e) {
    print('Error submitting comment: $e');
  } finally {
    _is_submitting_comment = false;
    notifyListeners();
  }
}
}
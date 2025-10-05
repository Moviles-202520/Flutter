import 'package:flutter/foundation.dart';
import 'package:punto_neutro/data/repositories/hybrid_news_repository.dart';
import '../domain/repositories/news_repository.dart';
import '../domain/models/news_item.dart';

class NewsFeedViewModel extends ChangeNotifier {
  final NewsRepository _repository;
  
  List<NewsItem> _newsItems = [];
  Map<String, int> _commentsCount = {};
  Map<String, int> _ratingsCount = {};
  bool _isLoading = true;
  int _currentIndex = 0;

  NewsFeedViewModel(this._repository) {
    _loadNews();
  }

  List<NewsItem> get newsItems => _newsItems;
  bool get isLoading => _isLoading;
  int get currentIndex => _currentIndex;

  int getCommentsCount(String newsId) {
    return _commentsCount[newsId] ?? 0;
  }

  int getRatingsCount(String newsId) {
    return _ratingsCount[newsId] ?? 0;
  }

  String formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Future<void> _loadNews() async {
    try {
      _isLoading = true;
      notifyListeners();

      final List<NewsItem> loadedNews = [];
      
      for (int i = 1; i <= 10; i++) {
        try {
          final news = await _repository.getNewsDetail(i.toString());
          loadedNews.add(news);
          
          // ✅ CARGAR MÉTRICAS EN PARALELO
          await _loadCommentsCount(i.toString());
          await _loadRatingsCount(i.toString());
          
        } catch (e) {
          if (kDebugMode) {
            print('Error loading news item $i: $e');
          }
        }
      }

      _newsItems = loadedNews;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading news feed: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCommentsCount(String newsId) async {
    try {
      final comments = await _repository.getComments(newsId);
      _commentsCount[newsId] = comments.length;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading comments count for $newsId: $e');
      }
      _commentsCount[newsId] = 0;
    }
  }

  Future<void> _loadRatingsCount(String newsId) async {
    try {
      _ratingsCount[newsId] = await _repository.getRatingsCount(newsId);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading ratings count for $newsId: $e');
      }
      _ratingsCount[newsId] = 0;
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void refreshNews() {
    _loadNews();
  }
}
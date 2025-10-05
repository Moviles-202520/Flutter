import 'package:flutter/foundation.dart';
import '../domain/repositories/news_repository.dart';
import '../domain/models/news_item.dart';

class NewsFeedViewModel extends ChangeNotifier {
  final NewsRepository _repository;
  
  List<NewsItem> _newsItems = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  NewsFeedViewModel(this._repository) {
    _loadNews();
  }

  List<NewsItem> get newsItems => _newsItems;
  bool get isLoading => _isLoading;
  int get currentIndex => _currentIndex;

  Future<void> _loadNews() async {
    try {
      _isLoading = true;
      notifyListeners();

      print('🔄 Cargando noticias...');
      final List<NewsItem> loadedNews = [];
      
      // Cargar noticias del 1 al 10
      for (int i = 1; i <= 10; i++) {
        try {
          final news = await _repository.getNewsDetail(i.toString());
          loadedNews.add(news);
          print('✅ Noticia $i: ${news.title}');
        } catch (e) {
          print('❌ Error con noticia $i: $e');
        }
      }

      _newsItems = loadedNews;
      print('📊 Total cargado: ${_newsItems.length} noticias');
      
    } catch (e) {
      print('❌ Error cargando feed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
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
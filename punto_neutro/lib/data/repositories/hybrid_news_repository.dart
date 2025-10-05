import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/models/news_item.dart';
import '../../domain/models/rating_item.dart';
import '../../domain/models/comment.dart';

class HybridNewsRepository implements NewsRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Connectivity _connectivity = Connectivity();
  
  // ✅ CAJAS CON TIPOS CORRECTOS
  Box<Map<String, dynamic>> get _newsCache => Hive.box<Map<String, dynamic>>('news_cache');
  Box<dynamic> get _commentsCache => Hive.box<dynamic>('comments_cache'); // ✅ DYNAMIC PARA LISTAS
  Box<dynamic> get _ratingsCache => Hive.box<dynamic>('ratings_cache');   // ✅ DYNAMIC PARA MIXED TYPES

  // ✅ VERIFICAR CONEXIÓN
  Future<bool> get _isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<NewsItem> getNewsDetail(String news_item_id) async {
    try {
      // ✅ PRIMERO VER SI ESTÁ EN CACHE
      final cachedNews = _newsCache.get(news_item_id);
      if (cachedNews != null) {
        print('📱 Usando noticia desde cache: $news_item_id');
        return _mapToNewsItem(cachedNews);
      }
      
      // ✅ SI HAY CONEXIÓN, CARGAR DESDE SUPABASE
      if (await _isConnected) {
        print('🌐 Cargando noticia desde Supabase: $news_item_id');
        final response = await _supabase
            .from('news_items')
            .select()
            .eq('news_item_id', int.parse(news_item_id))
            .single()
            .timeout(const Duration(seconds: 10));

        // ✅ CONVERTIR A MAP CORRECTO
        final responseMap = Map<String, dynamic>.from(response);
        
        // ✅ GUARDAR EN CACHE PARA OFFLINE
        await _newsCache.put(news_item_id, responseMap);
        
        return _mapToNewsItem(responseMap);
      } else {
        // ✅ SI NO HAY CONEXIÓN, USAR DATOS DE PRUEBA
        print('📴 Sin conexión, usando datos de prueba');
        return _getFallbackNews(news_item_id);
      }
    } catch (e) {
      print('❌ Error cargando noticia, usando fallback: $e');
      return _getFallbackNews(news_item_id);
    }
  }

  @override
  Future<List<Comment>> getComments(String news_item_id) async {
    try {
      final cacheKey = 'comments_$news_item_id';
      
      // ✅ PRIMERO VER SI ESTÁ EN CACHE
      final cachedComments = _commentsCache.get(cacheKey);
      if (cachedComments != null && cachedComments is List) {
        print('📱 Usando comentarios desde cache: $news_item_id');
        return (cachedComments as List).map<Comment>((comment) {
          final commentMap = Map<String, dynamic>.from(comment);
          return Comment(
            comment_id: commentMap['comment_id']?.toString() ?? '',
            news_item_id: commentMap['news_item_id']?.toString() ?? '',
            user_profile_id: commentMap['user_profile_id']?.toString() ?? '',
            user_name: commentMap['user_name'] as String? ?? 'Usuario',
            content: commentMap['content'] as String? ?? '',
            timestamp: commentMap['timestamp'] != null 
                ? DateTime.parse(commentMap['timestamp'] as String)
                : DateTime.now(),
          );
        }).toList();
      }
      
      // ✅ SI HAY CONEXIÓN, CARGAR DESDE SUPABASE
      if (await _isConnected) {
        print('🌐 Cargando comentarios desde Supabase: $news_item_id');
        final response = await _supabase
            .from('comments')
            .select()
            .eq('news_item_id', int.parse(news_item_id))
            .order('timestamp', ascending: false)
            .timeout(const Duration(seconds: 10));

        // ✅ CONVERTIR A LISTA DE MAPS
        final commentsList = response.map((comment) => Map<String, dynamic>.from(comment)).toList();
        
        // ✅ GUARDAR EN CACHE
        await _commentsCache.put(cacheKey, commentsList);
        
        return response.map<Comment>((comment) {
          return Comment(
            comment_id: comment['comment_id']?.toString() ?? 'unknown',
            news_item_id: comment['news_item_id']?.toString() ?? news_item_id,
            user_profile_id: comment['user_profile_id']?.toString() ?? '1',
            user_name: comment['user_name'] as String? ?? 'Usuario',
            content: comment['content'] as String? ?? '',
            timestamp: comment['timestamp'] != null 
                ? DateTime.parse(comment['timestamp'] as String)
                : DateTime.now(),
          );
        }).toList();
      } else {
        // ✅ SI NO HAY CONEXIÓN, USAR CACHE O DATOS VACÍOS
        print('📴 Sin conexión, sin comentarios en cache');
        return [];
      }
    } catch (e) {
      print('❌ Error cargando comentarios: $e');
      return [];
    }
  }

  @override
  Future<int> getRatingsCount(String news_item_id) async {
    try {
      final cacheKey = 'ratings_count_$news_item_id';
      
      // ✅ PRIMERO VER SI ESTÁ EN CACHE
      final cachedCount = _ratingsCache.get(cacheKey);
      if (cachedCount != null && cachedCount is int) {
        return cachedCount;
      }
      
      // ✅ SI HAY CONEXIÓN, CARGAR DESDE SUPABASE
      if (await _isConnected) {
        final response = await _supabase
            .from('rating_items')
            .select()
            .eq('news_item_id', int.parse(news_item_id))
            .timeout(const Duration(seconds: 10));
        
        final count = response.length;
        
        // ✅ GUARDAR EN CACHE
        await _ratingsCache.put(cacheKey, count);
        
        return count;
      } else {
        // ✅ SI NO HAY CONEXIÓN, USAR CACHE O CERO
        return (cachedCount as int?) ?? 0;
      }
    } catch (e) {
      print('❌ Error contando ratings: $e');
      return 0;
    }
  }

  @override
  Future<void> submitRating(RatingItem rating_item) async {
    try {
      final pendingKey = 'pending_ratings';
      
      if (await _isConnected) {
        // ✅ ENVIAR A SUPABASE SI HAY CONEXIÓN
        await _supabase.from('rating_items').insert({
          'rating_item_id': int.tryParse(rating_item.rating_item_id) ?? DateTime.now().millisecondsSinceEpoch,
          'news_item_id': int.tryParse(rating_item.news_item_id) ?? 1,
          'user_profile_id': int.tryParse(rating_item.user_profile_id) ?? 1,
          'assigned_reliability_score': rating_item.assigned_reliability_score,
          'comment_text': rating_item.comment_text,
          'rating_date': rating_item.rating_date.toIso8601String(),
          'is_completed': rating_item.is_completed,
        });
        print('✅ Rating enviado a Supabase');
      } else {
        // ✅ GUARDAR LOCALMENTE SI NO HAY CONEXIÓN
        final pendingRatings = _ratingsCache.get(pendingKey, defaultValue: <Map<String, dynamic>>[]) as List<Map<String, dynamic>>;
        
        pendingRatings.add({
          'rating_item_id': rating_item.rating_item_id,
          'news_item_id': rating_item.news_item_id,
          'user_profile_id': rating_item.user_profile_id,
          'assigned_reliability_score': rating_item.assigned_reliability_score,
          'comment_text': rating_item.comment_text,
          'rating_date': rating_item.rating_date.toIso8601String(),
          'is_completed': rating_item.is_completed,
        });
        
        await _ratingsCache.put(pendingKey, pendingRatings);
        print('💾 Rating guardado localmente (pendiente de envío)');
      }
    } catch (e) {
      print('❌ Error enviando rating: $e');
    }
  }

  @override
  Future<void> submitComment(Comment comment) async {
    try {
      final pendingKey = 'pending_comments';
      
      if (await _isConnected) {
        // ✅ ENVIAR A SUPABASE SI HAY CONEXIÓN
        await _supabase.from('comments').insert({
          'news_item_id': int.tryParse(comment.news_item_id) ?? 1,
          'user_profile_id': int.tryParse(comment.user_profile_id) ?? 1,
          'user_name': comment.user_name,
          'content': comment.content,
          'timestamp': comment.timestamp.toIso8601String(),
        });
        print('✅ Comentario enviado a Supabase');
      } else {
        // ✅ GUARDAR LOCALMENTE SI NO HAY CONEXIÓN
        final pendingComments = _commentsCache.get(pendingKey, defaultValue: <Map<String, dynamic>>[]) as List<Map<String, dynamic>>;
        
        pendingComments.add({
          'comment_id': 'local_${DateTime.now().millisecondsSinceEpoch}',
          'news_item_id': comment.news_item_id,
          'user_profile_id': comment.user_profile_id,
          'user_name': comment.user_name,
          'content': comment.content,
          'timestamp': comment.timestamp.toIso8601String(),
        });
        
        await _commentsCache.put(pendingKey, pendingComments);
        print('💾 Comentario guardado localmente (pendiente de envío)');
      }
    } catch (e) {
      print('❌ Error guardando comentario: $e');
      rethrow;
    }
  }

  // ✅ SINCRONIZAR DATOS PENDIENTES CUANDO HAY CONEXIÓN
  Future<void> syncPendingData() async {
    if (await _isConnected) {
      await _syncPendingRatings();
      await _syncPendingComments();
    }
  }

  Future<void> _syncPendingRatings() async {
    final pendingKey = 'pending_ratings';
    final pendingRatings = _ratingsCache.get(pendingKey, defaultValue: <Map<String, dynamic>>[]) as List<Map<String, dynamic>>;
    
    if (pendingRatings.isNotEmpty) {
      for (final rating in pendingRatings) {
        try {
          await _supabase.from('rating_items').insert(rating);
        } catch (e) {
          print('Error sincronizando rating: $e');
        }
      }
      await _ratingsCache.put(pendingKey, <Map<String, dynamic>>[]);
      print('✅ Ratings pendientes sincronizados');
    }
  }

  Future<void> _syncPendingComments() async {
    final pendingKey = 'pending_comments';
    final pendingComments = _commentsCache.get(pendingKey, defaultValue: <Map<String, dynamic>>[]) as List<Map<String, dynamic>>;
    
    if (pendingComments.isNotEmpty) {
      for (final comment in pendingComments) {
        try {
          await _supabase.from('comments').insert(comment);
        } catch (e) {
          print('Error sincronizando comentario: $e');
        }
      }
      await _commentsCache.put(pendingKey, <Map<String, dynamic>>[]);
      print('✅ Comentarios pendientes sincronizados');
    }
  }
  NewsItem _mapToNewsItem(Map<String, dynamic> response) {
    return NewsItem(
      news_item_id: (response['news_item_id']?.toString() ?? '0'),
      user_profile_id: (response['user_profile_id']?.toString() ?? '0'),
      title: response['title'] as String? ?? 'Sin título',
      short_description: response['short_description'] as String? ?? '',
      image_url: response['image_url'] as String? ?? '',
      category_id: response['category_id'] as String? ?? '',
      author_type: response['author_type'] as String? ?? '',
      author_institution: response['author_institution'] as String? ?? '',
      days_since: (response['days_since'] as int?) ?? 0,
      comments_count: (response['comments_count'] as int?) ?? 0,
      average_reliability_score: (response['average_reliability_score'] as num?)?.toDouble() ?? 0.5,
      is_fake: response['is_fake'] as bool? ?? false,
      is_verified_source: response['is_verified_source'] as bool? ?? false,
      is_verified_data: response['is_verified_data'] as bool? ?? false,
      is_recognized_author: response['is_recognized_author'] as bool? ?? false,
      is_manipulated: response['is_manipulated'] as bool? ?? false,
      long_description: response['long_description'] as String? ?? '',
      original_source_url: response['original_source_url'] as String? ?? '',
      publication_date: response['publication_date'] != null 
          ? DateTime.parse(response['publication_date'] as String)
          : DateTime.now(),
      added_to_app_date: response['added_to_app_date'] != null
          ? DateTime.parse(response['added_to_app_date'] as String)
          : DateTime.now(),
      total_ratings: (response['total_ratings'] as int?) ?? 0,
    );
  }

  // ✅ DATOS DE PRUEBA PARA OFFLINE
  NewsItem _getFallbackNews(String news_item_id) {
    final fallbackNews = {
      '1': NewsItem(
        news_item_id: '1',
        user_profile_id: '2',
        title: 'NASA Discovers Possible Signs of Life on Europa',
        short_description: 'Ice-covered moon could harbor microbial life.',
        image_url: '',
        category_id: '3',
        author_type: 'Staff Reporter',
        author_institution: 'NASA',
        days_since: 21,
        comments_count: 3,
        average_reliability_score: 0.79,
        is_fake: false,
        is_verified_source: true,
        is_verified_data: true,
        is_recognized_author: true,
        is_manipulated: false,
        long_description: 'NASA scientists report signs of potential biosignatures under Europa\'s icy surface after deep radar scans from the Europa Clipper.',
        original_source_url: 'https://www.nasa.gov/mission_pages/europa/news/signs-of-life',
        publication_date: DateTime(2025, 9, 10),
        added_to_app_date: DateTime(2025, 9, 15),
        total_ratings: 158,
      ),
      '2': NewsItem(
        news_item_id: '2',
        user_profile_id: '1',
        title: 'US Inflation Cools to 2.4 percent in Q2',
        short_description: 'Lower prices for food and energy lead to drop.',
        image_url: '',
        category_id: '4',
        author_type: 'Economist',
        author_institution: 'Bureau of Labor Statistics',
        days_since: 33,
        comments_count: 2,
        average_reliability_score: 0.85,
        is_fake: false,
        is_verified_source: true,
        is_verified_data: true,
        is_recognized_author: true,
        is_manipulated: false,
        long_description: 'The BLS reports inflation cooled in Q2 as core CPI fell due to easing energy and food prices, suggesting stability in consumer prices.',
        original_source_url: 'https://www.bls.gov/news.release/cpi.nr0.htm',
        publication_date: DateTime(2025, 8, 25),
        added_to_app_date: DateTime(2025, 8, 28),
        total_ratings: 42,
      ),
      '3': NewsItem(
        news_item_id: '3',
        user_profile_id: '4',
        title: 'FIFA 2026 World Cup Groups Announced',
        short_description: 'Major teams to face off in tough early matchups.',
        image_url: '',
        category_id: '2',
        author_type: 'Sports Analyst',
        author_institution: 'ESPN',
        days_since: 12,
        comments_count: 5,
        average_reliability_score: 0.92,
        is_fake: false,
        is_verified_source: true,
        is_verified_data: true,
        is_recognized_author: true,
        is_manipulated: false,
        long_description: 'FIFA reveals group stage draw for the 2026 World Cup. Brazil and Germany land in a tough group, raising early excitement.',
        original_source_url: 'https://www.espn.com/soccer/fifa-world-cup/story/_/id/38373692/fifa-2026-group-stage-draw',
        publication_date: DateTime(2025, 9, 22),
        added_to_app_date: DateTime(2025, 9, 25),
        total_ratings: 231,
      ),
      '4': NewsItem(
        news_item_id: '4',
        user_profile_id: '3',
        title: 'Climate Crisis: Antarctic Ice Hits Historic Low',
        short_description: 'Scientists raise alarms over accelerating melt.',
        image_url: '',
        category_id: '6',
        author_type: 'Environmental Journalist',
        author_institution: 'The Guardian',
        days_since: 45,
        comments_count: 8,
        average_reliability_score: 0.88,
        is_fake: false,
        is_verified_source: true,
        is_verified_data: true,
        is_recognized_author: true,
        is_manipulated: false,
        long_description: 'Antarctica\'s winter sea ice has reached its lowest recorded level, raising fears about the rate of global warming.',
        original_source_url: 'https://www.theguardian.com/environment/2025/aug/15/antarctic-ice-low',
        publication_date: DateTime(2025, 8, 15),
        added_to_app_date: DateTime(2025, 8, 20),
        total_ratings: 350,
      ),
      '5': NewsItem(
        news_item_id: '5',
        user_profile_id: '5',
        title: 'Unemployment Rate Rises Slightly to 4.1 percent',
        short_description: 'Job growth slows in September report.',
        image_url: '',
        category_id: '4',
        author_type: 'Business Correspondent',
        author_institution: 'Reuters',
        days_since: 10,
        comments_count: 3,
        average_reliability_score: 0.81,
        is_fake: false,
        is_verified_source: true,
        is_verified_data: true,
        is_recognized_author: true,
        is_manipulated: false,
        long_description: 'The U.S. economy added 120,000 jobs in September, slightly below expectations, pushing unemployment to 4.1%.',
        original_source_url: 'https://www.reuters.com/markets/us/us-job-growth-2025-september',
        publication_date: DateTime(2025, 9, 24),
        added_to_app_date: DateTime(2025, 9, 26),
        total_ratings: 73,
      ),
      '6': NewsItem(
        news_item_id: '6',
        user_profile_id: '1',
        title: 'Deepfake Video of World Leader Sparks Outrage',
        short_description: 'Experts confirm video is AI-generated.',
        image_url: '',
        category_id: '1',
        author_type: 'Cybersecurity Expert',
        author_institution: 'MIT Media Lab',
        days_since: 18,
        comments_count: 12,
        average_reliability_score: 0.33,
        is_fake: true,
        is_verified_source: false,
        is_verified_data: false,
        is_recognized_author: false,
        is_manipulated: true,
        long_description: 'A viral video appearing to show a world leader making controversial remarks was confirmed to be a deepfake, sparking global concern.',
        original_source_url: 'https://www.bbc.com/news/technology-66832010',
        publication_date: DateTime(2025, 9, 17),
        added_to_app_date: DateTime(2025, 9, 20),
        total_ratings: 212,
      ),
      '7': NewsItem(
        news_item_id: '7',
        user_profile_id: '2',
        title: 'Local Farmers Protest New Water Regulations',
        short_description: 'Rural communities push back on restrictions.',
        image_url: '',
        category_id: '8',
        author_type: 'Local Reporter',
        author_institution: 'Daily Herald',
        days_since: 40,
        comments_count: 6,
        average_reliability_score: 0.76,
        is_fake: false,
        is_verified_source: true,
        is_verified_data: true,
        is_recognized_author: false,
        is_manipulated: false,
        long_description: 'In response to new water usage laws, hundreds of farmers in rural Iowa have staged peaceful protests demanding policy revisions.',
        original_source_url: 'https://www.localnewsnetwork.com/iowa-water-law-protest',
        publication_date: DateTime(2025, 8, 20),
        added_to_app_date: DateTime(2025, 8, 23),
        total_ratings: 64,
      ),
      '8': NewsItem(
        news_item_id: '8',
        user_profile_id: '5',
        title: 'Peace Talks Resume Between Armenia and Azerbaijan',
        short_description: 'Ceasefire efforts underway after months of conflict.',
        image_url: '',
        category_id: '7',
        author_type: 'Foreign Affairs Analyst',
        author_institution: 'Al Jazeera',
        days_since: 8,
        comments_count: 4,
        average_reliability_score: 0.89,
        is_fake: false,
        is_verified_source: true,
        is_verified_data: true,
        is_recognized_author: true,
        is_manipulated: false,
        long_description: 'Negotiations facilitated by EU officials aim to stabilize the region following recent escalations along the Nagorno-Karabakh border.',
        original_source_url: 'https://www.aljazeera.com/news/2025/9/26/armenia-azerbaijan-talks',
        publication_date: DateTime(2025, 9, 26),
        added_to_app_date: DateTime(2025, 9, 28),
        total_ratings: 87,
      ),
      '9': NewsItem(
        news_item_id: '9',
        user_profile_id: '3',
        title: 'Meta Launches ‘MindLink’: Brain-Computer Interface',
        short_description: 'New tech lets users type with thoughts.',
        image_url: '',
        category_id: '3',
        author_type: 'Tech Reporter',
        author_institution: 'TechCrunch',
        days_since: 25,
        comments_count: 7,
        average_reliability_score: 0.84,
        is_fake: false,
        is_verified_source: true,
        is_verified_data: true,
        is_recognized_author: true,
        is_manipulated: false,
        long_description: 'Meta has unveiled "MindLink," a wearable device that allows users to interact with digital platforms using neural signals.',
        original_source_url: 'https://techcrunch.com/2025/09/05/meta-mindlink-launch',
        publication_date: DateTime(2025, 9, 5),
        added_to_app_date: DateTime(2025, 9, 7),
        total_ratings: 103,
      ),
      '10': NewsItem(
        news_item_id: '10',
        user_profile_id: '4',
        title: 'Fake COVID-19 Cure Article Circulates on WhatsApp',
        short_description: 'WHO warns against dangerous misinformation.',
        image_url: '',
        category_id: '1',
        author_type: 'Health Misinformation Analyst',
        author_institution: 'World Health Organization',
        days_since: 27,
        comments_count: 9,
        average_reliability_score: 0.26,
        is_fake: true,
        is_verified_source: false,
        is_verified_data: false,
        is_recognized_author: true,
        is_manipulated: true,
        long_description: 'A widely shared message claiming a herbal mixture can cure COVID-19 has been flagged by the WHO as dangerous misinformation.',
        original_source_url: 'https://www.who.int/news-room/articles/2025/09/03/fake-covid-remedy-debunked',
        publication_date: DateTime(2025, 9, 3),
        added_to_app_date: DateTime(2025, 9, 6),
        total_ratings: 188,
      ),
    };
    
    return fallbackNews[news_item_id] ?? fallbackNews['1']!;
  }
}
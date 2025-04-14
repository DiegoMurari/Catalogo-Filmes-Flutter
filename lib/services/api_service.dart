import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class ApiService {
  static const String _apiKey = 'fa76dd2960151f8439bdea6dfe0160b9';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-BR&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Erro ao carregar filmes populares');
    }
  }

  static Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&language=pt-BR&query=$query&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Erro ao buscar filmes');
    }
  }

  static Future<Movie> fetchMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&language=pt-BR'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Erro ao carregar detalhes do filme');
    }
  }
}

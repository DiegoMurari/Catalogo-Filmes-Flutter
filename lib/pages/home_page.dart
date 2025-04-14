import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomePage({required this.toggleTheme, required this.isDark, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Movie> _movies = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  String _searchQuery = '';

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMovies();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 &&
          !_isLoadingMore) {
        _currentPage++;
        _fetchMovies();
      }
    });
  }

  Future<void> _fetchMovies() async {
    setState(() {
      _isLoadingMore = true;
    });
    List<Movie> fetched;
    if (_searchQuery.isEmpty) {
      fetched = await ApiService.fetchPopularMovies(page: _currentPage);
    } else {
      fetched = await ApiService.searchMovies(_searchQuery, page: _currentPage);
    }
    setState(() {
      _movies.addAll(fetched);
      _isLoadingMore = false;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
      _movies.clear();
    });
    _fetchMovies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Centralizar a grid em telas largas
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Catálogo de Filmes'),
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: _onSearch,
              decoration: InputDecoration(
                hintText: 'Buscar filmes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _movies.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _movies.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final movie = _movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: movie,
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

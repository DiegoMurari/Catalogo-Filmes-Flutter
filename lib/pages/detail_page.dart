import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';
import '../services/api_service.dart';

class DetailsPage extends StatefulWidget {
  final Movie movie;

  const DetailsPage({super.key, required this.movie});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Movie> _movieDetails;
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [];
  bool _liked = false;
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _movieDetails = ApiService.fetchMovieDetails(widget.movie.id);
    // Inicializando o YoutubePlayerController com um vídeo exemplo.
    // Você pode modificar para buscar o trailer correto via API.
    _youtubeController = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ', // Exemplo: Rickroll (substitua pelo trailer real se disponível)
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment(String text) async {
    if (text.trim().isEmpty) return;
    // Adiciona localmente
    setState(() {
      _comments.add({'text': text.trim(), 'likes': 0});
      _commentController.clear();
    });
    // Persistência no Firebase Firestore (comentários por filme)
    await FirebaseFirestore.instance.collection('comments').add({
      'movieId': widget.movie.id,
      'text': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _likeComment(int index) {
    setState(() {
      _comments[index]['likes']++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: FutureBuilder<Movie>(
        future: _movieDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movie = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem principal
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        height: 400,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Detalhes do filme
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Nota: ${movie.voteAverage}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Lançamento: ${movie.releaseDate}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Duração: ${movie.runtime} min', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Gêneros: ${movie.genres.join(', ')}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  // Sinopse
                  Text(
                    'Sinopse',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(movie.overview, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  // Trailer usando YoutubePlayer
                  Text(
                    'Trailer',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  YoutubePlayer(
                    controller: _youtubeController,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.deepPurple,
                  ),
                  const SizedBox(height: 24),
                  // Seção de curtidas e comentários do filme
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _liked ? Icons.favorite : Icons.favorite_border,
                          color: _liked ? Colors.red : null,
                        ),
                        onPressed: () {
                          setState(() {
                            _liked = !_liked;
                          });
                        },
                      ),
                      Text(_liked ? '1 curtida' : '0 curtidas'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Comentários
                  Text(
                    'Comentários',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(comment['text']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${comment['likes']}'),
                              IconButton(
                                icon: const Icon(Icons.thumb_up),
                                onPressed: () => _likeComment(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  // Campo para adicionar comentário
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Adicionar comentário',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _addComment(_commentController.text),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

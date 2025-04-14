class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final List<String> genres; // Assumindo que os gêneros virão como lista de String

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Se os gêneros vierem como lista de objetos, você pode ajustar
    // Aqui assumimos que já vem como lista de strings ou a transformamos:
    List<String> genreList = [];
    if (json['genres'] is List) {
      genreList = (json['genres'] as List).map((g) {
        // Se g for um mapa, extraia o nome; se for string, use diretamente.
        if (g is Map) {
          return g['name'] as String;
        } else {
          return g.toString();
        }
      }).toList();
    }
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? 0,
      genres: genreList,
    );
  }
}

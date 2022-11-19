class Music {
  final String uid;
  String title;
  String artist;
  String album;
  String url;
  String path;

  Music({
    required this.uid,
    required this.title,
    required this.artist,
    required this.album,
    required this.url,
    required this.path,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      uid: json['uid'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      url: json['url'],
      path: json['path'],
    );
  }
}

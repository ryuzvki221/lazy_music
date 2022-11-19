import 'package:lazy_music/model/music.dart';

class MusicService {
  List<Music> getMusicList() {
    return [
      Music(
        uid: '01',
        title: 'DAYÉ',
        artist: 'GIMS',
        album: 'L\'EMPIRE DE MÉROÉ',
        url: 'https://fkn.loceyan.com/wp-content/uploads/2022/11/01-DAYE.mp3',
        path: 'assets/images/cover.jpg',
      ),
      Music(
        uid: '02',
        title: 'PRENDS MA MAIN',
        artist: 'GIMS',
        album: 'L\'EMPIRE DE MÉROÉ',
        url: 'https://fkn.loceyan.com/wp-content/uploads/2022/11/02-PRENDS-MA-MAIN.mp3',
        path: 'assets/images/cover.jpg',
      ),
      Music(
        uid: '03',
        title: 'MA BÉBÉ',
        artist: 'GIMS',
        album: 'L\'EMPIRE DE MÉROÉ',
        url: 'https://fkn.loceyan.com/wp-content/uploads/2022/11/03-MA-BEBE.mp3',
        path: 'assets/images/cover.jpg',
      ),
      Music(
        uid: '04',
        title: 'MG',
        artist: 'GIMS',
        album: 'L\'EMPIRE DE MÉROÉ',
        url: 'https://fkn.loceyan.com/wp-content/uploads/2022/11/04-MG.mp3',
        path: 'assets/images/cover.jpg',
      ),
      Music(
        uid: '05',
        title: 'ENFANTS DE LA PATRIE',
        artist: 'GIMS',
        album: 'L\'EMPIRE DE MÉROÉ',
        url: 'https://fkn.loceyan.com/wp-content/uploads/2022/11/05-ENFANTS-DE-LA-PATRIE-feat.-Naps.mp3',
        path: 'assets/images/cover.jpg',
      ),
    ];
  }
}

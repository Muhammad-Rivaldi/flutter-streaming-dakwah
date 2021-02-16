import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http; //IMPORT HTTP LIBRARY
import 'dart:convert';

//CLASS INI UNTUK MENDEFINISIKAN SEPERTI APA FORMAT DATA YANG DIINGINKAN
class VideoModel {
  //DEFINISIKAN VARIABLE APA SAJA YANG DIBUTUHKAN
  final String videoId;
  final String title;
  final String channelId;
  final String channelTitle;
  final String image;

  //BUAT CONSTRUCTOR, AGAR KETIKA CLASS INI DIGUNAKAN MAKA WAJIB MENGIRIMKAN DATA YANG DIMINTA DI CONSTRUCTOR
  VideoModel({
    @required this.videoId,
    @required this.title,
    @required this.channelId,
    @required this.channelTitle,
    @required this.image,
  });

  //FORMATTING DATA MENJADI FORMAT YANG DIINGINKAN
  //MENGGUNAKAN METHOD fromJson, DIMANA EXPECT DATANYA ADALAH MAP DENGAN KEY STRING DAN VALUE DYNAMIC
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    //UBAH FORMAT DATANYA SESUAI FORMAT YANG DIMINTA PADA CONSTRUCTOR
    return VideoModel(
      videoId: json['id']['videoId'],
      title: json['snippet']['title'],
      channelId: json['snippet']['channelId'],
      channelTitle: json['snippet']['channelTitle'],
      image: json['snippet']['thumbnails']['high']['url'],
    );
  }
}

//CLASS INI SEBAGAI STATE MANAGEMENT
class VideoProvider with ChangeNotifier {
  List<VideoModel> _items =
      []; //DEFINISIKAN VARIABLE UNTUK MENAMPUNG DATA VIDEO

  //KARENA VARIABLE DIATAS ADA PRIVATE, MAKA KITA BUAT GETTER AGAR DAPAT DIAKSES DARI LUAR CLASS INI
  List<VideoModel> get items {
    return [..._items];
  }

  //BUAT FUNGSI UNTUK MENGAMBIL DATA DARI API YOUTUBE
  Future<void> getVideo(String requestKeyword) async {
    final keyword = 'ustadz ' +
        requestKeyword; //DIMANA KEYWORDNYA MENGGUNAKAN PREFIX USTADZ SEHINGGA HANYA AKAN MENGAMBIL DATA YANG TERKAIT DENGAN USTADZ
    final apiToken =
        'AIzaSyB5mjJiX2gDhumyOxrhqFw6kTbHjpAtMmU'; //MASUKKAN API TOKEN YANG KAMU DAPATKAN DARI PROSES SEBELUMNYA

    //ENDPOINT API YOUTUBE UNTUK MENGAMBIL VIDEO-NYA BERDASARKAN PENCARIAN DAN EVENTYPE = LIVE
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&eventType=live&relevanceLanguage=id&maxResults=25&q=$keyword&type=video&key=$apiToken';
    final response = await http.get(url); //KIRIM REQUEST
    final extractData =
        json.decode(response.body)['items']; //DECODE JSON YANG DITERIMA

    //JIKA DIA NULL, MAKA HENTIKAN PROSESNYA
    if (extractData == null) {
      return;
    }

    //JIKA TIDAK MAKA ASSIGN DATA NYA KE DALAM VARIABLE _items
    //DENGAN FORMAT DATA MENGGUNAKAN fromJson()
    _items =
        extractData.map<VideoModel>((i) => VideoModel.fromJson(i)).toList();
    notifyListeners(); //INFORMASIKAN JIKA TERJADI PERUBAHAN DATA
  }

  //METHOD UNTUK MENGAMBIL DATA VIDEO BERDASARKAN VIDEOID, METHOD INI DIGUNAKAN PADA SCREEN DETAIL NANTINYA
  VideoModel findVideo(String videoId) {
    return _items.firstWhere((q) => q.videoId == videoId);
  }
}

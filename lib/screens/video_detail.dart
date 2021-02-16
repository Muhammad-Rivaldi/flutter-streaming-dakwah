import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart'; //LOAD LIBRARY WEBVIEW UNTUK MENG-EMBED VIDEO

import '../models/video_model.dart'; //IMPORT MODEL PROVIDER

class VideoDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments
        as String; //TERIMA ARGUMEN YANG DIKIRIMKAN
    final data = Provider.of<VideoProvider>(context, listen: false).findVideo(
        id); //CARI VIDEO TERKAIT PADA VARIABLE _ITEMS MENGGUNAKAN FUNGSI findVideo() DARI MODEL YANG KITA PUNYA

    return Center(
      //GUNAKAN WIDGET WEBVIEW
      child: WebviewScaffold(
        //DAN EMBED VIDEONYA, DIMANA ID VIDEO BERDASARKAN DATA DARI HASIL PENCARIAN
        //SEBENARNYA KITA BISA LANGSUNG MENGGUNAKAN ID DARI ARGUMEN, TAPI BIAR LEBIH PANJANG CODENYA JADI KITA GUNAKAN PENCARIAN HAHAHA
        url: "https://www.youtube.com/embed/${data.videoId}",
      ),
    );
  }
}

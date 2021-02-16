import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/video_model.dart'; //IMPORT MODEL PROVIDER YANG BERFUNGSI SEBAGAI STATE MANAGEMENT

import './screens/video_list.dart'; //SCREEN INI UNTUK MENAMPILKAN LIST VIDEO
import './screens/video_detail.dart'; //SCREEN INI UNTUK MENJALANKAN VIDEO YANG DIPILIH (TAPI AKAN DIKERJAKAN PADA BAGIAN AKHIR ARTIKEL)

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => VideoProvider(),
        ) //DEFINISIKAN STATE MANAGEMENT AGAR DAPAT DIGUNAKAN DISEMUA SCREEN / PAGE
      ],
      child: MaterialApp(
        title: 'tutorial_aplikasi_streaming_video',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home:
            VideoList(), //SCREEN PERTAMA YANG DILOAD KETIKA APLIKASI DIJALANKAN ADALAH LIST VIDEO
        routes: {
          '/detail': (ctx) =>
              VideoDetail() //DEFINISIKAN ROUTING UNTUK MELIHAT DETAIL VIDEO
        },
      ),
    );
  }
}

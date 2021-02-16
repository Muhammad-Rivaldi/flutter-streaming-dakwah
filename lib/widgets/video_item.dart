import 'package:flutter/material.dart';

class VideoItem extends StatelessWidget {
  //DEFINISIKAN VARIABLE APA SAJA YANG DIBUTUHKAN
  final String videoId;
  final String title;
  final String image;
  final String channelTitle;

  //BUAT CONSTRUCTOR UNTUK MENERIMA / MEMINTA DATA DARI YANG MENGGUNAKAN CLASS INI
  VideoItem(this.videoId, this.title, this.channelTitle, this.image);

  //METHOD YANG AKAN MENG-HANDLE KETIKA CARD DITAP
  void _detailScreen(BuildContext context) {
    //FUNGSI UNTUK BERPINDAH KE SCREEN /DETAIL DAN MENGIRIMKAN VIDEOID SEBAGAI PARAMETER
    Navigator.of(context).pushNamed('/detail', arguments: videoId);
  }

  @override
  Widget build(BuildContext context) {
    //MENGGUNAKAN WIDGET INKWEEL UNTUK MENDETEKSI ONTAP
    return InkWell(
      onTap: () => _detailScreen(context), //ONTAPNYA MENJALANKAN METHOD DIATAS
      child: Card(
        //SET SHAPE CARDNYA MENGGUNAKAN BORDER RADIUS AGAR SEDIKIT MELENGKUNG
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4, //BUAT SHADOWNYA 4
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            //CHILD CARD YANG PERTAMA KITA GUNAKAN STACK AGAR DAPAT MENGATUR POSISI YANG DIINGINKAN DARI CHILDREN YANG DIMILIKINYA
            Stack(
              children: <Widget>[
                //UNTUK MEMBUAT RECTANGLE DENGAN SETIAP SISINYA DI CUSTOM MENGGUNAKAN BORDER RADIUS
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  //CHILDNYA KITA TAMPILKAN IMAGE DARI VIDEO TERKAIT (THUMBNAIL)
                  child: Image.network(
                    image, //IMAGE URLNYA KITA DAPATKAN DARI VARIABLE IMAGE
                    height: 200,
                    width: double
                        .infinity, //WIDTHNYA DISET SELUAS MUNGKIN YG BISA DIJANGKAU
                    fit: BoxFit.cover,
                  ),
                ),
                //WIDGET INI DIGUNAKAN UNTUK MENGATUR POSISI DARI WIDGET YANG DIAPIT OLEHNYA
                Positioned(
                  bottom: 20, //MISALNYA KITA SET 20 DARI BAWAH STACK
                  right: 15, //DAN DARI KANAN SEBESAR 15
                  //ADAPUN WIDGET YANG DI-SET POSISINYA ADALAH SEBUAH CONTAINER
                  child: Container(
                    //YANG MEMILIKI LEBAR SEBESAR 300
                    width: 300,
                    color: Colors.black54, //DAN WARNA HITAM AGAK TRANSPARAN
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    //DAN ISI DARI CONTAINER ITU ADALAH SEBUAH TEXT UNTUK MENAMPILKAN JUDUL VIDEO
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
            //CHILD CARD YANG KEDUA ADALAH UNTUK MENAMPILKAN NAMA CHANNEL DARI VIDEO TERKAIT
            Padding(
              padding: EdgeInsets.all(10),
              //KITA BUAT JADI ROW
              child: Row(
                children: <Widget>[
                  //POSISI KIRI MENAMPILKAN ICON
                  IconTheme(
                    data: IconThemeData(color: Colors.blueGrey),
                    child: Icon(Icons.shop_two),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  //DAN SETLAHNYA ADALAH NAMA CHANNEL
                  Expanded(
                      child: Text(
                    'Channel: $channelTitle',
                    style: TextStyle(color: Colors.blueGrey),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

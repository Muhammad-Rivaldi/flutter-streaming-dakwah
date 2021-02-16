import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/video_item.dart'; //IMPORT WIDGET VideoItem (WIGET INI UNTUK MENAMPILKAN LIST VIDEO)
import '../models/video_model.dart'; //IMPORT MODEL YANG DIBUAT SEBELUMNYA

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  bool loading =
      false; //VARIABLE YANG AKAN DIGUNAKAN UNTUK MENAMPILKAN LOADING ATAU TIDAK
  bool isSearch =
      false; //VARIABLE YG AKAN DIGUNAKAN KETIKA ICON CARI/CANCEL DITEKAN PADA APPBAR
  TextEditingController _searchController =
      TextEditingController(); //CONTROLLER YANG AKAN MENG-HANDLE TEXTFIELD PENCARIAN

  //KETIKA SCREEN INI DI-LOAD
  @override
  void initState() {
    //MAKA KITA TUNDA 0 SECOND AGAR PROVIDER BISA DIGUNAKAN
    Future.delayed(Duration.zero).then((_) {
      //SET LOADING JADI TRUE UNTUK MENAMPILKAN LOADING INDICATOR
      setState(() {
        loading = true;
      });

      //JALANKAN METHOD getVideo() DARI MODEL VIDEOPROVIDER DAN KIRIMKAN PARAMETER STRING DARI VALUE CONTROLLER TEXTFIELD PENCARIAN
      Provider.of<VideoProvider>(context, listen: false)
          .getVideo(_searchController.text)
          .then((_) {
        //APABILA BERHASIL, SET LOADING JADI FALSE
        setState(() {
          loading = false;
        });
      });
    });
    super.initState();
  }

  //BUAT PRIVATE METHOD YANG AKAN DIGUNAKAN UNTUK PENCARIAN DAN PULL TO REFRESH (KETIKA HALAMAN DITARIK KEBAWAH
  //ADAPUN PENJELASAN YANG ADA DI DALAMNYA SAMA SAJA
  Future<void> _refreshData() async {
    setState(() {
      loading = true;
    });

    await Provider.of<VideoProvider>(context, listen: false)
        .getVideo(_searchController.text)
        .then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //JIKA ISSEARCH TRUE MAKA TEXTFIELD DITAMPILKAN
        title: isSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Cari...',
                ),
                onSubmitted: (_) {
                  //KETIKA DISUBMIT MAKA AKAN MENJALANKAN FUNGSI _refreshData()
                  _refreshData();
                  //DAN FOCUS TEXTFIELDNYA DIHILANGKAN
                  FocusScope.of(context).unfocus();
                },
                //SAMA SAJA FUNGSINYA HANYA BEDA EVENT
                onEditingComplete: () {
                  _refreshData();
                  FocusScope.of(context).unfocus();
                },
              )
            : Text(
                'Dakwah Live Streaming'), //JIKA ISSEARCH FALSE MAKA TEXT INI AKAN DITAMPILKAN
        actions: <Widget>[
          IconButton(
            //JIKA ISSEARCH TRUE MAKA ICON CANCEL DITAMPILKAN, SELAIN ITU ICON SEARCH
            icon: Icon(isSearch ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                isSearch =
                    !isSearch; //KETIKA ICONNYA DITEKAN, MAKA VALUE ISSEARCH DIUBAH
                _searchController.clear(); //VALUE DARI TEXTFIELD DIHAPUS
              });
            },
          )
        ],
      ),
      //JIKA LOADING TRUE
      body: loading
          ? Center(
              //MAKA PROGRESS INDICATOR AKAN DIRENDER
              child: CircularProgressIndicator(),
            )
          //SELAIN ITU AKAN MENAMPILKAN DATA VIDEO
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
              //REFRESH INDICATOR AKAN BERJALAN KETIKA PADA POSISI PALING ATAS SCREEN KEMUDIAN DITARIK UNTUK ME-REFRESH DATA
              child: RefreshIndicator(
                //KETIKA PROSES TERSEBUT BERLANGSUNG, MAKA METHOD _refreshData DIJALANKAN
                onRefresh: _refreshData,
                //CONSUMER BERFUNGSI UNTUK MENGAMBIL DATA DARI STATE, SEHINGGA HANYA WIDGET YANG DIAPITNYA SAJA YANG DI-RENDER
                child: Consumer<VideoProvider>(
                  //LOOPING DATANYA MENGGUNAKAN LISTVIEW BUILDER
                  builder: (ctx, data, _) => ListView.builder(
                    //LOOPING NYA AKAN DILAKUKAN SEBANYAK JUMLAH DATANYA
                    itemCount: data.items.length,
                    //TAMPILAN DATANYA AKAN DI-HANDLE OLEH FILE video_item.dart
                    //MAKA DATA YANG PERLU DITAMPILKAN AKAN DKIRIMKAN KE FILE TERSEBUT
                    itemBuilder: (ctx, i) => VideoItem(
                      data.items[i].videoId,
                      data.items[i].title,
                      data.items[i].channelTitle,
                      data.items[i].image,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

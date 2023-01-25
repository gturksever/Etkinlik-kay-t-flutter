import 'package:flutter/material.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/etkinlikekle_page.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/etkinlikler_page.dart';
import 'package:flutter_etkinlik_kayit_gorkem/utils/databasehelper.dart';

class EtkinlikEkleSilPage extends StatefulWidget {
  EtkinlikEkleSilPage(
      {super.key, required this.kullanici, required this.etkinlikler});
  Map<String, dynamic> kullanici;
  List<Map<String, dynamic>> etkinlikler;

  @override
  State<EtkinlikEkleSilPage> createState() => _EtkinlikEkleSilPageState();
}

class _EtkinlikEkleSilPageState extends State<EtkinlikEkleSilPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> etkinlikler = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    etkinlikler = widget.etkinlikler;
  }

  @override
  Widget build(BuildContext context) {
    etkinlikleriGetir();
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EtkinliklerPage(
                  kullanici: widget.kullanici, etkinlikler: etkinlikler),
            ));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Etkinlik Ekle - Sil Sayfası'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EtkinlikEklePage(
                          kullanici: widget.kullanici,
                          etkinlikler: etkinlikler,
                        ),
                      ));
                },
                child: Text('Etkinlik Ekle')),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: etkinlikler.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      trailing: IconButton(
                          onPressed: () async {
                            await _databaseHelper
                                .etkinlikSil(etkinlikler[index])
                                .then((value) => etkinlikleriGetir());
                          },
                          icon: Icon(Icons.delete)),
                      title: Text(etkinlikler[index]['etkinlikadi']),
                      subtitle: Text(etkinlikler[index]['tarih'] +
                          ' - ' +
                          etkinlikler[index]['saat']),
                    ),
                    Divider()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void etkinlikleriGetir() async {
    await _databaseHelper
        .etkinlikleriGetir(widget.kullanici['tcno'])
        .then((value) {
      setState(() {
        etkinlikler = value;
      });
    });
  }
}

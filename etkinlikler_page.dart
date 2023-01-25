import 'package:flutter/material.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/home_page.dart';
import 'package:flutter_etkinlik_kayit_gorkem/utils/databasehelper.dart';

import 'etkinlikeklesil_page.dart';

class EtkinliklerPage extends StatefulWidget {
  EtkinliklerPage(
      {super.key, required this.kullanici, required this.etkinlikler});
  Map<String, dynamic> kullanici;
  List<Map<String, dynamic>> etkinlikler;

  @override
  State<EtkinliklerPage> createState() => _EtkinliklerPageState();
}

class _EtkinliklerPageState extends State<EtkinliklerPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> etkinlikler = [];
  Map<String, dynamic> gecerlietkinlik = {};
  double sliderValue = 0;
  Duration kalanzaman = Duration();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    etkinlikleriGetir();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitDays =
        (duration.inHours / 24).toInt().toString().padLeft(2, "0");
    String twoDigitHours = (duration.inHours % 24).toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitDays:$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    if (gecerlietkinlik.isNotEmpty) {
      String tarih = gecerlietkinlik['tarih'];
      List<String> list = tarih.split('/');
      var gecerliEtkinlikTarih = DateTime.parse(
          '${list[2]}-${list[1].length == 1 ? list[1].padLeft(2, '0') : list[1]}-${list[0]} ' +
              gecerlietkinlik['saat']);
      kalanzaman = gecerliEtkinlikTarih.difference(DateTime.now());
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(kullanici: widget.kullanici),
            ));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Etkinlikler'),
        ),
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EtkinlikEkleSilPage(
                            kullanici: widget.kullanici,
                            etkinlikler: etkinlikler,
                          ),
                        ));
                  },
                  child: Text('Etkinlik Ekle - Sil')),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Slider(
              max: etkinlikler.isNotEmpty
                  ? etkinlikler.length.toDouble() - 1
                  : 1,
              divisions: etkinlikler.isEmpty
                  ? null
                  : etkinlikler.length > 1
                      ? etkinlikler.length - 1
                      : etkinlikler.length,
              value: sliderValue,
              onChanged: etkinlikler.isNotEmpty
                  ? (value) {
                      setState(() {
                        sliderValue = value;
                        gecerlietkinlik = etkinlikler[sliderValue.toInt()];
                      });
                    }
                  : null,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            gecerlietkinlik.isNotEmpty
                ? Column(
                    children: [
                      Divider(
                        color: Colors.black,
                        height: 0,
                        thickness: 1,
                      ),
                      ListTile(
                        trailing: Column(
                          children: [
                            Text('DD:HH:MM:SS'),
                            Text(_printDuration(kalanzaman)),
                          ],
                        ),
                        title: Text(gecerlietkinlik['etkinlikadi']),
                        subtitle: Text(gecerlietkinlik['tarih'] +
                            ' - ' +
                            gecerlietkinlik['saat']),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  void etkinlikleriGetir() async {
    await _databaseHelper
        .etkinlikleriGetir(widget.kullanici['tcno'])
        .then((value) {
      if (etkinlikler.length != value.length) {
        setState(() {
          etkinlikler = value;
          if (etkinlikler.isNotEmpty) {
            gecerlietkinlik = etkinlikler.first;
          }
        });
      }
    });
  }
}

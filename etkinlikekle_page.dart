import 'package:flutter/material.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/etkinlikeklesil_page.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/etkinlikler_page.dart';
import 'package:flutter_etkinlik_kayit_gorkem/utils/databasehelper.dart';

class EtkinlikEklePage extends StatefulWidget {
  EtkinlikEklePage(
      {super.key, required this.kullanici, required this.etkinlikler});
  Map<String, dynamic> kullanici;
  List<Map<String, dynamic>> etkinlikler;

  @override
  State<EtkinlikEklePage> createState() => _EtkinlikEklePageState();
}

class _EtkinlikEklePageState extends State<EtkinlikEklePage> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController _etkinlikadiController = TextEditingController();
  final TextEditingController _etkinliktarihiController =
      TextEditingController();
  final TextEditingController _etkinliksaatiController =
      TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late List<Map<String, dynamic>> etkinlikler;
  @override
  void initState() {
    super.initState();
    etkinlikler = widget.etkinlikler;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Etkinlik Ekle'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextFormField(
                controller: _etkinlikadiController,
                decoration: InputDecoration(
                    label: Text('*Etkinlik Adı'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Boş bırakılamaz';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextFormField(
                controller: _etkinliktarihiController,
                readOnly: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.date_range),
                    label: Text('*Etkinlik Tarihi'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 3))
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        _etkinliktarihiController.text =
                            '${value.day}/${value.month}/${value.year}';
                      });
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tarih boş bırakılamaz.';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextFormField(
                controller: _etkinliksaatiController,
                readOnly: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.timelapse_outlined),
                    label: Text('*Etkinlik Saati'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                onTap: () {
                  showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: 12, minute: 0))
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        _etkinliksaatiController.text = value.format(context);
                      });
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Saat boş bırakılamaz.';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          etkinlikEkle().then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EtkinlikEkleSilPage(
                                      kullanici: widget.kullanici,
                                      etkinlikler: etkinlikler),
                                ));
                          });
                        }
                      },
                      child: Text('Kaydet')))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> etkinlikEkle() async {
    Map<String, dynamic> etkinlik = {
      'tcno': widget.kullanici['tcno'],
      'etkinlikadi': _etkinlikadiController.text.trim(),
      'tarih': _etkinliktarihiController.text.trim(),
      'saat': _etkinliksaatiController.text.trim()
    };
    await _databaseHelper.etkinlikEkle(etkinlik);
    await _databaseHelper
        .etkinlikleriGetir(widget.kullanici['tcno'])
        .then((value) {
      setState(() {
        etkinlikler = value;
      });
    });
  }
}

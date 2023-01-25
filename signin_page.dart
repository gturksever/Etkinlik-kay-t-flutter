import 'package:flutter/material.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/home_page.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/login_page.dart';
import 'package:flutter_etkinlik_kayit_gorkem/utils/databasehelper.dart';

enum MedeniDurum { evli, bekar }

class SignInPage extends StatefulWidget {
  SignInPage({super.key, required this.kullanici});
  Map<String, dynamic>? kullanici;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _tcnoController = TextEditingController();
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _soyisimController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _dogumtarihiController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();
  DateTime? dogumtarihi;
  MedeniDurum medeniDurum = MedeniDurum.bekar;
  bool yazilim = false, donanim = false, yapayzeka = false, ehliyet = false;
  Map<String, dynamic>? duzenlenmiskullanici;

  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.kullanici != null) {
      _tcnoController.text = widget.kullanici!['tcno'];
      _isimController.text = widget.kullanici!['ad'];
      _soyisimController.text = widget.kullanici!['soyad'];
      _sifreController.text = widget.kullanici!['sifre'];
      _dogumtarihiController.text = widget.kullanici!['dogumtarihi'].toString();
      medeniDurum = widget.kullanici!['medenihali'] == 'MedeniDurum.bekar'
          ? MedeniDurum.bekar
          : MedeniDurum.evli;
      yazilim =
          widget.kullanici!['ilgialanlari'].toString().contains('yazilim');
      donanim =
          widget.kullanici!['ilgialanlari'].toString().contains('donanim');
      yapayzeka =
          widget.kullanici!['ilgialanlari'].toString().contains('yapayzeka');
      ehliyet = widget.kullanici!['ehliyetbilgisi'].toString() == 'true';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.kullanici != null ? 'Kayıt Güncelle' : 'Kayıt Ol Sayfası'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.05,
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: _tcnoController,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: Text('*TC No'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'TC No boş bırakılamaz.';
                    } else if (value.length != 11) {
                      return 'TC No tam giriniz.';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextFormField(
                controller: _isimController,
                decoration: InputDecoration(
                    label: Text('*İsim'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'İsim boş bırakılamaz';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextFormField(
                controller: _soyisimController,
                decoration: InputDecoration(
                    label: Text('*Soyisim'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Soyisim boş bırakılamaz';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextFormField(
                controller: _sifreController,
                decoration: InputDecoration(
                    label: Text('*Şifre'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Şifre boş bırakılamaz';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextFormField(
                controller: _dogumtarihiController,
                readOnly: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.date_range),
                    label: Text('*Doğum Tarihi'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now())
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        dogumtarihi = value;
                        debugPrint(dogumtarihi.toString());
                        _dogumtarihiController.text =
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
              Text(
                'Medeni Hali',
                style: TextStyle(fontSize: 20),
              ),
              Divider(
                height: 0,
                thickness: 1,
                color: Colors.black,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: ListTile(
                      title: const Text('Evli'),
                      leading: Radio(
                        value: MedeniDurum.evli,
                        groupValue: medeniDurum,
                        onChanged: (MedeniDurum? value) {
                          setState(() {
                            medeniDurum = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: ListTile(
                      title: const Text('Bekar'),
                      leading: Radio(
                        value: MedeniDurum.bekar,
                        groupValue: medeniDurum,
                        onChanged: (MedeniDurum? value) {
                          setState(() {
                            medeniDurum = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'İlgi Alanları',
                style: TextStyle(fontSize: 20),
              ),
              Divider(
                height: 0,
                thickness: 1,
                color: Colors.black,
              ),
              CheckboxListTile(
                title: Text('Yazılım'),
                value: yazilim,
                onChanged: (bool? value) {
                  setState(() {
                    yazilim = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Donanım'),
                value: donanim,
                onChanged: (bool? value) {
                  setState(() {
                    donanim = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Yapay Zeka'),
                value: yapayzeka,
                onChanged: (bool? value) {
                  setState(() {
                    yapayzeka = value!;
                  });
                },
              ),
              Text(
                'Ehliyet Bilgisi',
                style: TextStyle(fontSize: 20),
              ),
              Divider(
                height: 0,
                thickness: 1,
                color: Colors.black,
              ),
              SwitchListTile(
                title: Text('Ehliyet'),
                value: ehliyet,
                onChanged: (bool value) {
                  setState(() {
                    ehliyet = value;
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      if (!donanim && !yazilim && !yapayzeka) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Lütfen ilgi alanı seçimi yapın.')));
                      } else {
                        kayitOlusturveyaDuzenle().then((value) {
                          if (widget.kullanici == null) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                                (route) => false);
                          } else {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      kullanici: duzenlenmiskullanici!),
                                ),
                                (route) => false);
                          }
                        });
                      }
                    }
                  },
                  child:
                      Text(widget.kullanici != null ? 'Güncelle' : 'Kayıt Ol'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> kayitOlusturveyaDuzenle() async {
    List<bool> ilgialanilist = [yazilim, donanim, yapayzeka];
    List<String> ilgialaniliststr = ['yazilim', 'donanim', 'yapayzeka'];
    List<String> ilgialanlarilistesi = [];
    for (var i = 0; i < ilgialanilist.length; i++) {
      if (ilgialanilist[i]) {
        ilgialanlarilistesi.add(ilgialaniliststr[i]);
      }
    }
    Map<String, dynamic> kayitVerisi = {
      'tcno': _tcnoController.text.trim(),
      'ad': _isimController.text.trim(),
      'soyad': _soyisimController.text.trim(),
      'sifre': _sifreController.text.trim(),
      'dogumtarihi': _dogumtarihiController.text.toString(),
      'medenihali': medeniDurum.toString(),
      'ilgialanlari': ilgialanlarilistesi.toString(),
      'ehliyetbilgisi': ehliyet.toString()
    };
    setState(() {
      duzenlenmiskullanici = kayitVerisi;
    });
    if (widget.kullanici == null) {
      await _databaseHelper.kullaniciEkle(kayitVerisi);
    } else {
      await _databaseHelper.kullaniciDuzenle(kayitVerisi);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/home_page.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/signin_page.dart';
import 'package:flutter_etkinlik_kayit_gorkem/utils/databasehelper.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController _tcnoController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  Map<String, dynamic> _gecerlikullanici = {};
  late List<Map<String, dynamic>> kullanicilar;
  @override
  void initState() {
    super.initState();
    kullanicilariGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Giriş Sayfası'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.1,
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 11,
                controller: _tcnoController,
                decoration: InputDecoration(
                    label: Text('*TC No'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'TC No boş bırakılamaz.';
                  } else if (value.length != 11) {
                    return 'TC No eksik girdiniz.';
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
              ElevatedButton(
                  onPressed: () {
                    _gecerlikullanici = {};
                    if (_formkey.currentState!.validate()) {
                      for (var element in kullanicilar) {
                        if (element['tcno'] == _tcnoController.text) {
                          setState(() {
                            _gecerlikullanici = element;
                          });
                        }
                      }
                      if (_gecerlikullanici.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Text('Kayıtlı Kullanıcı Bulunamadı.'),
                        )));
                      } else if (_gecerlikullanici['tcno'] ==
                              _tcnoController.text &&
                          _gecerlikullanici['sifre'] == _sifreController.text) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                kullanici: _gecerlikullanici,
                              ),
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Text('Hatalı Şifre...'),
                        )));
                      }
                    } else {}
                  },
                  child: Text('Giriş Yap')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInPage(
                            kullanici: null,
                          ),
                        ));
                  },
                  child: Text('Kayıt Ol'))
            ],
          ),
        ),
      ),
    );
  }

  void kullanicilariGetir() async {
    await DatabaseHelper().kullanicilariGetir().then((value) {
      setState(() {
        kullanicilar = value;
      });
      debugPrint(kullanicilar.toString());
    });
  }
}

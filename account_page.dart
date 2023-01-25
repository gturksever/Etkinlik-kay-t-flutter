import 'package:flutter/material.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/signin_page.dart';

class AccountPage extends StatefulWidget {
  AccountPage({super.key, required this.kullanici});
  Map<String, dynamic> kullanici;
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    String ehliyet =
        widget.kullanici['ehliyetbilgisi'] == 'true' ? 'Var' : 'Yok';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profilim'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""
TC No: ${widget.kullanici['tcno']}
İsim: ${widget.kullanici['ad']}
Soyisim: ${widget.kullanici['soyad']}
Şifre: ${widget.kullanici['sifre']}
Doğum Tarihi: ${widget.kullanici['dogumtarihi'].toString()}
Medeni Hali: ${widget.kullanici['medenihali']}
İlgi Alanları: ${widget.kullanici['ilgialanlari']}
Ehliyet Bilgisi: ${ehliyet}
"""),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInPage(
                          kullanici: widget.kullanici,
                        ),
                      ));
                },
                child: Text('Değiştir'))
          ],
        ),
      ),
    );
  }
}

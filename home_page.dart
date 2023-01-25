import 'package:flutter/material.dart';
import 'package:flutter_etkinlik_kayit_gorkem/pages/login_page.dart';

import 'etkinlikler_page.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.kullanici});
  Map<String, dynamic> kullanici;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anasayfa'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: SizedBox(),
            ),
            ListTile(
              title: const Text('Etkinliklerim'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EtkinliklerPage(kullanici: widget.kullanici, etkinlikler: [],),));
              },
            ),
            ListTile(
              title: const Text('Profilim'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPage(
                        kullanici: widget.kullanici,
                      ),
                    ));
              },
            ),
            ListTile(
              title: const Text('Çıkış Yap'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

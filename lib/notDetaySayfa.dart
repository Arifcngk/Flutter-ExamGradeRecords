import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi/notlar.dart';
import 'package:notlar_uygulamasi/main.dart';
import 'package:notlar_uygulamasi/notlardao.dart';

class NotDetaySayfa extends StatefulWidget {
  Notlar not;
  NotDetaySayfa({required this.not});

  @override
  State<NotDetaySayfa> createState() => _NotDetaySayfaState();
}

class _NotDetaySayfaState extends State<NotDetaySayfa> {
  var tfDersAdi = TextEditingController();
  var tfnot1 = TextEditingController();
  var tfnot2 = TextEditingController();

  Future<void> sil(int not_id) async {
    await Notlardao().notSil(not_id);
    print("$not_id silindi.");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AnaSayfa()));
  }

  Future<void> guncelle(int not_id, String ders_adi, int not1, int not2) async {
    await Notlardao().notGuncelle(not_id, ders_adi, not1, not2);
    print("$ders_adi-$not1-$not2 Güncellendi.");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AnaSayfa()));
  }

  @override
  void initState() {
    super.initState();
    var not = widget.not;
    tfDersAdi.text = not.ders_adi;
    tfnot1.text = not.not1.toString();
    tfnot2.text = not.not2.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                sil(widget.not.not_id);
              },
              child: const Text(
                "Sil",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          TextButton(
              onPressed: () {
                guncelle(widget.not.not_id, tfDersAdi.text,
                    int.parse(tfnot2.text), int.parse(tfnot2.text));
              },
              child: const Text(
                "Güncelle",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ))
        ],
        title: const Text("Not Detay"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: tfDersAdi,
                decoration: InputDecoration(hintText: "Derd Adı"),
              ),
              TextField(
                controller: tfnot1,
                decoration: InputDecoration(hintText: "1. Not"),
              ),
              TextField(
                controller: tfnot2,
                decoration: InputDecoration(hintText: "2. Not"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

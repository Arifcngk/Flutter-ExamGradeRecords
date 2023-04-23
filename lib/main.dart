import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi/notDetaySayfa.dart';
import 'package:notlar_uygulamasi/notKayitSayfa.dart';
import 'package:notlar_uygulamasi/notlar.dart';
import 'package:notlar_uygulamasi/notlardao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({
    super.key,
  });

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  Future<List<Notlar>> tumNotlarGoster() async {
    var notlarListesi = await Notlardao().tumNotlar();
    return notlarListesi;
  }

  Future<bool> uygulamayiKapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            uygulamayiKapat();
          },
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Notlar Uygulaması",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          FutureBuilder<List<Notlar>>(
            future: tumNotlarGoster(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var notlarListesi = snapshot.data;
                double ortalama = 0.0;

                if (notlarListesi != null && notlarListesi.isNotEmpty) {
                  double toplam = 0.0;

                  for (var n in notlarListesi) {
                    toplam = toplam + (n.not1 + n.not2) / 2;
                  }

                  ortalama = toplam / notlarListesi.length;
                }

                return Text("Ortalama: ${ortalama.toInt()}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold));
              } else {
                return const Text(
                  "Ortalama: 0",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              }
            },
          )
        ]),
      ),
      body: WillPopScope(
        onWillPop: uygulamayiKapat,
        child: FutureBuilder<List<Notlar>>(
          future: tumNotlarGoster(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var notlarListesi = snapshot.data;
              return ListView.builder(
                itemCount: notlarListesi!.length,
                itemBuilder: (context, i) {
                  var not = notlarListesi[i];
                  return Padding(
                    padding: const EdgeInsets.only(left: 7, right: 7, top: 7),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotDetaySayfa(
                                      not: not,
                                    )));
                      },
                      child: Card(
                        color: Colors.grey,
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                not.ders_adi,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                not.not1.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                not.not2.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NotKayitSayfa()));
        },
        tooltip: "Not Ekle",
        child: const Icon(Icons.add),
      ),
    );
  }
}

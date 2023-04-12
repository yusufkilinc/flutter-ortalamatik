import 'package:flutter/material.dart';
import 'package:ortalamatik/models/Models.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<String> dropdownitems = ['1 kredi', '2 Kredi', '3 Kredi', '4 Kredi'];

class _MyHomePageState extends State<MyHomePage> {
  List<Models> model = [];
  String dersAdi = "";
  final dersveri = TextEditingController();
  final notveri = TextEditingController();

  String dropdown = dropdownitems.first;
  int derskredisi = 0;
  double ortalama = 0;

  void dropdownvalue() {
    setState(() {
      if (dropdown == dropdownitems[0]) {
        derskredisi = 1;
      }
      if (dropdown == dropdownitems[1]) {
        derskredisi = 2;
      }
      if (dropdown == dropdownitems[2]) {
        derskredisi = 3;
      }
      if (dropdown == dropdownitems[3]) {
        derskredisi = 4;
      }
    });
  }

  void ortalamaHesapla() {
    setState(() {
      int dersOrtalamasi = 0;
      int tumDerslerinOrtalamasi = 0;
      int toplamKredi = 0;
      if (model.isNotEmpty) {
        for (var item in model) {
          dersOrtalamasi = item.lessonpoint * item.lessoncredi;
          tumDerslerinOrtalamasi = tumDerslerinOrtalamasi + dersOrtalamasi;
          toplamKredi = toplamKredi + item.lessoncredi;
        }
        ortalama = tumDerslerinOrtalamasi / toplamKredi;
      } else {
        ortalama = 0;
      }
    });
  }

  void dersekle() {
    setState(() {
      model.add(Models(
          id: model.isNotEmpty ? model.last.id + 1 : 1,
          title: dersveri.text,
          lessoncredi: derskredisi,
          lessonpoint: int.parse(notveri.text)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OrtalaMatik"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add_box_outlined,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            dropdownvalue();
            dersekle();
            ortalamaHesapla();
            dersveri.clear();
            notveri.clear();
          });
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: dersveri,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ders Adi",
              ),
            ),
          ),
          Row(
            children: [
              const Expanded(
                  child: SizedBox(
                width: 10,
                child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
              )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextFormField(
                    controller: notveri,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Ders Notu",
                    ),
                  ),
                ),
              ),
              const Expanded(
                  child: SizedBox(
                width: 10,
                child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                        child: SizedBox(
                      width: 10,
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.cyan),
                            ),
                          ),
                          value: dropdown,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: dropdownitems.map((String ders) {
                            return DropdownMenuItem(
                              value: ders,
                              child: Text(ders),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdown = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const Expanded(
                        child: SizedBox(
                      width: 10,
                      child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    )),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.cyan),
              )),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                "Ortalamanız :  $ortalama",
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.cyan),
              )),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(300, 20, 300, 20),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  height: 5,
                  color: Colors.transparent,
                ),
                itemCount: model.length,
                itemBuilder: (BuildContext context, int index) {
                  Models ders = model[index];
                  return ListTile(
                    tileColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    title: InkWell(
                      child: Text(
                        " ${ders.title} Ders Kredisi: ${ders.lessoncredi} Ders Notu :${ders.lessonpoint}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onLongPress: () {
                      setState(() {
                        model.remove(ders);
                        ortalamaHesapla();
                      });
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

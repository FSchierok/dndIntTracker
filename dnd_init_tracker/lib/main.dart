import 'package:flutter/material.dart';
import "db.dart" as db;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final InitList homeScreen = InitList();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D&D InitTracker',
      theme: ThemeData(
        primaryColor: Colors.red[800],
        accentColor: Colors.red[800],
        buttonColor: Colors.red[800],
        brightness: Brightness.dark,
      ),
      home: homeScreen,
    );
  }
}

class InitList extends StatefulWidget {
  @override
  _InitListState createState() => _InitListState();
}

class _InitListState extends State<InitList> {
  final listHandler = new CharListHandler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("D&D Init Tracker"),
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => {
                      setState(() {
                        listHandler.deleteList();
                      })
                    }),
          ],
        ),
        body: _buildCharList(),
        floatingActionButton: Container(
          child: Row(
            children: [
              Spacer(flex: 1),
              FloatingActionButton.extended(
                  onPressed: () => {
                        setState(() {
                          listHandler.next();
                        })
                      },
                  heroTag: null,
                  label: const Text("Weiter")),
              Spacer(
                flex: 6,
              ),
              FloatingActionButton(
                onPressed: () => {
                  setState(() {
                    _addChar();
                  })
                },
                tooltip: "Neuen Charakter einfügen",
                child: const Icon(Icons.add),
                heroTag: null,
              ),
            ],
          ),
        ));
  }

  Widget _buildCharList() {
    if (listHandler.isNotEmpty()) {
      return ListView.builder(
          itemCount: listHandler.getLength() * 2,
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();
            final index = i ~/ 2;
            return _buildRow(listHandler.getList()[index]);
          });
    } else {
      return Scaffold(appBar: AppBar(title: Text("Noch keine Charaktere!")));
    }
  }

  Widget _buildRow(db.Char char) {
    final dmgFieldController = TextEditingController();
    final noteFieldController = TextEditingController();
    int dmg = 0;
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
              title: Row(children: <Widget>[
                Text(
                  char.name,
                  style: char.incapacitated
                      ? TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.red[800])
                      : null,
                ),
                Spacer(),
                Expanded(
                  child: TextField(
                    controller: dmgFieldController,
                    decoration: InputDecoration(hintText: "Δ TP"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => setState(() {
                          print(dmgFieldController.text);
                          dmg = int.parse(dmgFieldController.text);
                          char.getHealed(dmg);
                          dmgFieldController.clear();
                        })),
                IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => setState(() {
                          dmg = int.parse(dmgFieldController.text);
                          char.takeDmg(dmg);
                          dmgFieldController.clear();
                        }))
              ]),
              subtitle: Wrap(children: <Widget>[
                Text("Init: " +
                    char.init.toString() +
                    " Trefferpunkte: " +
                    char.hp.toString()),
                Spacer(),
                Expanded(
                  child: TextField(),
                ),
              ]),
              trailing: IconButton(
                onPressed: () => {
                  setState(() {
                    listHandler.removeChar(char);
                  })
                },
                icon: Icon(Icons.delete_outline),
              )),
        ],
      ),
    );
  }

  void _addChar() async {
    final _ = await Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Neuen Charakter einfügen"),
          ),
          body: Container(
            padding: EdgeInsets.all(64),
            child: CharCreatorForm(listHandler),
          ));
    }));
    setState(() {});
  }
}

class CharCreatorForm extends StatefulWidget {
  CharCreatorFormState charCreatorFormState;

  CharCreatorForm(CharListHandler handler) {
    charCreatorFormState = CharCreatorFormState(handler);
  }
  @override
  CharCreatorFormState createState() => charCreatorFormState;
}

class CharCreatorFormState extends State<CharCreatorForm> {
  CharListHandler handler;
  final nameFieldContoller = TextEditingController();
  final initFieldContoller = TextEditingController();
  final maxHpFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var name = "";
  int init = 0;
  int maxHp = 0;
  int number = 1;

  CharCreatorFormState(CharListHandler myHandler) {
    handler = myHandler;
  }
  void clearText() {
    nameFieldContoller.clear();
    initFieldContoller.clear();
    maxHpFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            onSaved: (String value) {
              name = value;
            },
            controller: nameFieldContoller,
            decoration: InputDecoration(hintText: "Name"),
          ),
          TextFormField(
            onSaved: (String value) {
              init = int.parse(value);
            },
            controller: initFieldContoller,
            decoration: InputDecoration(hintText: "Initiative"),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            onSaved: (String value) {
              maxHp = int.parse(value);
            },
            controller: maxHpFieldController,
            decoration: InputDecoration(hintText: "Lebenspunkte"),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField<int>(
            onSaved: (int value) {
              number = value;
            },
            onChanged: (int newValue) {
              setState(() {
                number = newValue;
              });
            },
            value: number,
            items: <int>[for (var i = 1; i < 50; i += 1) i]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                  value: value, child: Text(value.toString()));
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red[800]),
              onPressed: () {
                _formKey.currentState.save();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        name + " " + number.toString() + "mal hinzugefügt")));
                this.clearText();
                handler.addChar(name, init, maxHp, number);
              },
              child: Text("Hinzufügen"),
            ),
          )
          // Add TextFormFields and ElevatedButton here.
        ]));
  }
}

class CharListHandler {
  List<db.Char> _charList;

  CharListHandler() {
    this._charList = [];
  }

  void addChar(String name, int init, int maxHp, int number) {
    if (number == 1) {
      _charList.add(db.Char(name, init, maxHp));
    } else {
      for (var i = 1; i <= number; i += 1) {
        _charList.add(db.Char(name + i.toString(), init, maxHp));
      }
    }
    _sortList();
  }

  List<db.Char> getList() {
    return _charList;
  }

  void next() {
    if (_charList == null || _charList.isEmpty) {
    } else {
      _charList = _charList.sublist(1)..addAll(_charList.sublist(0, 1));
    }
  }

  void deleteList() {
    _charList = <db.Char>[];
  }

  void _sortList() {
    final currentInit = _charList[0].init;
    _charList.sort((a, b) => a.init.compareTo(b.init));
    while (_charList[0].init != currentInit) {
      this.next();
    }
  }

  bool isNotEmpty() {
    return _charList.isNotEmpty;
  }

  int getLength() {
    return _charList.length;
  }

  void removeChar(db.Char char) {
    _charList.remove(char);
  }
}

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
    return ListTile(
      title: Text(char.name),
      subtitle: Text(char.init.toString()),
      trailing: Icon(Icons.remove_circle),
      onLongPress: () => {
        setState(() {
          listHandler.removeChar(char);
        })
      },
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
            child: MyCustomForm(listHandler),
          ));
    }));
    setState(() {});
  }
}

class MyCustomForm extends StatefulWidget {
  MyCustomFormState myCustomFormState;

  MyCustomForm(CharListHandler handler) {
    myCustomFormState = MyCustomFormState(handler);
  }
  @override
  MyCustomFormState createState() => myCustomFormState;
}

class MyCustomFormState extends State<MyCustomForm> {
  CharListHandler handler;
  final nameFieldContoller = TextEditingController();
  final initFieldContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var name = "";
  var init = 0.0;

  MyCustomFormState(CharListHandler myHandler) {
    handler = myHandler;
  }
  void clearText() {
    nameFieldContoller.clear();
    initFieldContoller.clear();
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
              init = double.parse(value.replaceAll(",", "."));
            },
            controller: initFieldContoller,
            decoration: InputDecoration(hintText: "Initiative"),
            keyboardType: TextInputType.number,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red[800]),
              onPressed: () {
                _formKey.currentState.save();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(name + " hinzugefügt")));
                this.clearText();
                handler.addChar(name, init);
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

  void addChar(String name, double init) {
    _charList.add(db.Char(name, init));
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

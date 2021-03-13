import 'package:flutter/material.dart';

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
        primarySwatch: Colors.red,
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
  final listHandler = CharListHandler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("D&D Init Tracker"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete), onPressed: listHandler.deleteList),
        ],
      ),
      body: _buildCharList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() {
            _addChar1();
          })
        },
        tooltip: "Neuen Charakter einfügen",
        child: const Icon(Icons.add),
      ),
    );
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

  Widget _buildRow(Char char) {
    return ListTile(
      title: Text(char.name),
      subtitle: Text(char.init.toString()),
    );
  }

  void _addChar1() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Neuen Charakter einfügen"),
        ),
        body: MyCustomForm(listHandler),
      );
    }));
  }
}

class Char {
  String name;
  int init;

  Char(String name, int init) {
    this.name = name;
    this.init = init;
  }
}

class Char2 {
  String name;
  int initiative;
  bool blinded;
  bool charmed;
  bool deafend;
  bool frightend;
  bool grappled;
  bool incapacitated;
  bool invisible;
  bool paralyzed;
  bool petrified;
  bool poisoned;
  bool prone;
  bool restrained;
  bool stunned;
  bool unconscious;
  int exhaustion;
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
  final _formKey = GlobalKey<FormState>();
  var name = "";
  var init = 0;

  MyCustomFormState(CharListHandler handler) {
    handler = handler;
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
          ),
          TextFormField(
            onSaved: (String value) {
              init = int.parse(value);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                _formKey.currentState.save();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(name + " hinzugefügt")));
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
  var _charList = <Char>[];

  void addChar(String name, int init) {
    _charList.add(Char(name, init));
  }

  List<Char> getList() {
    return _charList;
  }

  void next() {
    if (_charList == null || _charList.isEmpty) {
    } else {
      _charList = _charList.sublist(1)..addAll(_charList.sublist(0, 1));
    }
  }

  void deleteList() {
    _charList = <Char>[];
  }

  List<Char> _sortList() {
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
}
// TODO: init = init *100

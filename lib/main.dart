import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: RandomWords(),
        );
  }
}

class RandomWordsState extends State<RandomWords>{
  final _sugestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>(); 
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Startup Name Generator'),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,)
      ],
    ),
      body: _buildSugestions(),
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context){
        final Iterable<ListTile> tiles = _saved.map(
          (WordPair pair){
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          }
        );
        final List<Widget> divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles
          )
          .toList();
        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Sugestions'),
          ),
          body: ListView(children: divided,),
        );       
      })
    );
  }

  Widget _buildSugestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i){
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if(index>=_sugestions.length){
          _sugestions.addAll(generateWordPairs().take(10)); 
        }
        return _buildRow(_sugestions[index]);
      },
    );
  }
  
  Widget _buildRow(WordPair pair){
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved? Colors.red: null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          }else{
            _saved.add(pair);
          }
        });
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}



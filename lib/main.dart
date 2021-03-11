// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//A widget is an element of a graphical user interface (GUI) that displays information or provides
// a specific way for a user to interact with the operating system or an application.
//
//Widgets include icons, pull-down menus, buttons, selection boxes, progress indicators, on-off checkmarks,
// scroll bars, windows, window edges (that let you resize the window), toggle buttons, form,
// and many other devices for displaying information and for inviting, accepting, and responding to user
// actions.
//
//In programming, widget also means the small program that is written in order to describe what a
//particular widget looks like, how it behaves and how it responds to user actions. Most operating
//systems include a set of ready-to-tailor widgets that a programmer can incorporate in an application,
//specifying how it is to behave. New widgets can be created.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() =>
    runApp(MyApp()); //use the arrow for one line functions or methods

// extending StatelessWidget makes the app itself a widget
//In flutter almost everything is a widget including alignment, padding, and layout
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Material App is a isual design language that is standard on mobile and on the web
    // good idea to include uses-material-design: true in pubspec.yaml for full use
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        // Add the 3 lines from here...
        primaryColor: Colors.deepPurple,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<
      WordPair>(); // a Set is preferred to List because it doesnt allow duplicate entries
  final _biggerFont = TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      tileColor: Colors.deepOrange,
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        // this piece of code adds the hearts on the right side of the random words list
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.lightGreen : null,
      ),
      onTap: () {
        //adds or removes the word pair from the saved list on Tap
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }, // ... to here.
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }
}

//Stateless widgets are immutable
//Stateful maintain state that might change during the lifetime of the widget
//Implementing a stateful widget requires at least two classes:
//1) a StatefulWidget class that creates an instance of
//2) a State class.
//The StatefulWidget class is, itself, immutable and can be thrown away and regenerated,
//but the State class persists over the lifetime of the widget.

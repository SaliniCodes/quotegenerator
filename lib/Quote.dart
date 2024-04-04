import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/quoteModel.dart';


import 'dart:convert';

class Quotepage extends StatefulWidget {
  const Quotepage({Key? key}) : super(key: key);

  @override
  State<Quotepage> createState() => _QuoteState();
}

class _QuoteState extends State<Quotepage> {
  List<String> quotes = [];
  List<String> authors = [];
  List<String> savedQuotes = [];


  @override
  void initState() {
    super.initState();
    fetchData();
    loadSavedQuotes();

  }
  List imageUrlList = [
   'https://images.unsplash.com/photo-1616410731303-6affae095a0a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHdoaXRlJTIwcGxhbmUlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fHww',
'https://images.unsplash.com/photo-1601662528567-526cd06f6582?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8d2hpdGUlMjBwbGFuZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
    'https://images.unsplash.com/photo-1616410731303-6affae095a0a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHdoaXRlJTIwcGxhbmUlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1601662528567-526cd06f6582?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8d2hpdGUlMjBwbGFuZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
    'https://images.unsplash.com/photo-1616410731303-6affae095a0a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHdoaXRlJTIwcGxhbmUlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1601662528567-526cd06f6582?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8d2hpdGUlMjBwbGFuZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
    'https://images.unsplash.com/photo-1616410731303-6affae095a0a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHdoaXRlJTIwcGxhbmUlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1601662528567-526cd06f6582?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8d2hpdGUlMjBwbGFuZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
    'https://images.unsplash.com/photo-1616410731303-6affae095a0a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHdoaXRlJTIwcGxhbmUlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1601662528567-526cd06f6582?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8d2hpdGUlMjBwbGFuZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
    'https://images.unsplash.com/photo-1616410731303-6affae095a0a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHdoaXRlJTIwcGxhbmUlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1601662528567-526cd06f6582?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8d2hpdGUlMjBwbGFuZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
    'https://images.unsplash.com/photo-1616410731303-6affae095a0a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHdoaXRlJTIwcGxhbmUlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1601662528567-526cd06f6582?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8d2hpdGUlMjBwbGFuZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
    'https://images.unsplash.com/photo-1616410731303-6affae095a0a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHdoaXRlJTIwcGxhbmUlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1601662528567-526cd06f6582?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8d2hpdGUlMjBwbGFuZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
  ];
  Future<void> fetchData() async {
    final url = Uri.parse('https://type.fit/api/quotes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('Response Data: $data');

      setState(() {
        quotes = data.map((quote) => quote['text'] as String).toList();
        authors = data.map((quote) => quote['author'] as String).toList();
      });
    } else {
      print('Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }
  Future<void> loadSavedQuotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedQuotes = prefs.getStringList('saved_quotes') ?? [];
    });
  }
  Future<void> saveQuote(String quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedQuotes.add(quote);
    await prefs.setStringList('saved_quotes', savedQuotes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quote saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Deep Quotes",style: TextStyle(
          color: Colors.white,
        ),),

      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: quotes.isEmpty
              ? Center(child: CircularProgressIndicator())
              :ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  return Container(height: 200,width:200,
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(imageUrlList[index]),
                        fit: BoxFit.cover,
                      ),
                    ),

                    child: Center(
                      child: ListTile(
                        title: Text(quotes[index]),
                        subtitle: Text(authors[index]),

                        trailing: IconButton(
                          icon: Icon(Icons.save_alt),
                          onPressed: () {
                            saveQuote(quotes[index]);
                          },
                        ),

                      ),
                    ),

                  );
                },
              ),


        ),
      ),
    );
  }
}



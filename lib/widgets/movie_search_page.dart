import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:movie_tracker/model/movie.dart';
import 'package:movie_tracker/widgets/formInputDecor.dart';
import 'package:http/http.dart' as http;
import 'package:movie_tracker/widgets/search_book_detail_dialog.dart';

class MovieSearchPage extends StatefulWidget {
  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  TextEditingController _searchTextController = TextEditingController();

  List<Movie> listOfMovies = [];

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Movie Search'),
          backgroundColor: Colors.redAccent,
        ),
        body: Material(
            elevation: 0.0,
            child: Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Form(
                            child: TextField(
                              onSubmitted: (value) {
                                _search();
                              },
                              controller: _searchTextController,
                              decoration: formInputDecoration(
                                  label: 'search', hintText: 'FLutter Movie'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      (listOfMovies.length != 0 && listOfMovies.isNotEmpty)
                          ? Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 200,
                                    width: 300,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: createMoviesCards(
                                          listOfMovies, context),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Text('No Movies Found'),
                            ),
                    ],
                  )),
            )));
  }

  void _search() async {
    // print(_searchTextController.text);
    await fetchBooks(_searchTextController.text).then((value) {
      setState(() {
        listOfMovies = value;
      });
    }, onError: (val) {
      throw Exception('Failed to load books ${val.toString()}');
    });
  }

  Future<List<Movie>> fetchBooks(String query) async {
    List<Movie> movies = [];
    //https://www.googleapis.com/books/v1/volumes?q=flutter%20development
    http.Response response = await http
        .get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      final Iterable list = body['items'];

      for (var item in list) {
        String title = item['volumeInfo']['title'] == ""
            ? 'N/A'
            : item['volumeInfo']['title'];

        String director = item['volumeInfo']['authors'] == null
            ? 'N/A'
            : item['volumeInfo']['authors'][0];

        String thumbnail = item['volumeInfo']['imageLinks'] == null
            ? 'https://picsum.photos/200/300'
            : item['volumeInfo']['imageLinks']['thumbnail'];

        String description = item['volumeInfo']['description'] == ""
            ? 'N/A'
            : item['volumeInfo']['description'];

        String categories = item['volumeInfo']['categories'] == null
            ? 'N/A'
            : item['volumeInfo']['categories'][0];

        String publishedDate = item['volumeInfo']['publishedDate'] == ""
            ? 'N/A'
            : item['volumeInfo']['publishedDate'];

        Movie searchedBook = new Movie(
          title: title,
          director: director,
          categories: categories,
          description: description,
          photoUrl: thumbnail,
          publishedDate: publishedDate,
          notes: 'notes',
          userId: 'userid',
          id: 'id',
          startedWatching: Timestamp(0, 0),
          finishedWatching: Timestamp(0, 0),
        );
        movies.add(searchedBook);
        // print(publishedDate);
      }
    } else {
      throw ('error ${response.reasonPhrase}');
    }
    return movies;
  }

  List<Widget> createMoviesCards(List<Movie> movies, BuildContext context) {
    final _movieCollectionReference =
        FirebaseFirestore.instance.collection('movies');
    List<Widget> children = [];
    for (var movie in movies) {
      children.add(Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Card(
          elevation: 5,
          color: HexColor('#f6f4ff'),
          child: Wrap(
            children: [
              Image.network(
                movie.photoUrl,
                height: 100,
                width: 160,
              ),
              ListTile(
                title: Text(
                  movie.title,
                  style: TextStyle(color: HexColor('#5d48b6')),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(movie.director, overflow: TextOverflow.ellipsis),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SearchBookDetailDialog(movie: movie, movieCollectionReference: _movieCollectionReference);
                      });
                },
              ),
            ],
          ),
        ),
      ));
    }
    return children;
  }
}


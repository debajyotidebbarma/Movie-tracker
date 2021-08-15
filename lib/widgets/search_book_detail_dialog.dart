import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/model/movie.dart';

class SearchBookDetailDialog extends StatelessWidget {
  const SearchBookDetailDialog({
    Key? key,
    required this.movie,
    required CollectionReference<Map<String, dynamic>> movieCollectionReference,
  }) : _movieCollectionReference = movieCollectionReference, super(key: key);

  final Movie movie;
  final CollectionReference<Map<String, dynamic>> _movieCollectionReference;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Container(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(movie.photoUrl),
              radius: 50,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                movie.title,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.bold),
              )),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Genre: ${movie.categories}',
              )),
          Text('Director: ${movie.director}'),
          Text('Released: ${movie.publishedDate}'),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.blueGrey.shade100,
                  width: 1,
                )),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movie.description,
                      style: TextStyle(
                          wordSpacing: 0.9,
                          letterSpacing: 1.5),
                    ),
                  ),
                )),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                _movieCollectionReference.add(Movie(
                  id: 'id',
                  userId:
                      FirebaseAuth.instance.currentUser!.uid,
                      title: movie.title,
                      director: movie.director,
                      photoUrl: movie.photoUrl,
                      publishedDate: movie.publishedDate,
                      description: movie.description,
                      categories: movie.categories,
                      notes: 'notes',
                      startedWatching: Timestamp(0,0),
                      finishedWatching: Timestamp(0, 0)
                ).toMap());
                Navigator.of(context).pop();
              },
              child: Text('Save')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/constants/constants.dart';
import 'package:movie_tracker/model/movie.dart';
import 'package:movie_tracker/screens/main_screen.dart';
import 'package:movie_tracker/util/util.dart';
import 'package:movie_tracker/widgets/formInputDecor.dart';
import 'package:movie_tracker/widgets/two_sided_round_button.dart';

class MovieDetailsDialog extends StatefulWidget {
  const MovieDetailsDialog({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  _MovieDetailsDialogState createState() => _MovieDetailsDialogState();
}

class _MovieDetailsDialogState extends State<MovieDetailsDialog> {
  bool isReadingClicked = false;
  bool isFinishedWatchingClicked = false;
  final _movieCollectionReference =
      FirebaseFirestore.instance.collection('movies');

  @override
  Widget build(BuildContext context) {
    final _titleTextController =
        TextEditingController(text: widget.movie.title);
    final _directorTextController =
        TextEditingController(text: widget.movie.director);
    final _photoTextController =
        TextEditingController(text: widget.movie.photoUrl);
    final _notesTextController =
        TextEditingController(text: widget.movie.notes);

    return AlertDialog(
      title: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.movie.photoUrl),
              ),
              Spacer(),
              Container(
                  margin: const EdgeInsets.only(bottom: 100),
                  child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close),
                      label: Text(''))),
            ],
          ),
          Text(widget.movie.director),
        ],
      ),
      content: Form(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _titleTextController,
                    decoration: formInputDecoration(
                        label: 'Book Title', hintText: 'The Climber'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _directorTextController,
                    decoration: formInputDecoration(
                        label: 'director', hintText: 'James'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _photoTextController,
                    decoration:
                        formInputDecoration(label: 'photo Url', hintText: ''),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton.icon(
                    onPressed: (widget.movie.startedWatching == Timestamp(0, 0))
                        ? () {
                            setState(() {
                              if (isReadingClicked == false) {
                                isReadingClicked = true;
                              } else {
                                isReadingClicked = false;
                              }
                            });
                          }
                        : null,
                    icon: Icon(Icons.book_sharp),
                    label: (widget.movie.startedWatching == Timestamp(0, 0))
                        ? Text(!isReadingClicked
                            ? 'start watching'
                            : 'started Watching...')
                        : Text(
                            'Started on:${formatDate(widget.movie.startedWatching)}')),
                TextButton.icon(
                    onPressed:
                        (widget.movie.finishedWatching == Timestamp(0, 0))
                            ? () {
                                setState(() {
                                  if (isFinishedWatchingClicked == false) {
                                    isFinishedWatchingClicked = true;
                                  } else {
                                    isFinishedWatchingClicked = false;
                                  }
                                });
                              }
                            : null,
                    icon: Icon(Icons.done),
                    label: (widget.movie.finishedWatching == Timestamp(0, 0))
                        ? Text('Marked as watched')
                        : Text(
                            'Finished on: ${formatDate(widget.movie.finishedWatching)}')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _notesTextController,
                    decoration: formInputDecoration(
                        label: 'Your thoughts', hintText: 'Great Movie'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TwoSidedRoundedButton(
                      text: 'Update',
                      press: () {
                        FirebaseFirestore.instance
                            .collection('movies')
                            .doc(widget.movie.id)
                            .update(Movie(
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              title: _titleTextController.text,
                              director: _directorTextController.text,
                              photoUrl: _photoTextController.text,
                              startedWatching: isReadingClicked
                                  ? Timestamp.now()
                                  : widget.movie.startedWatching,
                              finishedWatching: isFinishedWatchingClicked
                                  ? Timestamp.now()
                                  : widget.movie.finishedWatching,
                              id: widget.movie.id,
                              description: widget.movie.description,
                              notes: _notesTextController.text,
                              publishedDate: widget.movie.publishedDate,
                              categories: widget.movie.categories,
                            ).toMap());
                        Navigator.of(context).pop();
                      },
                      radius: 12,
                      color: kIconColor,
                    ),
                    TwoSidedRoundedButton(
                      text: 'Delete',
                      press: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Are you sure?'),
                                content: Text(
                                    'Once the movie is deleted you can\'t retreive it back.'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        _movieCollectionReference
                                            .doc(widget.movie.id)
                                            .delete();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainScreenPage()));
                                      },
                                      child: Text('yes')),
                                  TextButton(
                                      onPressed: () {}, child: Text('no')),
                                ],
                              );
                            });
                      },
                      radius: 12,
                      color: kIconColor,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

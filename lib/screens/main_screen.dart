// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/constants/constants.dart';
import 'package:movie_tracker/model/movie.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:movie_tracker/model/movie.dart';
import 'package:movie_tracker/model/user.dart';
import 'package:movie_tracker/widgets/create_profile.dart';
// import 'package:movie_tracker/widgets/formInputDecor.dart';
import 'package:movie_tracker/widgets/movie_details_dialog.dart';
import 'package:movie_tracker/widgets/movie_search_page.dart';
// import 'package:movie_tracker/widgets/two_sided_round_button.dart';
import 'package:movie_tracker/widgets/watching_list_card.dart';
// import 'package:provider/provider.dart';
// import 'package:movie_tracker/widgets/formInputDecor.dart';

import 'login_page.dart';

class MainScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    CollectionReference movieCollectionReference =
        FirebaseFirestore.instance.collection('movies');
    List<Movie> userMovieWatchList = [];

    // var authUser = Provider.of<User>(context);
    

    int booksread = 0;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 74,
        backgroundColor: Colors.white24,
        elevation: 0.0,
        centerTitle: false,
        title: Row(
          children: [
            Flexible(
              child: Text("Movie Tracker",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: userCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final userListStream = snapshot.data!.docs.map((user) {
                return MUser.fromDocument(user);
              }).where((user) {
                return (user.uid == FirebaseAuth.instance.currentUser!.uid);
              }).toList();
              // print(userListStream);
              MUser curUser = userListStream[0];
              // print(curUser);

              return Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: InkWell(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(curUser.avatarUrl != ""
                              ? curUser.avatarUrl
                              : 'https://picsum.photos/200/300'),
                          backgroundColor: Colors.white,
                          child: Text(''),
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return createProfileDialog(context, curUser,
                                    booksread, userMovieWatchList);
                              });
                        }),
                  ),
                  Text(
                    '${curUser.displayName}',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              );
            },
          ),
          TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                });
              },
              icon: Icon(Icons.logout),
              label: Text('')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieSearchPage(),
              ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 12, left: 12, bottom: 6),
          width: double.infinity,
          child: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.headline5,
                children: [
                  TextSpan(text: 'Your Watching\n activity'),
                  TextSpan(
                      text: ' right now...',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: movieCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              var userMovieFilteredWatchListStream =
                  snapshot.data!.docs.map((movie) {
                return Movie.fromDocument(movie);
              }).where((movie) {
                return (movie.userId ==
                        FirebaseAuth.instance.currentUser!.uid) &&
                    (movie.finishedWatching == Timestamp(0, 0)) &&
                    (movie.startedWatching != Timestamp(0, 0));
              }).toList();
              userMovieWatchList = snapshot.data!.docs.map((movie) {
                return Movie.fromDocument(movie);
              }).where((movie) {
                return (movie.userId ==
                        FirebaseAuth.instance.currentUser!.uid) &&
                    (movie.finishedWatching != Timestamp(0, 0)) &&
                    (movie.startedWatching != Timestamp(0, 0));
              }).toList();
              booksread = userMovieWatchList.length;
              return Expanded(
                flex: 1,
                child: (userMovieFilteredWatchListStream.length > 0)
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: userMovieFilteredWatchListStream.length,
                        itemBuilder: (context, index) {
                          Movie movie = userMovieFilteredWatchListStream[index];
                          return InkWell(
                            child: WatchingListCard(
                                image: movie.photoUrl,
                                title: movie.title,
                                director: movie.director,
                                rating: 0,
                                buttonText: "watching",
                                // movie: ,
                                isBookRead: true,
                                pressDetails: () {},
                                pressRead: () {}),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return MovieDetailsDialog(movie: movie);
                                  });
                            },
                          );
                        })
                    : Center(
                        child: Text(
                            'you haven\'t started watching. start by adding a movie',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
              );
            }),
        Container(
            width: double.infinity,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Watching List',
                      style: TextStyle(
                          color: kBlackColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold))
                ])),
              )
            ])),
        SizedBox(
          height: 4,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: movieCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              var watchingListMovie = snapshot.data!.docs.map((movie) {
                return Movie.fromDocument(movie);
              }).where((movie) {
                return (movie.userId ==
                        FirebaseAuth.instance.currentUser!.uid) &&
                    (movie.startedWatching == Timestamp(0, 0)) &&
                    (movie.finishedWatching == Timestamp(0, 0));
              }).toList();
              return Expanded(
                  flex: 1,
                  child: (watchingListMovie.length > 0)
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: watchingListMovie.length,
                          itemBuilder: (context, index) {
                            Movie movie = watchingListMovie[index];
                            return InkWell(
                              child: WatchingListCard(
                                  image: movie.photoUrl,
                                  title: movie.title,
                                  director: movie.director,
                                  rating: 0,
                                  buttonText: 'Not Started',
                                  isBookRead: true,
                                  pressDetails: () {},
                                  pressRead: () {}),
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (context) =>
                                      MovieDetailsDialog(movie: movie)),
                            );
                          })
                      : Center(
                          child: Text('No movies found. Add a movie',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ));
            })
      ]),
    );
  }
}

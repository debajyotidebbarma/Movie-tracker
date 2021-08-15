import 'package:flutter/material.dart';
import 'package:movie_tracker/model/movie.dart';
// import 'package:hexcolor/hexcolor.dart';
import 'package:movie_tracker/model/user.dart';
import 'package:movie_tracker/widgets/update_user_profile.dart';

// import 'formInputDecor.dart';

Widget createProfileDialog(BuildContext context, MUser curUser,int booksread,List<Movie> movieList) {
  final TextEditingController _displayNameTextController =
      TextEditingController(text: curUser.displayName);
  final TextEditingController _professionTextController =
      TextEditingController(text: curUser.profession);
  final TextEditingController _quoteTextController =
      TextEditingController(text: curUser.quote);
  final TextEditingController _avatarTextController =
      TextEditingController(text: curUser.avatarUrl);
  return UpdateUserProfile(
      user: curUser,
      displayNameTextController: _displayNameTextController,
      quoteTextController: _quoteTextController,
      professionTextController: _professionTextController,
      avatarTextController: _avatarTextController,
      movieList: movieList,);
}


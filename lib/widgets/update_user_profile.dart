import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:movie_tracker/model/movie.dart';
import 'package:movie_tracker/model/user.dart';
import 'package:movie_tracker/util/util.dart';
import 'package:movie_tracker/widgets/formInputDecor.dart';

class UpdateUserProfile extends StatelessWidget {
  const UpdateUserProfile({
    Key? key,
    required TextEditingController displayNameTextController,
    required TextEditingController quoteTextController,
    required TextEditingController professionTextController,
    required TextEditingController avatarTextController,
    required List<Movie> movieList,
    required this.user,
  })  : _displayNameTextController = displayNameTextController,
        _quoteTextController = quoteTextController,
        _professionTextController = professionTextController,
        _avatarTextController = avatarTextController,
        mov = movieList,
        super(key: key);
  final MUser user;

  final TextEditingController _displayNameTextController;
  final TextEditingController _quoteTextController;
  final TextEditingController _professionTextController;
  final TextEditingController _avatarTextController;
  final List<Movie> mov;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(user.avatarUrl != ""
                    ? user.avatarUrl
                    : 'https://picsum.photos/200/300'),
                radius: 50,
              )
            ],
          ),
         
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  user.displayName.toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(
                            child: Text('Edit ${user.displayName}'),
                          ),
                          content: Form(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          user.avatarUrl == ""
                                              ? 'https://picsum.photos/200/300'
                                              : user.avatarUrl),
                                      radius: 50,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                        // initialValue: curUser.displayName,
                                        controller: _displayNameTextController,
                                        decoration: formInputDecoration(
                                          label: 'name',
                                          hintText: '',
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                        //  initialValue: curUser.quote,
                                        controller: _quoteTextController,
                                        decoration: formInputDecoration(
                                          label: 'quote',
                                          hintText: '',
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                        //  initialValue: curUser.profession,
                                        controller: _professionTextController,
                                        decoration: formInputDecoration(
                                          label: 'profession',
                                          hintText: '',
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                        //  initialValue: curUser.avatarUrl,
                                        controller: _avatarTextController,
                                        decoration: formInputDecoration(
                                          label: 'avatar url',
                                          hintText: '',
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.id)
                                        .update(MUser(
                                          id: user.id,
                                          uid: user.uid,
                                          displayName:
                                              _displayNameTextController.text,
                                          avatarUrl: _avatarTextController.text,
                                          profession:
                                              _professionTextController.text,
                                          quote: _quoteTextController.text,
                                        ).toMap());
                                  },
                                  child: Text('Update')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel')),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.mode_edit, color: Colors.black12),
                  label: Text(''))
            ],
          ),
          Text('${user.profession}',
              style: Theme.of(context).textTheme.subtitle2),
          SizedBox(
            width: 100,
            height: 2,
            child: Container(
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.blueGrey),
                  color: HexColor('#f1f3f6'),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Favourite Quote',
                        style: TextStyle(color: Colors.black)),
                    SizedBox(
                      width: 100,
                      height: 2,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                            user.quote.length == 0
                                ? "Favourite movie quote: Life is Great"
                                : "\"${user.quote}\"",
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontStyle: FontStyle.italic,
                                    )),
                      ),
                    )
                  ],
                ),
                scrollDirection: Axis.vertical,
              )),
               Text(
            'Movies watched',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.redAccent),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width*0.5,
              child: ListView.builder(
                  itemCount: mov.length,
                  itemBuilder: (context, index) {
                    Movie movie = mov[index];
                    return Card(
                      child: Column(
                        children: [ListTile(
                          title: Text('${movie.title}'),
                          leading: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(movie.photoUrl),
                          ),
                          subtitle: Text('${movie.director}'),
                        ),
                        Text('Finished on: ${formatDate(movie.finishedWatching)}')],
                      ),
                      
                    );
                  }),
            ),
          )
        ],
      )),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  final String title;
  final String director;
  final String notes;
  final String categories;
  final String description;
  final String userId;
  final String photoUrl;
  final String publishedDate;
  final Timestamp startedWatching;
  final Timestamp finishedWatching;

  Movie(
      {
        required this.startedWatching, required this.finishedWatching,required this.userId,
      required this.title,
      required this.id,
      required this.director,
      required this.notes,
      required this.categories,
      required this.description,
      required this.photoUrl,
      required this.publishedDate});

  factory Movie.fromDocument(QueryDocumentSnapshot data) {
    return Movie(
        id: data.id,
        title: data.get('title'),
        director: data.get('director'),
        notes: data.get('notes'),
        categories: data.get('categories'),
        description: data.get('description'),
        userId: data.get('user_id'),
        photoUrl: data.get('photo_url'),
        publishedDate: data.get('published_date'),
        startedWatching: data.get('started_watching'),
        finishedWatching:data.get('finished_watching'));
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'user_id': userId,
      'director': director,
      'notes': notes,
      'photo_url': photoUrl,
      'published_date': publishedDate,
      'description': description,
      'categories': categories,
      'started_watching':startedWatching,
      'finished_watching':finishedWatching,
    };
  }
}

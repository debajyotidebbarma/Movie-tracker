import 'package:flutter/material.dart';
import 'package:movie_tracker/constants/constants.dart';
import 'package:movie_tracker/model/movie.dart';
import 'package:movie_tracker/widgets/movie_rating.dart';
import 'package:movie_tracker/widgets/two_sided_round_button.dart';

class WatchingListCard extends StatelessWidget {
  final String image;
  final String title;
  final String director;
  final double rating;
  final String buttonText;
  // final Movie movie;
  final bool isBookRead;
  final Function pressDetails;
  final Function pressRead;

  const WatchingListCard({Key? key, required this.image, required this.title, required this.director, required this.rating, required this.buttonText, 
  // required this.movie,
   required this.isBookRead, required this.pressDetails, required this.pressRead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 202,
      margin: EdgeInsets.only(left: 24,bottom: 0),
      child: Stack(children: [
        Positioned(
          left: 0,
          right: 0,
          child: Container(height: 244,
        decoration: BoxDecoration(color: 
        Colors.white,
        borderRadius: BorderRadius.circular(29),
        boxShadow: [BoxShadow(offset: Offset(0,10),
        blurRadius: 33,
        color: kShadowColor,
        )]
        ),
        
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(image,width: 100,),
        )
        ,
        Positioned(
          top:34,
          right: 10
          ,child: Column(children: [
            IconButton(onPressed: (){
              
            }, icon: Icon(Icons.favorite_border),)
            ,
            MovieRating(score:(rating)),
        ],)),
        Positioned(
          top: 160,
          child: Container(
            height: 85,
            width: 202,
            child: 
        Column(children: [
          Padding(
            padding: const EdgeInsets.only(left:24),
            child: RichText(
              maxLines: 2,
              text: TextSpan(
                style: TextStyle(color:kBlackColor),
              children: [
                TextSpan(text: '$title\n',
                style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: director,
                style: TextStyle(color: kLightColor)),
              ],
              ),
              ),
          ),
          Spacer(),
          Row(children: [
            Container(
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment:Alignment.center,
              child: Text('Details'),
            ),
            Expanded(child: TwoSidedRoundedButton(
              text:buttonText,
              press:(){},
              color:kLightPurple,
            ),),
          ],)
        ],),))
      ],),


    );
  }
}

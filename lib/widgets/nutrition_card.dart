import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NutritionCard extends StatelessWidget {
  final snap;
  const NutritionCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 8, 0, 8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(87, 87, 87, 1),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              snap["name"].toString()[0].toUpperCase() +
                  snap["name"].toString().substring(1),
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.alarm,
                  size: 20,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    (snap["date"] as Timestamp)
                        .toDate()
                        .toString()
                        .substring(11, 16),
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  color: Colors.green,
                ),
                child: Text(snap["protein"].toString() + " cal"),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  color: Colors.redAccent,
                ),
                child: Text(snap["energy"].toString() + " g"),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  color: Colors.teal,
                ),
                child: Text(snap["fats"].toString() + " g"),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  color: Colors.deepPurpleAccent,
                ),
                child: Text(snap["crab"].toString() + " g"),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

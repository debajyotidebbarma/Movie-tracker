import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

InputDecoration formInputDecoration({required String label,required String hintText}) {
    return InputDecoration(
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    )
                                  ),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: HexColor('#69639f'),
                                  width: 2.0)),
                                  labelText: label,
                                  hintText: hintText,
                                );
  }
import 'package:flutter/material.dart';


Widget getFeeling(String feelingString) {
  Widget _feeling;
  if(feelingString == "nothing") {
    _feeling = Text("");  // Change it to custom icons later
  } else if(feelingString == "happy") {
    _feeling = Icon(Icons.add);
  } // Add more
  else {
    _feeling = Text("");
  }
  return _feeling;
}
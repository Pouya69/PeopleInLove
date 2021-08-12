import 'package:shared_preferences/shared_preferences.dart';

getFromPrefs(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? "";
}
addToPrefs(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

/* _addToPrefsBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
} */

addToPrefsList(String key, List<String> value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, value);
}
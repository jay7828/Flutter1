import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/notes.dart';

class ApiService {
  static String _baseUrl = "https://notesjay1.onrender.com/notes";

  static Future<void> addNote(Notes note) async {
    try {
      var response = await http.post(
        Uri.parse(_baseUrl + "/add"),
        body: note
            .toMap(), // Assuming toMap() returns the data in the correct format
      );

      if (response.statusCode == 200) {
        // Decode JSON only for successful responses
        var decode = jsonDecode(response.body);
        log(decode.toString());
      } else {
        // Handle error response
        log("HTTP Error: ${response.statusCode}");
        log("Error content: ${response.body}");
      }
    } catch (e) {
      log("Error during API call: $e");
    }
  }

  static Future<void> deleteNote(Notes note) async {
    try {
      var response = await http.post(
        Uri.parse(_baseUrl + "/delete"),
        body: note
            .toMap(), // Assuming toMap() returns the data in the correct format
      );

      if (response.statusCode == 200) {
        // Decode JSON only for successful responses
        var decode = jsonDecode(response.body);
        log(decode.toString());
      } else {
        // Handle error response
        log("HTTP Error: ${response.statusCode}");
        log("Error content: ${response.body}");
      }
    } catch (e) {
      log("Error during API call: $e");
    }
  }

  static Future<List<Notes>> fetchList(String userid) async {
    var response = await http.post(
      Uri.parse(_baseUrl + "/list"),
      body: {
        "userid": userid
      }, // Assuming toMap() returns the data in the correct format
    );

    // Decode JSON only for successful responses
    var decode = jsonDecode(response.body);
    List<Notes> notes =[];
    for (var noteMap in decode)
      {
        Notes note = Notes.fromMap(noteMap);
        notes.add(note);
      }
    return notes;
  }
}

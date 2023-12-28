import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:notes/models/notes.dart';
import 'package:notes/services/api_services.dart';

class NotesProvider with ChangeNotifier{
  List<Notes> notes =[];

  bool isLoading =true;

  List<Notes> getFilteredNotes( String searchQuery){
    return notes.where((element) => element.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||element.content!.toLowerCase().contains(searchQuery.toLowerCase()) ).toList();
  }

  NotesProvider(){
    log("Constructor started");
    fetchNotes();
  }
  void sortNotes()
  {
    notes.sort((a,b)=>b.dateadded!.compareTo(a.dateadded!));
  }
  void addNotes(Notes note) {
    notes.add(note);
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);
  }
  void updateNotes(Notes note){
    int indexOfNote =notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote]=note;
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);

  }

  void deleteNotes(Notes note){
    int indexOfNote =notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    sortNotes();
    notifyListeners();
    ApiService.deleteNote(note);
  }

  void fetchNotes()async{
    notes= await ApiService.fetchList("jay");
    isLoading=false;
    sortNotes();
    notifyListeners();
  }

}
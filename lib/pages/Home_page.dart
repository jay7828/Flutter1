import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/notes.dart';
import 'package:notes/pages/add_New_Note.dart';
import 'package:notes/providerr/notes_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget
{
  const HomePage ({Key?key}) : super(key:key);
  @override
  _HomePageState createState()=> _HomePageState() ;
}

class _HomePageState extends State<HomePage>{

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    NotesProvider notesProvider = Provider.of<NotesProvider>( context);
   return Scaffold(
     appBar: AppBar(
       title: const Text("Notes App"),
       centerTitle: true,
     ),
     body:(notesProvider.isLoading==false)?SafeArea(
       child:(notesProvider.notes.isNotEmpty)? ListView(
         children: [

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextField(
               onChanged: (val){
                  setState(() {
                    searchQuery = val;
                  });
               },
               decoration: InputDecoration(
                   hintText : "Search"
               ),

             ),
           ),

           (notesProvider.getFilteredNotes(searchQuery).length > 0)?GridView.builder(
             physics: NeverScrollableScrollPhysics(),
             shrinkWrap: true,
             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
             itemCount: notesProvider.getFilteredNotes(searchQuery).length,
             itemBuilder: (context ,index){
               Notes currentNote= notesProvider.getFilteredNotes(searchQuery)[index];
               return GestureDetector(
                 onTap:(){
                   Navigator.push(
                     context,
                     CupertinoPageRoute(
                         builder:(context)=> AddNewPage(isUpdate:true,note: currentNote,)
                     )

                   );
                 } ,

                 onLongPress: (){
                   notesProvider.deleteNotes(currentNote);
                 },
                 child:
                   Container(
                     padding: const EdgeInsets.all(20),
                     margin: const EdgeInsets.all(5),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       border: Border.all(
                         color: Colors.grey,
                         width: 3,

                       ),

                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(currentNote.title!, style : const TextStyle(fontWeight:FontWeight.w700,fontSize: 20),maxLines: 1,overflow: TextOverflow.ellipsis,),
                         const SizedBox(height: 10,),
                         Text(currentNote.content! , style : const TextStyle(fontWeight:FontWeight.w400,fontSize: 16 , color: Colors.grey),maxLines: 5,overflow: TextOverflow.ellipsis,)
                       ],
                     ),
                   ),
               );
             },
           ):const Padding(
             padding: EdgeInsets.all(8.0),
             child: Center(
               child: Text("No note found!" , textAlign: TextAlign.center,),
             ),
           ),
         ],
       ): const Center(
         child: Text("No Notes Yet"),
       ),
     ):const Center(
       child: CircularProgressIndicator(),
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: () {
         Navigator.push(
           context,
           CupertinoPageRoute(
               fullscreenDialog: true,
               builder: (context) => const AddNewPage(isUpdate: false,),
           ),
         );
       },
       child: const Icon(Icons.add),
     ),
   );
  }

}

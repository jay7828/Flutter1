import 'package:flutter/material.dart';
import 'package:notes/models/notes.dart';
import 'package:notes/providerr/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewPage extends StatefulWidget {
  final bool isUpdate;
  final Notes? note;
  const AddNewPage({Key?key, required this.isUpdate, this.note}): super(key: key);

  @override
  State<AddNewPage> createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {

  FocusNode noteFocus = FocusNode();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController contentcontroller =TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.isUpdate)
    {
      titlecontroller.text=widget.note!.title!;
      contentcontroller.text=widget.note!.content!;
    }
  }
  void addNewNote()
  {
    Notes newNote =Notes(
      id: const Uuid().v1(),
      userid: "jay",
      title: titlecontroller.text,
      content: contentcontroller.text,
      dateadded: DateTime.now(),
    );
    Provider.of<NotesProvider>((context),listen: false).addNotes(newNote);
    Navigator.pop(context);
  }

  void updateNote()
  {
    widget.note!.title=titlecontroller.text;
    widget.note!.content=contentcontroller.text;
    widget.note!.dateadded=DateTime.now();
    Provider.of<NotesProvider>(context,listen: false).updateNotes(widget.note!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: {} For Left Side Stuff
        actions: [
          IconButton(
              onPressed:(){
                if(widget.isUpdate)
                  {
                    updateNote();
                  }
                else
                  {
                    addNewNote();
                  }
              },
              icon:const Icon(Icons.check),
          )
        ]//For Right Side Stuff,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              children:[

                TextField(
                  controller: titlecontroller,
                  onSubmitted: (val){
                    if(val!="")
                      {
                        noteFocus.requestFocus();
                      }
                  },
                  autofocus :(widget.isUpdate==true) ? false :true,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration:const InputDecoration(
                    hintText: "Title",
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: contentcontroller,
                    focusNode: noteFocus,
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Notes",
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
          ),
        ),
      ),
    );
  }
}

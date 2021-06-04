import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<String> _toDoList = ['Code', 'Compile', 'Test'];

  TextEditingController _tecInsertTask = new TextEditingController();
  late final SlidableController slidableController;
  String insertTaskValue;

  void initState(){
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged);
      super.initState();
    )
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('To-Do'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Write the task to do:'),
                  content: TextField(
                    autofocus: true,
                    controller: _tecInsertTask,
                    onChanged: (value) {
                      setState(() {
                        insertTaskValue = value;
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            //_tecInsertTask.text = insertTaskValue;
                            _toDoList.add(insertTaskValue);
                            _tecInsertTask.text = '';
                            Navigator.pop(context);
                          });
                        },
                        child: Text('Save')),
                    TextButton(
                        onPressed: () {
                          _tecInsertTask.text = '';
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'))
                  ],
                );
              },
            );
          },
        ),
        body: ListView.builder(
          itemCount: _toDoList.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(_toDoList[index]));
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<_ToDoItem> _toDoList = [
    _ToDoItem(1, 'Code', '', null, null, false),
    _ToDoItem(2, 'Compile', '', null, null, false),
    _ToDoItem(3, 'Test', '', null, null, false)
  ];

  TextEditingController _tecInsertTask = new TextEditingController();
  late final SlidableController slidableController;
  String insertTaskValue = '';

  void initState() {
    slidableController = SlidableController(
        onSlideAnimationChanged: handleSlideAnimationChanged,
        onSlideIsOpenChanged: handleSlideIsOpenChanged);
    super.initState();
  }

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
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
            addTask();
          },
        ),
        body: ListView.builder(
          itemCount: _toDoList.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: Key(_toDoList[index].index.toString()),
              controller: slidableController,
              direction: Axis.horizontal,
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
                onDismissed: (actionType) {
                  _showSnackBar(
                      context,
                      actionType == SlideActionType.primary
                          ? 'Dismiss Archive'
                          : 'Dimiss Delete');
                  setState(() {
                    _toDoList.removeAt(index);
                  });
                },
              ),
              actionPane: _getActionPane(index)!,
              actionExtentRatio: 0.25,
              child: HorizontalListItem(_toDoList[index]),
              actions: <Widget>[],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Done',
                  color: Colors.green[200],
                  icon: Icons.check,
                  onTap: () => _showSnackBar(context, 'Marked as completed'),
                ),
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.orange[100],
                  icon: Icons.edit,
                  onTap: () async {
                    _toDoList[index] = editTask(_toDoList[index]);
                    _showSnackBar(
                        context, 'Task ${_toDoList[index].index} edited');
                  },
                  closeOnTap: false,
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red[200],
                  icon: Icons.delete,
                  onTap: () => _showSnackBar(context, 'Delete'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget? _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void addTask() {
    showDialog(
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
                    _toDoList.add(_ToDoItem(_toDoList.length + 1,
                        insertTaskValue, null, null, null, false));
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
  }

  _ToDoItem editTask(_ToDoItem toDoItem) {
    _ToDoItem result = toDoItem;
    _tecInsertTask.text = toDoItem.title;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit the task:'),
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
                    toDoItem.title = insertTaskValue;
                    result = toDoItem;
                    Navigator.pop(context);
                    _tecInsertTask.text = '';
                  });
                },
                child: Text('Save')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _tecInsertTask.text = '';
                },
                child: Text('Cancel'))
          ],
        );
      },
    );

    return result;
  }
}

class HorizontalListItem extends StatelessWidget {
  HorizontalListItem(this.item);
  final _ToDoItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
              ? Slidable.of(context)?.open()
              : Slidable.of(context)?.close(),
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text(item.title),
        ),
      ),
    );
  }
}

class _ToDoItem {
  _ToDoItem(
    this.index,
    this.title,
    this.subtitle,
    this.color,
    this.category,
    this.done,
  );

  final int index;
  String title;
  String? subtitle;
  Color? color;
  String? category;
  bool? done;
}

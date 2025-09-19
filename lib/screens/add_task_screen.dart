import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import '../models/task.dart';
// enum TaskStatus { pending, inProgress, completed }

class AddTaskScreen extends StatefulWidget {
  final int? editIndex;
  final Task? task;

  const AddTaskScreen({super.key, this.editIndex, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}
class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
final _title = TextEditingController();
final _desc = TextEditingController();
late TaskStatus _selectedStatus = TaskStatus.pending;
late TaskPriority _selectedPriority = TaskPriority.medium;


@override
  void initState() {
    super.initState();
    if(widget.task!= null){
      _title.text = widget.task!.title;
      _desc.text = widget.task!.description;
      _selectedStatus = widget.task!.status;
      _selectedPriority = widget.task!.priority;

    }
  }
  @override
  void dispose() {
    super.dispose();
    _title.clear();
    _desc.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task",style: TextStyle(color: Colors.white,
          fontSize: 30,fontWeight: FontWeight.bold,)),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key:  _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 30,
            children: [
              TextFormField(
                controller: _title,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _desc,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Description",
                    hintStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This is required';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<TaskStatus>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  labelText: "Status",
                    labelStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder()
                ),
                 items: TaskStatus.values.map((status){
                   return DropdownMenuItem(
                     value: status,
                       child: Text(status.name,style: TextStyle(fontSize: 18),));
                 }).toList(),
                onChanged: (value) {
                  if(value!= null){
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
                ),
                DropdownButtonFormField<TaskPriority>(
                    initialValue: _selectedPriority,
                     decoration: InputDecoration(
                       labelText: "Priority",
                         labelStyle: TextStyle(fontSize: 20),
                         border: OutlineInputBorder(),
                     ),
                    items: TaskPriority.values.map((priority){
                      return DropdownMenuItem(
                          value: priority,
                          child: Text(priority.name,style: TextStyle(fontSize:
                          18),));
                    }).toList(),
                  onChanged: (value) {
          
                      if(value!=null){
                        setState(() {
                          _selectedPriority = value;
                        });
                      }
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () {

                    String title = _title.text.trim();
                    String desc = _desc.text.trim();

                    if(_formkey.currentState!.validate()) {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                      // Text("All fields are required")));
                      // return;

                      Task task = Task(title: title, description: desc, status:
                      _selectedStatus, priority: _selectedPriority);

                      final taskProvider = Provider.of<TaskProvider>(context,
                          listen: false);

                      if (widget.editIndex == null) {
                        taskProvider.addTask(task);
                      } else {
                        taskProvider.updatedTask(widget.editIndex!, task);
                      }
                      Navigator.pop(context);
                    }
                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding: EdgeInsets.symmetric(vertical: 16)
                      ), child: Text(widget.task == null ? "Add Task" : "Edit "
                          "Task",style: const TextStyle(fontSize: 20, color:
                      Colors.white),)),
                )
            ],
          ),
        ),
      ),
    );
  }
}

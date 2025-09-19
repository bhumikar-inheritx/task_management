
import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTab;
  final VoidCallback onDelete;
  final Function(bool) onToggleDone;

  const TaskCard({super.key, required this.task, required this.onTab, required this.onDelete, required this.onToggleDone});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      child: ListTile(
        title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 22
        ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // align left
          children: [
            Text(
              task.description,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
              ),
            ),
            Text(
              "Status: ${task.status.name}",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: task.status == TaskStatus.completed
                    ? Colors.green
                    : task.status == TaskStatus.inProgress
                    ? Colors.orange
                    : Colors.redAccent,
              ),
            ),
            Text("Priority :${task.priority.name}",style: TextStyle(
              fontSize: 17,fontWeight: FontWeight.bold,
              color: task.priority == TaskPriority.high ? Colors.redAccent
                  :task.priority == TaskPriority.medium ?Colors.orange :
              Colors.green,
            ),)
          ],
        ),
        leading: Checkbox(
            value:task.status == TaskStatus.completed ,
            onChanged: (_) {
           onToggleDone(true);
    }),
        trailing: IconButton(onPressed: onDelete, icon: Icon(Icons.delete,color: Colors.redAccent,)),
        onTap: onTab,
      ),
    );
  }
}

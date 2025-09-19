
import 'package:task_manager_app/models/task.dart';

class User{
 late String emailOrPhone;
 late List<Task> task;

 User({required this.emailOrPhone, required this.task});

  Map<String , dynamic> toJson()=>{
   'emailOrPhone' : emailOrPhone,
    'task' : task.map((t)=>t.toJson()).toList()
  };


 factory User.fromJson(Map<String , dynamic> json){
  final List<dynamic> taskList = json['task'] as List<dynamic>? ?? [];
   return User(
       emailOrPhone: json['emailOrPhone'],
       task: taskList
           .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
           .toList(),
   );
       
 }
}


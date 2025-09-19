import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/widgets/task_card.dart';
import '../providers/task_provider.dart';
import 'add_task_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context)async{
    showDialog(context:context , builder: (context) {
      return AlertDialog(
        title: Text("Are you Sure?"),
        content: Text("Do you want to Log Out"),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Cancel")
          ),
          TextButton(onPressed: ()  async {

            final prefs =await SharedPreferences.getInstance();
            await prefs.setBool('loggedIn', false);

            Provider.of<TaskProvider>(context, listen: false).logout();

            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder:
                (context)
            => LoginScreen(),));
          }, child: Text("Yes"))
        ],
      );
    },);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard",style: TextStyle(color: Colors.white,
          fontSize: 30,fontWeight: FontWeight.bold,),),backgroundColor: Colors.indigoAccent,
        actions: [
          TextButton(onPressed: () => _logout(context),style:
            TextButton.styleFrom(backgroundColor: Colors.white,),
            child: Text("LogOut",style: TextStyle(color: Colors.red,fontSize:
            17),)
          )
        ],
      ),
      body: Consumer<TaskProvider>(
        builder :(context ,taskProvider, child) {
          if(taskProvider.tasks.isEmpty){
            return Center(child: Text("No Task add yet",style: TextStyle
              (fontSize: 25),));
          }
          else{
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder( itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return TaskCard(
                        task: task,
                        onTab: () {
                            Navigator.push(context, MaterialPageRoute(builder:
                                (context) => AddTaskScreen(editIndex : index,
                                    task :task )
                              ,));
                        },
                        // onDelete: () => taskProvider.deleteTask(index),
                      onDelete: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("Are you Sure?"),
                            content: Text("Do you want to Delete this task?"),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.pop(context);
                              }, child: Text("Cancel")
                              ),
                              TextButton(onPressed: () {
                                taskProvider.deleteTask(index);
                                Navigator.pop(context);
                              }, child: Text("Yes"))
                            ],
                          );
                        },);
                      },
                        onToggleDone:(_) => taskProvider.toggleDone(index),
                    );
                  },
              ),
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(),));
      }, child: Icon(Icons.add),),
    );
  }
}

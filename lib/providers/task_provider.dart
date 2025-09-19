
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../shared_prefs/storage.dart';


class TaskProvider extends ChangeNotifier{

  late List<Task> _task =[];
  late List<User> _allUsers =[];
  String? _currentUser;

  List<Task> get tasks => _task;
  TaskProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('emailOrPhone');
    if (savedUser != null) {
      await loadUserTasks(savedUser);
    }
  }

  Future<void> loadUserTasks(String emailOrPhone)async {
    _allUsers = await Storage.getUser();
    _currentUser = emailOrPhone;

    User user = _allUsers.firstWhere(
        (u)=>u.emailOrPhone == emailOrPhone,
      orElse: () => User(emailOrPhone: emailOrPhone, task: []),
    );

    if(!_allUsers.any((u) => u.emailOrPhone == emailOrPhone)){
      _allUsers.add(user);
      await Storage.saveUser(_allUsers);
    }

      _task = user.task;
      notifyListeners();
}
  Future<void> addTask(Task task) async {
    _task.add(task);
    await _save();
  }

 Future <void> updatedTask(int index, Task updatedTask)async {
    _task[index] = updatedTask;
    await _save();
 }

  Future<void> toggleDone(int index) async {
    if (_task[index].status == TaskStatus.completed) {
      _task[index].status = TaskStatus.pending;
    } else {
      _task[index].status = TaskStatus.completed;
    }
    await _save();
  }


  Future <void> deleteTask(int index)async {
    _task.removeAt(index);
   await _save();
 }
  Future<void> _save() async {
    if (_currentUser == null) return;

    final userIndex = _allUsers.indexWhere((u) => u.emailOrPhone == _currentUser);
    if (userIndex != -1) {
      _allUsers[userIndex] = User(emailOrPhone: _currentUser!, task: _task);
    } else {
      _allUsers.add(User(emailOrPhone: _currentUser!, task: _task));
    }

    await Storage.saveUser(_allUsers);
    notifyListeners();
  }
  void logout() {
    _currentUser = null;
    _task = [];
    notifyListeners();
  }

}









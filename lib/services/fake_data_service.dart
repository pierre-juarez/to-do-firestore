import 'dart:async';
import 'package:nowtask/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Solo para Timestamp

class FakeDataService {
  static final List<Task> _tasks = [
    Task(id: "1", description: "A demo task", isDone: false, createdOn: Timestamp.now(), updatedOn: Timestamp.now()),
    Task(id: "2", description: "Another demo task", isDone: true, createdOn: Timestamp.now(), updatedOn: Timestamp.now()),
    Task(id: "3", description: "One more demo task", isDone: false, createdOn: Timestamp.now(), updatedOn: Timestamp.now()),
  ];

  static final _controller = StreamController<List<Task>>.broadcast();

  FakeDataService() {
    // Emitimos la lista inicial
    _controller.add(List.from(_tasks));
  }

  Stream<List<Task>> getTasks() {
    return _controller.stream;
  }

  Future<void> addTask(Task task) async {
    final id = "${_tasks.length + 1}";
    _tasks.add(task.copyWith(id: id));
    _controller.add(List.from(_tasks));
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _controller.add(List.from(_tasks));
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    _controller.add(List.from(_tasks));
  }

  Future<bool> canAddTask() async {
    final count = _tasks.length;
    return count < 10;
  }
}

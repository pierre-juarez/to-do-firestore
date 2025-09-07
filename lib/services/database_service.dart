import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nowtask/helpers/logs.dart';
import 'package:nowtask/models/task_model.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Task> _taskRef;

  DatabaseService() {
    _taskRef = _firestore
        .collection('tb_tasks')
        .withConverter<Task>(
          fromFirestore: (snapshot, _) => Task.fromJSON(snapshot.data()!),
          toFirestore: (task, _) => task.toJSON(),
        );
  }

  Stream<QuerySnapshot<Task>> getTasks() {
    return _taskRef.orderBy('createdOn', descending: true).snapshots();
  }

  Future<bool> canAddTask() async {
    final snapshot = await _taskRef.get();
    return snapshot.size < 10;
  }

  Future<void> addTask(Task task) async {
    try {
      await _taskRef.add(task);
      infoLog("task added: ${task.description}");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskRef.doc(task.id).update(task.toJSON());
      infoLog("task_updated: ${task.description}");
    } catch (e) {
      errorLog("updating_task_error: ${e.toString().replaceAll("Exception: ", "")}");
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskRef.doc(id).delete();
      infoLog("task_deleted: $id");
    } catch (e) {
      errorLog("deleting_task_error: ${e.toString().replaceAll("Exception: ", "")}");
    }
  }
}

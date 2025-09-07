import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nowtask/helpers/show_alert.dart';
import 'package:nowtask/models/task_model.dart';
import 'package:nowtask/screens/add_task_screen.dart';
import 'package:nowtask/screens/modals/delete_confirmation_dialog.dart';
import 'package:nowtask/screens/modals/edit_task_modal.dart';
import 'package:nowtask/services/database_service.dart';
import 'package:nowtask/widgets/empty_state.dart';
import 'package:nowtask/widgets/task_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onToggleTheme, required this.isDark});

  final VoidCallback onToggleTheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();

    void updateTask(Task task) {
      final updatedTask = task.copyWith(isDone: !task.isDone, updatedOn: Timestamp.now());
      databaseService.updateTask(updatedTask);
    }

    void deleteTask(Task task) {
      databaseService.deleteTask(task.id!);
      showAlert(context, "Tarea eliminada con éxito!", AlertType.warning);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: onToggleTheme, icon: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny)),
        title: const Text('My tasks'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: databaseService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const EmptyState();
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index].data();
              task.id = tasks[index].id;
              return TaskItem(
                task: task,
                onToggleDone: () => updateTask(task),
                onEdit: () => showEditTaskModal(context, task),
                onDelete: () => showDeleteConfirmationDialog(context, () => deleteTask(task)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen())),
        label: const Text('New task'),
        icon: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

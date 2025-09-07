import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nowtask/helpers/logs.dart';
import 'package:nowtask/helpers/show_alert.dart';
import 'package:nowtask/models/task_model.dart';
import 'package:nowtask/services/fake_data_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _isLoading = false;

  final databaseService = FakeDataService();

  Future<void> _addTask() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _isLoading = true);

        final canAdd = await databaseService.canAddTask();
        if (!canAdd) {
          throw Exception("Máximo de 10 tareas alcanzado");
        }

        final task = Task(
          description: _titleController.text.trim(),
          isDone: false,
          createdOn: Timestamp.now(),
          updatedOn: Timestamp.now(),
        );

        await databaseService.addTask(task);

        setState(() => _isLoading = false);
        if (!mounted) return;
        Navigator.pop(context);
        showAlert(context, "¡Tarea agregada con éxito!", AlertType.info);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      errorLog("add task error: ${e.toString().replaceAll("Exception: ", "")}");
      final bool isPermissionDenied = e.toString().contains("cloud_firestore/permission-denied");
      final message = isPermissionDenied ? "Ya no se puede agregar más tareas" : e.toString().replaceAll("Exception: ", "");
      Navigator.pop(context);
      showAlert(context, message, AlertType.danger);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text('What do you need to do?', style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'E.g. Buy milk',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.edit_note_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                        onPressed: _addTask,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nowtask/models/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggleDone;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskItem({super.key, required this.task, this.onToggleDone, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = task.isDone;
    final updatedDate = DateFormat('dd/MM/yyyy • HH:mm a').format(task.updatedOn.toDate());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: GestureDetector(
          onTap: onToggleDone,
          child: Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: isDone ? Colors.green : theme.disabledColor,
            size: 28,
          ),
        ),
        title: Text(
          task.description,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? Colors.grey : theme.textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text('Edited on $updatedDate', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit?.call();
            if (value == 'delete') onDelete?.call();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
        ),
      ),
    );
  }
}

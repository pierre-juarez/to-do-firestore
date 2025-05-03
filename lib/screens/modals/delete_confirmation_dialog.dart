import 'package:flutter/material.dart';

Future<void> showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm) async {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete task?'),
          content: const Text('This action will permanently delete the task.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              icon: const Icon(Icons.delete_forever),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
  );
}

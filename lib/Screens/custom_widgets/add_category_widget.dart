import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../Backend/providers/task_provider.dart';
import 'custom_snackbars.dart';


class AddCategoryDialog {
  static Future<void> showAddCategoryDialog(BuildContext context) async {
    final TextEditingController _controller = TextEditingController();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter category name',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Get.back();
              CustomSnackBar.showError('Process Cancelled');
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              final categoryName = _controller.text.trim();
              if (categoryName.isNotEmpty) {
                taskProvider.addCategory(categoryName, context);
              } else {
                // Optionally show an error message
                CustomSnackBar.showError('Error: Category name cannot be empty');
              }
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

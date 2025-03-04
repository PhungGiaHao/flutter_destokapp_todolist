import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todolist/src/domain/entities/todo.dart';

class AddTodoDialog extends StatefulWidget {
  final Function(String title, String description, String priority) onSubmit;
  final Todo? todo;

  const AddTodoDialog({super.key, required this.onSubmit, this.todo});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPriority = 'Thấp';
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _selectedPriority = widget.todo!.priority;
    }
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _errorText = 'Tiêu đề không được để trống');
      return;
    }

    // Call onSubmit to send the data back
    widget.onSubmit(
      _titleController.text.trim(),
      _descriptionController.text.trim(),
      _selectedPriority,
    );

    Navigator.of(context).pop(); // Close the dialog after submitting
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.todo == null ? 'Thêm công việc' : 'Chỉnh sửa công việc',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Tiêu đề',
              prefixIcon: const Icon(FontAwesomeIcons.clipboard),
              errorText: _errorText,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Mô tả',
              prefixIcon: Icon(FontAwesomeIcons.penToSquare),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedPriority,
            items:
                ['Thấp', 'Trung bình', 'Cao']
                    .map(
                      (priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ),
                    )
                    .toList(),
            onChanged:
                (value) => setState(() => _selectedPriority = value ?? 'Thấp'),
            decoration: const InputDecoration(
              labelText: 'Mức độ ưu tiên',
              prefixIcon: Icon(FontAwesomeIcons.flag),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Hủy'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(onPressed: () => _submit(), child: const Text('Lưu')),
      ],
    );
  }
}

// priority_helper.dart
import 'package:flutter/material.dart';

Color getPriorityColor(String priority) {
  switch (priority) {
    case 'Cao':
      return Colors.red;
    case 'Trung bình':
      return Colors.orange;
    case 'Thấp':
    default:
      return Colors.green;
  }
}

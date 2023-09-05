import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DueDateController extends GetxController {
  Rx<DateTime?> dueDate = Rx<DateTime?>(null);

  Future<void> selectDueDate() async {
    final DateTime picked = (await Get.defaultDialog(
      title: 'Select Due Date',
      content: Container(
        child: Column(
          children: [
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              onDateChanged: (pickedDate) {
                dueDate.value = pickedDate;
                Get.back();
              },
            ),
          ],
        ),
      ),
    ))!;
  }
}

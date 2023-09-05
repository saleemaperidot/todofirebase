import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:todolist/controller/dateController.dart';

class DatepickerScreen extends StatefulWidget {
  DatepickerScreen({super.key});

  @override
  State<DatepickerScreen> createState() => _DatepickerScreenState();
}

class _DatepickerScreenState extends State<DatepickerScreen> {
  //final DueDateController _controller = Get.put(DueDateController());
  final DueDateController _controller = Get.find<DueDateController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.selectDueDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

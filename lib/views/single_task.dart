import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:todolist/Models/taskModel.dart';
import 'package:todolist/constants/constants.dart';
import 'package:todolist/controller/task_controller.dart';

class SingleTask extends StatefulWidget {
  SingleTask({super.key, required this.id});
  final String id;

  @override
  State<SingleTask> createState() => _SingleTaskState();
}

class _SingleTaskState extends State<SingleTask> {
  TaskModel? singletask;

  TaskController _taskController = Get.find<TaskController>();

  Future<void> task() async {
    final _singletask = await _taskController.fetchSingleTask(widget.id);
    setState(() {
      singletask = _singletask;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      task();
    });

    // singletask = await _taskController.fetchSingleTask(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                singletask == null
                    ? Center(
                        child: Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()),
                      )
                    : Container(
                        padding: EdgeInsets.all(10),
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(text: "Assigned on: ", style: txtStyle),
                              TextSpan(
                                  text: singletask!.assigneddate,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis))
                            ])),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(text: "Due on: ", style: txtStyle),
                              TextSpan(
                                  text: singletask!.duedate,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis))
                            ])),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  singletask!.taskname,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  singletask!.taskdiscription,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

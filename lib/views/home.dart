import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist/Models/taskModel.dart';
import 'package:todolist/constants/constants.dart';
import 'package:todolist/controller/auth_controller.dart';
import 'package:todolist/controller/dateController.dart';
import 'package:todolist/controller/mark_complte_controller.dart';
import 'package:todolist/controller/task_controller.dart';
import 'package:todolist/main.dart';
import 'package:todolist/utils/utils.dart';
import 'package:todolist/views/datepicker.dart';
import 'package:todolist/views/single_task.dart';

final DueDateController _controller = Get.put(DueDateController());
//final DueDateController _controller = Get.find<DueDateController>();

class Home extends StatelessWidget {
  Home({super.key});
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    final TaskController _taskController = Get.put(TaskController());
    //final AvatarController controller = Get.put(AvatarController());
    final AvatarController avatarController = Get.put(AvatarController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.find<AuthController>().signOut();
                Get.offAll(() => Root());
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
          child: Container(
        color: Colors.grey.withOpacity(0.2),
        child: Column(
          children: [
            Container(
              height: 160,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 250,
                    child: CupertinoSearchTextField(
                      prefixIcon: Icon(Icons.rocket),
                    ),
                  ),
                  ElevatedButton.icon(
                      // style:
                      // ButtonStyle(alignment: AlignmentDirectional.topStart),
                      label: Text("add"),
                      onPressed: () {
                        _showModalBottomSheet();
                      },
                      icon: Icon(Icons.add))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "pending",
                      style: txtStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 8,
                      child: Text("1"),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "completed",
                      style: txtStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      width: 30,
                      height: 20,
                      child: Center(child: Text("1/2")),
                    ),
                  ],
                ),
              ),
            ),
            _taskController.taskList.isEmpty
                ? EmptyWidget()
                : Expanded(
                    child: Obx(() {
                      return _taskController.taskList.isEmpty
                          ? EmptyWidget()
                          : ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                final List<TaskModel> _tasklist =
                                    _taskController.taskList;
                                print(
                                    "--------_tasklist${_taskController.taskList[index]}");
                                return Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1)),
                                    child: InkWell(
                                      onDoubleTap: () {
                                        Get.to(SingleTask(
                                            id: _tasklist[index].id));
                                      },
                                      child: ListTile(
                                        leading: Container(
                                          // Adjust the padding as needed
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  Colors.white, // Border color
                                              width: 1.0, // Border width
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              avatarController
                                                  .updateSelectedAvatar(index);
                                            },
                                            child: Obx(
                                              () => CircleAvatar(
                                                radius: 10.0,

                                                child: Icon(
                                                  Icons.done,
                                                  color: Colors.black,
                                                ),

                                                backgroundColor: avatarController
                                                            .selectedAvatarIndex
                                                            .value ==
                                                        index
                                                    ? Colors.blue
                                                    : Colors
                                                        .grey, // Avatar radius
                                                // Your image asset
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: Text(_tasklist[index].taskname),
                                        subtitle:
                                            Text(_tasklist[index].duedate!),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  await _taskController.delete(
                                                      _tasklist[index].id);
                                                  // Get.put(TaskController());
                                                },
                                                icon: Icon(
                                                    Icons.delete_outlined)),
                                            IconButton(
                                                onPressed: () async {
                                                  TaskModel task =
                                                      await _taskController
                                                          .fetchSingleTask(
                                                              _tasklist[index]
                                                                  .id);
                                                  _showEditModelBottomSheet(
                                                      task);
                                                },
                                                icon: Icon(
                                                    Icons.edit_note_outlined)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: _taskController.taskList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 15,
                                );
                              },
                            );
                    }),
                  ),
          ],
        ),
      )),
    );
  }

  void _showEditModelBottomSheet(TaskModel task) {
    TextEditingController taskname = TextEditingController();
    TextEditingController description = TextEditingController();
    taskname.text = task.taskname;
    description.text = task.taskdiscription;
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 450,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10), right: Radius.circular(10))),
          // Background color of the bottom sheet
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Edit task",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 350.0, // Set the width as needed
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0), // Optional padding
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Border color
                      width: 1.0, // Border width
                    ),
                    borderRadius:
                        BorderRadius.circular(5.0), // Optional border radius
                  ),
                  child: TextFormField(
                    controller: taskname,
                    decoration: InputDecoration(
                      hintText: 'Do maths homework',
                      border: InputBorder.none, // Hide the default border
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 400.0, // Set the width as needed
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0), // Optional padding
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Border color
                      width: 1.0, // Border width
                    ),
                    borderRadius:
                        BorderRadius.circular(5.0), // Optional border radius
                  ),
                  child: TextFormField(
                    maxLines: 4,
                    maxLength: 100,
                    controller: description,
                    decoration: InputDecoration(
                      hintText: 'Discription',
                      border: InputBorder.none, // Hide the default border
                    ),
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.alarm_on_outlined),
                  trailing: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('task')
                          ..doc(task.id).update({
                            "taskname": taskname.text,
                            "taskdiscription": description.text,
                            "duedate": "11-12-2023",
                            "ComplettionStaus": false,
                            "assigneddate": DateTime.now().toString(),
                          });
                        Get.put(TaskController());
                        Get.back();
                      },
                      icon: Icon(Icons.send)),
                ),

                // Add more list items as needed
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true, // Use true for a modal bottom sheet
    );
  }
}

void _showModalBottomSheet() {
  TextEditingController tasknameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Get.bottomSheet(
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 450,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(10), right: Radius.circular(10))),
        // Background color of the bottom sheet
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                "Add task",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 400.0, // Set the width as needed
                padding:
                    EdgeInsets.symmetric(horizontal: 10.0), // Optional padding
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue, // Border color
                    width: 1.0, // Border width
                  ),
                  borderRadius:
                      BorderRadius.circular(5.0), // Optional border radius
                ),
                child: TextFormField(
                  controller: tasknameController,
                  decoration: InputDecoration(
                    hintText: 'Do maths homework',
                    border: InputBorder.none, // Hide the default border
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350.0, // Set the width as needed
                padding:
                    EdgeInsets.symmetric(horizontal: 10.0), // Optional padding
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue, // Border color
                    width: 1.0, // Border width
                  ),
                  borderRadius:
                      BorderRadius.circular(5.0), // Optional border radius
                ),
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  maxLength: 100,
                  decoration: InputDecoration(
                    hintText: 'Discription',
                    border: InputBorder.none, // Hide the default border
                  ),
                ),
              ),

              ListTile(
                leading: Icon(Icons.alarm_on_outlined),
                trailing: IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('task')
                          .add({
                        "taskname": tasknameController.text,
                        "taskdiscription": descriptionController.text,
                        "duedate": "11-12-2023",
                        "ComplettionStaus": false,
                        "assigneddate": DateTime.now().toString(),
                      });

                      // TaskController controller = Get.find<TaskController>();
                      // controller.getTask();
                      Get.back();
                    },
                    icon: Icon(Icons.send)),
              ),

              // Add more list items as needed
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true, // Use true for a modal bottom sheet
  );
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: [
        Container(
          width: 100,
          height: 100,
          child: Icon(
            Icons.edit_note_outlined,
            size: 100,
            color: Colors.blueGrey,
          ),
          //child: Image(image: AssetImage('assets/empy.jpg'))
        ),
        SizedBox(
          height: 50,
        ),
        Center(
          child: Container(
            width: 270,
            child: Text(
                "You dont have any task yet\nstart adding task and manage your time efficiently"),
          ),
        )
      ],
    );
  }
}

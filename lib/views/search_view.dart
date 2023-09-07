import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:todolist/controller/search_controller.dart';
import 'package:todolist/controller/task_controller.dart';
import 'package:todolist/views/home.dart';
import 'package:todolist/views/single_task.dart';

import '../Models/taskModel.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController _taskController = Get.find<TaskController>();
    SearchController searchController = Get.find<SearchController>();
    print("search result${searchController.searchList}");
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        final searchlist = searchController.searchList;
        final searchResult = searchController.searchListModified[index];
        print("search list=$searchlist");
        // final List<TaskModel> _tasklist = _taskController.taskList;
        // print("--------_tasklist${_taskController.taskList[index]}");
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
            child: InkWell(
              onTap: () {
                Get.to(SingleTask(
                    id: searchController.searchListModified[index].id));
              },
              child: ListTile(
                leading: LeadingListtile(status: searchResult.status),
                title: Text(searchResult.taskname),
                subtitle: Text(searchResult.duedate!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () async {
                          await _taskController.delete(
                              searchController.searchListModified[index].id);
                          Get.put(TaskController());
                        },
                        icon: Icon(Icons.delete_outlined)),
                    IconButton(
                        onPressed: () async {
                          TaskModel task = await _taskController
                              .fetchSingleTask(searchController
                                  .searchListModified[index].id);
                          _showEditModelBottomSheet(task);
                        },
                        icon: Icon(Icons.edit_note_outlined)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: searchController.searchListModified.length,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 15,
        );
      },
    );
  }

  void _showEditModelBottomSheet(TaskModel task) {
    TextEditingController taskname = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController datecontroller = TextEditingController();
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
                    controller: datecontroller,
                    decoration: InputDecoration(
                      hintText: 'dd-mm-yyyy',
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
                            "assigneddate": formattedDate.toString(),
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

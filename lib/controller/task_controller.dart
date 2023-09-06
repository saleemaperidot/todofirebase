import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todolist/Models/taskModel.dart';

class TaskController extends GetxController {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  RxList<TaskModel> taskList = <TaskModel>[].obs;
  RxInt pendingTaskCount = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    taskList.bindStream(
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('task')
          .snapshots()
          .map(
        (query) {
          List<TaskModel> tasks = [];
          query.docs.forEach((element) {
            TaskModel task = TaskModel.fromQuerySnapShort(element);
            tasks.add(task);
          });

          print("task in controller$tasks");
          return tasks;
        },
      ),
    );

    getPendingTask();
  }

  void getPendingTask() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('task')
        .where('ComplettionStaus', isEqualTo: false)
        .get();
    pendingTaskCount.value = querySnapshot.size;
    print(pendingTaskCount);
  }

  void getTask() {
    taskList.clear();
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('task')
        .snapshots()
        .map(
      (query) {
        List<TaskModel> tasks = [];
        query.docs.forEach((element) {
          TaskModel task = TaskModel.fromQuerySnapShort(element);
          tasks.add(task);
        });
        taskList.addAll(tasks);
        print("task in controller$tasks");
        return tasks;
      },
    );
  }

  Future<void> delete(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('task')
        .doc(id)
        .delete();
  }

  Future<TaskModel> fetchSingleTask(String id) async {
    late TaskModel task;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('task')
        .doc(id)
        .get()
        .then((value) {
      // TaskModel task = TaskModel.fromQuerySnapShort(documentSnapshot.data());

      print(value['taskname']);
      task = TaskModel.fromDocumentSnapshort(value);
      print(task);

      // TaskModel(value.id, value['taskname'], value[''], assigneddate, duedate, status)
    });
    return task;
  }

  void updateTask(String id, TaskModel task) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('task')
        .doc(id)
        .update({
      "taskname": task.taskname,
      "taskdiscription": task.taskdiscription,
      "duedate": "11-12-2023",
      "ComplettionStaus": false,
      "assigneddate": DateTime.now(),
    });
  }
}

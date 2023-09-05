import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todolist/Models/taskModel.dart';

class TaskController extends GetxController {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  RxList<TaskModel> taskList = <TaskModel>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    taskList.bindStream(FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('task')
        .snapshots()
        .map((query) {
      List<TaskModel> tasks = [];
      query.docs.forEach((element) {
        TaskModel task = TaskModel.fromQuerySnapShort(element);
        tasks.add(task);
      });
      print("task in controller$tasks");
      return tasks;
    }));
  }
}

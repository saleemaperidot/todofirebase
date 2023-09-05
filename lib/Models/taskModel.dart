import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  late String id;
  late String taskname;
  late String taskdiscription;
  late Timestamp? duedate;
  late bool status;
  late Timestamp assigneddate;
  TaskModel(this.id, this.taskname, this.taskdiscription, this.assigneddate,
      this.duedate, this.status);
  TaskModel.fromQuerySnapShort(QueryDocumentSnapshot<Object?> query) {}
}

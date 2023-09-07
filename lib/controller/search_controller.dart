import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todolist/Models/taskModel.dart';

class SearchController extends GetxController {
  var searchIndicator = false.obs;
  var searchQuery = ''.obs; // Observable string to track the search query
  var searchResults = [].obs; // Observable list to store search results
  String uid = FirebaseAuth.instance.currentUser!.uid;
  RxList<dynamic> searchList = <dynamic>[].obs;
  RxList<TaskModel> searchListModified = <TaskModel>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    search();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    search();
  }

  void search() async {
    print("search called");
    print(searchQuery.value);
    searchResults.clear();
    searchList.clear();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('task')
          //.where('taskname', isEqualTo: searchQuery.value)
          .where('taskname', isGreaterThanOrEqualTo: searchQuery.value)
          .where('taskname', isLessThanOrEqualTo: searchQuery.value + '\uf8ff')
          .get();
      // TaskModel.fromQuerySnapShort(querySnapshot);
      // Task
      searchListModified.clear();
      querySnapshot.docs.forEach((element) {
        TaskModel searchresultM = TaskModel.fromQuerySnapShort(element);
        searchListModified.add(searchresultM);
        print(searchresultM.id);
      });
      print("searchListModified$searchListModified");
      print(querySnapshot);
      var list = querySnapshot.docs.map((doc) => doc.data()).toList();
      searchResults.addAll(list);
      print(list[0]['taskname']);
      searchList.addAll(list);
      print(searchResults.value);
    } catch (e) {
      log(e.toString());
    }
  }

  void searchModified() async {
    print("search called");
    print(searchQuery.value);
    searchResults.clear();
    searchList.clear();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('task')
          //.where('taskname', isEqualTo: searchQuery.value)
          .where('taskname', isGreaterThanOrEqualTo: searchQuery.value)
          .where('taskname', isLessThanOrEqualTo: searchQuery.value + '\uf8ff')
          .get();
      // TaskModel.fromQuerySnapShort(querySnapshot);
      // Task
      print(querySnapshot);

      querySnapshot.docs.forEach((element) {
        TaskModel searchresult = TaskModel.fromQuerySnapShort(element);
        searchListModified.add(searchresult);
        print(searchresult.id);
      });

      var list = querySnapshot.docs.map((doc) => doc.data()).toList();
      searchResults.addAll(list);
      print(list[0]['taskname']);
      searchList.addAll(list);
      print(searchResults.value);
    } catch (e) {
      log(e.toString());
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:todolist/constants/constants.dart';
import 'package:todolist/controller/auth_controller.dart';
import 'package:todolist/main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      height: 60,
                      decoration:
                          BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                      child: ListTile(
                        leading: Container(
                          // Adjust the padding as needed
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 10.0,

                            child: Icon(
                              Icons.done,
                              color: Colors.black,
                            ),

                            backgroundColor: Colors.blue, // Avatar radius
                            // Your image asset
                          ),
                        ),
                        title: Text("Maths Home work"),
                        subtitle: Text("21 may 2023"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.delete_outlined)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.edit_note_outlined)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 10,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 15,
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

void _showModalBottomSheet() {
  Get.bottomSheet(
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 300,
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
                  decoration: InputDecoration(
                    hintText: 'Do maths homework',
                    border: InputBorder.none, // Hide the default border
                  ),
                ),
              ),
              Text("Discription"),
              ListTile(
                leading: Icon(Icons.alarm_on_outlined),
                trailing: Icon(Icons.send),
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

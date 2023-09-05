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
          child: Stack(
        children: [
          Container(
            height: 400,
            child: Text("saleema\n\n\n"),
          ),
          Positioned(
            child: Container(
              color: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 250,
                          child: CupertinoSearchTextField(
                            prefixIcon: Icon(Icons.rocket),
                          ),
                        ),
                        ElevatedButton(onPressed: () {}, child: Text("add"))
                      ],
                    ),
                    ListTile(
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
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1)),
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

                                    backgroundColor:
                                        Colors.blue, // Avatar radius
                                    // Your image asset
                                  ),
                                ),
                                title: Text("Maths Home work"),
                                subtitle: Text("21 may 2023"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.delete),
                                    Icon(Icons.edit)
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
              ),
            ),
          ),
        ],
      )),
    );
  }
}

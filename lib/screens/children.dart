import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/controllers/babysitters_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/controllers/invitations_controller.dart';
import 'package:flutter_client/controllers/users_controller.dart';
import 'package:flutter_client/models/children_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class Children extends StatefulWidget {
  const Children({ Key? key }) : super(key: key);

  @override
  _ChildrenState createState() => _ChildrenState();
}

class _ChildrenState extends State<Children> {
  final ChildrenController cc = Get.find();

  final childNameController = new TextEditingController();
  final dateOfBirthController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    cc.getChildren();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        if (cc.loading.isTrue)
          return CircularProgressIndicator();
        else if(cc.count.value == 0)
          return Center(
          child: Text("No childrens"),
        );
        else
          return Column(
            children: <Widget>[
              Container(height: 20),
              Text(
                "List of children",
                style: TextStyle(fontSize: 25),
              ),
              Container(height: 20),
              Expanded(
                child: ListView.builder(
                    itemCount: cc.count.value,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            cc.currentChild.value = cc.children[index];
                            Get.toNamed("/activities");
                          },
                          onLongPress: () {
                            cc.currentChild.value = cc.children[index];
                            Get.defaultDialog(
                                title: '',
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Do you wish to delete this child?"),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        cc
                                            .deleteChild(
                                                cc.currentChild.value.childId!)
                                            .then((value) => {
                                                  if (value is ChildrenResponse)
                                                    {print('ok')}
                                                  else
                                                    Get.defaultDialog(
                                                        middleText:
                                                            value.message)
                                                });
                                        Get.back();
                                      },
                                      child: Text(
                                        'DELETE CHILD',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    )
                                  ],
                                ),
                                radius: 10.0);
                          },
                          title: Text(
                            "${cc.children[index].name}",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              cc.currentChild.value = cc.children[index];
                              Get.toNamed('/babysitters');
                            },
                            child: Text('show babysitters'),
                          ));
                    }),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  Get.defaultDialog(
                      title: '',
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: childNameController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'Child name',
                                hintMaxLines: 1,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 4.0))),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: dateOfBirthController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'Date of birth',
                                hintMaxLines: 1,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 4.0))),
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2050));
                              dateOfBirthController.text =
                                  date.toString().substring(0, 10);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              cc.addChild(childNameController.text,
                                  dateOfBirthController.text);
                              cc.getChildren();
                              Get.back();
                              childNameController.clear();
                              dateOfBirthController.clear();
                            },
                            child: Text(
                              'ADD CHILD',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          )
                        ],
                      ),
                      radius: 10.0);
                },
                label: Text("Add Child"),
                icon: const Icon(Icons.child_care,
                size:  40,),
                backgroundColor: Colors.blue,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
      },);
  }
}
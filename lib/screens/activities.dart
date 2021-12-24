import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/activities_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/models/activities_response.dart';
import 'package:get/get.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final ChildrenController cc = Get.find();
  //final ActivitiesController act = Get.put(ActivitiesController());
  final ActivitiesController act = Get.find();

  final activityController = new TextEditingController();
  final notesController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    act.getActivities(cc.currentChild.value.childId!);
    act.date.value = DateTime.now().toString().substring(0, 10);
  }

  void getInitialActivities() {
    act.getActivities(cc.currentChild.value.childId!);
    print(act.newActivities.value);
  }

  void _openAddActivityDialog() {
    Get.defaultDialog(
        title: '',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: activityController,
              keyboardType: TextInputType.text,
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: 'Activity',
                  hintMaxLines: 1,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 4.0))),
            ),
            SizedBox(height: 10),
            TextField(
              controller: notesController,
              keyboardType: TextInputType.text,
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: 'Notes',
                  hintMaxLines: 1,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 4.0))),
            ),
            SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                act.addActivity(activityController.text, notesController.text,
                    cc.currentChild.value.childId!);
                //act.getActivities(cc.currentChild.value.childId!);
                Get.back();
                activityController.clear();
                notesController.clear();
              },
              child: Text(
                'ADD ACTIVITY',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            )
          ],
        ),
        radius: 10.0);
  }

  void openAddActivityDialog(String value) {
    Get.defaultDialog(
        title: value,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            TextField(
              controller: notesController,
              keyboardType: TextInputType.text,
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: 'Notes',
                  hintMaxLines: 1,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 4.0))),
            ),
            SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                act.addActivity(value, notesController.text,
                    cc.currentChild.value.childId!);
                Get.back();
                notesController.clear();
              },
              child: Text(
                'ADD ACTIVITY',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            )
          ],
        ),
        radius: 10.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        appBar: AppBar(
          centerTitle: true,
          title: Text("${cc.currentChild.value.name}'s activities"),
        ),
        body: Obx(() {
          if (act.loading.isTrue)
            return CircularProgressIndicator();
          else
            return Column(
              children: <Widget>[
                Container(
                  child: CupertinoDatePicker(
                    onDateTimeChanged: (DateTime time) {
                      act.date.value = time.toString().substring(0, 10);
                      act.getActivitiesByDate();
                    },
                    mode: CupertinoDatePickerMode.date,
                  ),
                  height: 40,
                ),
                Expanded(
                    child: ListView.separated(
                        itemCount: act.newActivities.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              thickness: 0.5,
                            ),
                        itemBuilder: (context, index) {
                          return Obx(() => ListTile(
                                onLongPress: () {
                                  act.currentActivity.value =
                                      act.newActivities[index];
                                  Get.defaultDialog(
                                      title: '',
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              "Do you wish to delete this activity?"),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              act.deleteActivity(
                                                  act.currentActivity.value
                                                      .activityId!,
                                                  cc.currentChild.value
                                                      .childId!);
                                              Get.back();
                                            },
                                            child: Text(
                                              'DELETE ACTIVITY',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0),
                                            ),
                                          )
                                        ],
                                      ),
                                      radius: 10.0);
                                },
                                onTap: () {},
                                title:
                                    Text("${act.newActivities[index].action}"),
                                subtitle: Column(
                                  children: <Widget>[
                                    Text("${act.newActivities[index].notes}"),
                                    Text(
                                        "${act.newActivities[index].postTime!.substring(0, 16).replaceAll('T', ' ')}"),
                                    Text(
                                        "Author: ${act.newActivities[index].author!.username}"),
                                  ],
                                ),
                                trailing: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () {
                                    act.currentActivity.value =
                                        act.newActivities[index];
                                    var editController =
                                        new TextEditingController(
                                            text: act
                                                .newActivities[index].action);
                                    var editNotesController =
                                        new TextEditingController(
                                            text:
                                                act.newActivities[index].notes);
                                    Get.defaultDialog(
                                        title: '',
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: editController,
                                              keyboardType: TextInputType.text,
                                              maxLines: 2,
                                              decoration: InputDecoration(
                                                  labelText: 'Activity',
                                                  hintMaxLines: 1,
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.green,
                                                          width: 4.0))),
                                            ),
                                            SizedBox(height: 10),
                                            TextField(
                                              controller: editNotesController,
                                              keyboardType: TextInputType.text,
                                              maxLines: 2,
                                              decoration: InputDecoration(
                                                  labelText: 'Notes',
                                                  hintMaxLines: 1,
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.green,
                                                          width: 4.0))),
                                            ),
                                            SizedBox(
                                              height: 30.0,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                act
                                                    .editActivity2(
                                                        act.currentActivity
                                                            .value.activityId!,
                                                        cc.currentChild.value
                                                            .childId!,
                                                        editController.text,
                                                        editNotesController
                                                            .text)
                                                    .then((value) => {
                                                          if (value
                                                              is ActivityResponse)
                                                            {print('ok')}
                                                          else
                                                            Get.defaultDialog(
                                                                middleText: value
                                                                    .message)
                                                        });
                                                Get.back();
                                              },
                                              child: Text(
                                                'EDIT ACTIVITY',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0),
                                              ),
                                            )
                                          ],
                                        ),
                                        radius: 10.0);
                                  },
                                  child: const Text('Edit'),
                                ),
                              ));
                        })),
                FloatingActionButton.extended(
                  onPressed: _openAddActivityDialog,
                  label: Text("Add Activity"),
                  icon: const Icon(Icons.note_add),
                  backgroundColor: Colors.blue,
                ),
                PopupMenuButton(
                    iconSize: 70,
                    icon: Icon(Icons.add_circle_rounded, color: Colors.blue[500]),
                    onSelected: (String value) {
                      openAddActivityDialog(value);
                    },
                    itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            child: ListTile(
                              trailing: Icon(Icons.baby_changing_station),
                              title: Text('Diaper change'),
                            ),
                            value: 'Diaper change',
                          ),
                          PopupMenuItem(
                              child: ListTile(
                                trailing: Icon(Icons.child_friendly),
                                title: Text('Walk'),
                              ),
                              value: 'Walk'),
                          PopupMenuItem(
                              child: ListTile(
                                trailing: Icon(Icons.food_bank),
                                title: Text('Feeding'),
                              ),
                              value: 'Feeding'),
                          PopupMenuItem(
                              child: ListTile(
                                trailing: Icon(Icons.work),
                                title: Text('Working a lot harder'),
                              ),
                              value: '4'),
                          PopupMenuItem(
                              child: ListTile(
                                trailing: Icon(Icons.work),
                                title: Text('Working a lot harder'),
                              ),
                              value: '5'),
                          PopupMenuItem(
                              child: ListTile(
                                trailing: Icon(Icons.send),
                                title: Container(
                                  height: 45,
                                  child: TextField(
                                    controller: activityController,
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        labelText: 'Other',
                                        hintMaxLines: 1,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green,
                                                width: 4.0))),
                                              ),
                                ),
                              ),
                              value: activityController.text),
                        ]),
              ],
            );
        }));
  }
}

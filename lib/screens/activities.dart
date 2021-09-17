import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/activities_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
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

  @override
  void initState() {
    super.initState();
    act.getActivities(cc.currentChild.value.childId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${cc.currentChild.value.name}'s"),
        ),
        body: Obx(() {
          if (act.loading.isTrue)
            return CircularProgressIndicator();
          else
            return Column(
              children: <Widget>[
                Container(height: 20),
                Obx(() {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: act.count.value,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onLongPress: () {
                                act.currentActivity.value =
                                    act.activities[index];
                                Get.defaultDialog(
                                    title: '',
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Do you wish to delete this activity?"),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            act.deleteActivity(
                                                act.currentActivity.value.activityId!,
                                                cc.currentChild.value.childId!);
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
                              onTap: () {
                              },
                              title: Text("${act.activities[index].action}"),
                              subtitle: Column(
                                children: <Widget>[
                                  Text("${act.activities[index].postTime}"),
                                  Text(
                                      "Author: ${act.activities[index].author!.username}"),
                                ],
                              ),
                              trailing: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 15),
                                ),
                                onPressed: () {
                                  act.currentActivity.value = act.activities[index];
                                  var editController = new TextEditingController(text: act.activities[index].action);
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
                                                      color: Colors.green, width: 4.0))),
                                        ),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            act.editActivity(act.currentActivity.value.activityId!,cc.currentChild.value.childId!,editController.text);
                                            act.getActivities(cc.currentChild.value.childId!);
                                            Get.back();
                                          },
                                          child: Text(
                                            'EDIT ACTIVITY',
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 16.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    radius: 10.0);
                                },
                                child: const Text('Edit'),
                              ),
                              );
                          }));
                }),
                FloatingActionButton.extended(
                  onPressed: () {
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
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 4.0))),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                act.addActivity(activityController.text,
                                    cc.currentChild.value.childId!);
                                //act.getActivities(cc.currentChild.value.childId!);
                                Get.back();
                                activityController.clear();
                              },
                              child: Text(
                                'ADD ACTIVITY',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            )
                          ],
                        ),
                        radius: 10.0);
                  },
                  label: Text("Add Activity"),
                  icon: const Icon(Icons.note_add),
                  backgroundColor: Colors.blue,
                ),
              ],
            );
        }));
  }
}

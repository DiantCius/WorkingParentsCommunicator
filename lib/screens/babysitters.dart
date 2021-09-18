import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/babysitters_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:get/get.dart';

class Babysitters extends StatefulWidget {
  const Babysitters({ Key? key }) : super(key: key);

  @override
  _BabysittersState createState() => _BabysittersState();
}

class _BabysittersState extends State<Babysitters> {

  final ChildrenController cc = Get.find();
  final BabysittersController bs = Get.find();

   @override
  void initState() {
    super.initState();
    bs.getBabysittersForChild(cc.currentChild.value.childId!);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${cc.currentChild.value.name}'s"),
        ),
        body: Obx(() {
          if (bs.loading.isTrue)
            return CircularProgressIndicator();
          else
            return Column(
              children: <Widget>[
                Container(height: 20),
                Obx(() {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: bs.count.value,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onLongPress: () {
                              },
                              onTap: () {
                              },
                              title: Text("${bs.babysitters[index].username}"),
                              subtitle: Column(
                                children: <Widget>[
                                  Text("${bs.babysitters[index].email}"),
                                ],
                              ),
                              );
                          }));
                }),
                FloatingActionButton.extended(
                  onPressed: () {
                   Get.toNamed('/searchBabysitters');
                  },
                  label: Text("Add Babysitter"),
                  icon: const Icon(Icons.note_add),
                  backgroundColor: Colors.blue,
                ),
              ],
            );
        }));
  }
}
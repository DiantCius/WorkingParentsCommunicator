import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/babysitters_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/models/babysitters_response.dart';
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
          title: Text("${cc.currentChild.value.name}'s babysitters"),
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
                                bs.currentBabysitter.value =
                                bs.babysitters[index];
                                Get.defaultDialog(
                                    title: '',
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            "Do you wish to delete this babysitter?"),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            bs.deleteBabysitter(bs.currentBabysitter.value.username!, cc.currentChild.value.childId!)
                                              .then((value) => {
                                                    if (value
                                                        is BabysittersResponse)
                                                      {print('ok')}
                                                    else
                                                      Get.defaultDialog(
                                                          middleText:
                                                              value.message)
                                                  });
                                            Get.back();
                                          },
                                          child: Text(
                                            'DELETE BABYSITTER',
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
                  label: Text("Invite Babysitter"),
                  icon: const Icon(Icons.note_add),
                  backgroundColor: Colors.blue,
                ),
                //Text(bs.currentBabysitter.value.username!),
                //Text(cc.currentChild.value.childId.toString()),
              ],
            );
        }));
  }
}
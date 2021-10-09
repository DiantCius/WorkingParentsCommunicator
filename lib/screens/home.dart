import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/controllers/babysitters_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/models/child.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final AuthController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(homeScreen);
  }

  Widget homeScreen() {
    if (ac.isLoggedIn.isTrue) {
      return HomeUnlocked();
    } else
      return HomeLocked();
  }
}

class HomeLocked extends StatelessWidget {
  HomeLocked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Communicator ',
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: [
            ElevatedButton(
                child: Text("Log in"), onPressed: () => Get.toNamed("/login")),
            ElevatedButton(
                child: Text("Sign up"),
                onPressed: () => Get.toNamed("/signup")),
          ],
        ));
  }
}

class HomeUnlocked extends StatefulWidget {
  const HomeUnlocked({Key? key}) : super(key: key);

  @override
  _HomeUnlockedState createState() => _HomeUnlockedState();
}

class _HomeUnlockedState extends State<HomeUnlocked> {
  final AuthController ac = Get.find();
  final FlutterSecureStorage storage = Get.find();
  //final ChildrenController cc = Get.put(ChildrenController());
  final ChildrenController cc = Get.find();
  final BabysittersController bs = Get.find();

  final childNameController = new TextEditingController();
  final dateOfBirthController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    cc.getChildren();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Communicator ',
            textAlign: TextAlign.center,
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('get token'),
                onTap: () {
                  storage.read(key: 'jwt').then((value) => {
                        if (value == null)
                          Get.defaultDialog(middleText: 'no token')
                        else
                          Get.defaultDialog(middleText: value)
                      });
                },
              ),
              ListTile(
                title: const Text('reload children'),
                onTap: () {
                  cc.getChildren();
                },
              ),
              ListTile(
                title: const Text('Log out'),
                onTap: () {
                  ac.logOut();
                  Get.toNamed('/login');
                  Get.defaultDialog(middleText: 'You have logged out');
                },
              ),
            ],
          ),
        ),
        body: Obx(() {
          if (cc.loading.isTrue)
            return CircularProgressIndicator();
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
                            title: Text(
                              "${cc.children[index].name}",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                /*Container(
                                  height: 200.0,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Babysitters:',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: bs.count.value,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text('${bs.babysitters[index].username}',
                                                textAlign: TextAlign.center),
                                          );
                                        },
                                      ),
                                    ],
                                  )),*/
                                /*TextButton(
                                    child: Text('Add Babysitter'),
                                    onPressed: () {
                                      /*Get.defaultDialog(
                                      title: '',
                                      content: Container(
                                        height: 300.0,
                                        width: 300.0,
                                        child: ListView.builder(
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text('Gujarat, India'),
                                            );
                                          },
                                        ),
                                      ),
                                    );*/
                                      cc.currentChild.value =
                                          cc.children[index];
                                      Get.toNamed('/searchBabysitters');
                                    }),*/
                              ],
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
                  icon: const Icon(Icons.note_add),
                  backgroundColor: Colors.blue,
                ),
              ],
            );
        }));
  }
}

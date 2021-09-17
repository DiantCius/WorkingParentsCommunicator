import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/auth_controller.dart';
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
                              Container(
                                  height: 400.0,
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
                                        itemCount: 3,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text('dupa',
                                                textAlign: TextAlign.center),
                                          );
                                        },
                                      ),
                                    ],
                                  )),
                              TextButton(
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
                                    cc.currentChild.value = cc.children[index];
                                    Get.toNamed('/searchBabysitters');
                                  }),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: new Icon(Icons.more_vert)),
                        );
                      }),
                )
              ],
            );
        }));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/auth_controller.dart';
import 'package:flutter_client/controllers/babysitters_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/controllers/home_controller.dart';
import 'package:flutter_client/controllers/invitations_controller.dart';
import 'package:flutter_client/controllers/users_controller.dart';
import 'package:flutter_client/models/children_response.dart';
import 'package:flutter_client/screens/children.dart';
import 'package:flutter_client/screens/invitations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'chats.dart';

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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed("/login");
              },
              child: Text(
                ' Log in  ',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed("/signup");
              },
              child: Text(
                'Sign up ',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }
}

class HomeUnlocked extends StatefulWidget {
  const HomeUnlocked({Key? key}) : super(key: key);

  @override
  _HomeUnlockedState createState() => _HomeUnlockedState();
}

class _HomeUnlockedState extends State<HomeUnlocked> {
  final AuthController ac = Get.find();
  //final FlutterSecureStorage storage = Get.find();
  //final ChildrenController cc = Get.find();
  //final BabysittersController bs = Get.find();
  //final InvitationsController inv = Get.find();
  final UsersController uc = Get.find();
  final HomeController hc = Get.find();

  final childNameController = new TextEditingController();
  final dateOfBirthController = new TextEditingController();

  //int _currentIndex = 0;
  List _screens = [Children(), Chats(), Invitations()];

  @override
  void initState() {
    super.initState();
    //cc.getChildren();
    uc.getCurrentUser();
  }

  /*void _setCurrentIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }*/

  Widget customDrawer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text("${uc.currentUser.value.email}"),
            ),
            /*ListTile(
              title: Text('Invitations'),
              onTap: () {
                Get.toNamed('/invitations');
              },
            ),*/
            ListTile(
              title: const Text('Log out'),
              onTap: () {
                ac.logOut();
                Get.toNamed('/login');
                Get.defaultDialog(middleText: 'You have logged out');
              },
            ),
            /*ListTile(
              title: const Text('chats'),
              onTap: () {
                Get.toNamed('/chats');
              },
            ),*/
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Communicator ',
              textAlign: TextAlign.center,
            ),
          ),
          drawer: customDrawer(),
          body: _screens[hc.index.value],
          bottomNavigationBar: BottomNavigationBar(
            iconSize: 28,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: Colors.blue[700],
            type: BottomNavigationBarType.fixed,
            currentIndex: hc.index.value,
            onTap: hc.setIndex,
            items: [
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: "Chats",
                icon: Icon(Icons.message),
              ),
              BottomNavigationBarItem(
                label: "Invitations",
                icon: Icon(Icons.notification_add),
              ),
            ],
          ),
        ));
  }

  /*Widget homeBody()
  {
    return Obx(() {
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
  }*/
}

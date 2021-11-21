import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/babysitters_controller.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/controllers/users_controller.dart';
import 'package:flutter_client/models/error_response.dart';
import 'package:get/get.dart';

class SearchBabysitters extends StatefulWidget {
  const SearchBabysitters({Key? key}) : super(key: key);

  @override
  _SearchBabysittersState createState() => _SearchBabysittersState();
}

class _SearchBabysittersState extends State<SearchBabysitters> {
  final BabysittersController bc = Get.find();
  final ChildrenController cc = Get.find();
  final UsersController uc = Get.find();
  var isSearchOpened = true.obs;
  var searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    uc.getUsers(cc.currentChild.value.childId!);
    uc.newUserList.value = uc.returnUsers();
    uc.getCurrentUser();
  }

  onSearchFieldChanged(String value) {
    if (value.isEmpty) {
      uc.newUserList.value = uc.returnUsers();
    } else {
      uc.newUserList.value = uc.users
          .where((user) =>
              user.username!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }

  Widget _buildTitle() {
    if (isSearchOpened.isTrue)
      return TextField(
        controller: searchController,
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: 'Search...',
          hintMaxLines: 1,
        ),
        onChanged: onSearchFieldChanged,
      );
    else
      return Text(
        'Choose babysitter ',
        textAlign: TextAlign.center,
      );
  }

  Widget trailing(String currentUserEmail, int index) {
    uc.currentListUser.value = uc.newUserList[index];
    if (uc.currentUser.value.email == uc.currentListUser.value.invitedBy)
      return Text('Already invited');
    else
      return TextButton(
        onPressed: () {
          uc
              .createInvitation(cc.currentChild.value.childId!,
                  uc.currentListUser.value.email!)
              .then((value) => {
                    if (value is ErrorResponse)
                      {Get.defaultDialog(middleText: value.message)}
                    else
                      {print('ok')}
                  });
        },
        child: Text('Invite'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() => _buildTitle()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            bc.getBabysittersForChild(cc.currentChild.value.childId!);
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                isSearchOpened.value = !isSearchOpened.value;
              },
              icon: Icon(Icons.search)),
        ],
      ),
      body: Obx(() {
        if (uc.loading.isTrue)
          return CircularProgressIndicator();
        else if (uc.newUserList.length == 0)
          return Text('');
        else {
          if (isSearchOpened.isFalse)
            return Text('');
          else
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: uc.newUserList.length,
                    itemBuilder: (context, index) {
                      return Obx(() => ListTile(
                          title: Text(uc.newUserList[index].username!),
                          subtitle: Column(
                            children: [
                              Text(uc.newUserList[index].email!),
                            ],
                          ),
                          trailing: uc.newUserList[index].invitedBy == uc.currentUser.value.email ? Text('Already invited') : TextButton(
                            onPressed: () {
                              uc.currentListUser.value = uc.newUserList[index];
                              uc.createInvitation(cc.currentChild.value.childId!,uc.currentListUser.value.email!).then((value) => {
                                if (value is ErrorResponse)
                                  {
                                    Get.defaultDialog(
                                        middleText: value.message)
                                  }
                                else
                                  {print('ok')}
                              });
                            },
                            child: Text('Invite'),
                          )
                      ));
                    },
                  ),
                ),
                Text(uc.newUserList.first.username!),
                Text(uc.currentUser.value.email!)
              ],
            );
        }
      }),
    );
  }
}

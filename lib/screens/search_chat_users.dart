import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/chat_users_controller.dart';
import 'package:flutter_client/controllers/chats_controller.dart';
import 'package:get/get.dart';

class SearchChatUsers extends StatefulWidget {
  const SearchChatUsers({Key? key}) : super(key: key);

  @override
  _SearchChatUsersState createState() => _SearchChatUsersState();
}

class _SearchChatUsersState extends State<SearchChatUsers> {
  final ChatUsersController cuc = Get.find();
  final ChatsController cc = Get.find();
  var isSearchOpened = true.obs;
  var searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    cuc.getUsers(cc.currentChat.value.chatId!);
    cuc.newUserList.value = cuc.returnUsers();
  }

  _onSearch(String value) {
    if (value.isEmpty) {
      cuc.newUserList.value = cuc.returnUsers();
    } else {
      cuc.newUserList.value = cuc.users
          .where((user) =>
              user.username!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }

  Widget _buildTitle() {
    if (isSearchOpened.isTrue)
      return TextField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search...',
        ),
        onChanged: _onSearch,
      );
    else
      return Text(
        'Choose user for chat ',
        textAlign: TextAlign.center,
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
        if (cuc.loading.isTrue)
          return CircularProgressIndicator();
        else if (cuc.newUserList.length == 0)
          return Text('');
        else {
          if (isSearchOpened.isFalse)
            return Text('');
          else
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: cuc.newUserList.length,
                    itemBuilder: (context, index) {
                      return Obx(() => ListTile(
                          title: Text(cuc.newUserList[index].username!),
                          subtitle: Column(
                            children: [
                              Text(cuc.newUserList[index].email!),
                            ],
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              cuc.addUserToChat(cc.currentChat.value.chatId!,
                                  cuc.newUserList[index].email!);
                            },
                            child: Text('Add to chat'),
                          )));
                    },
                  ),
                ),
              ],
            );
        }
      }),
    );
  }
}

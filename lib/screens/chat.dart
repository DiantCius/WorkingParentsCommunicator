import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/chat_users_controller.dart';
import 'package:flutter_client/controllers/chats_controller.dart';
import 'package:flutter_client/controllers/messages_controller.dart';
import 'package:flutter_client/controllers/users_controller.dart';
import 'package:flutter_client/models/message.dart';
import 'package:flutter_client/services/signalr.dart';
import 'package:get/get.dart';

class Chat extends StatefulWidget {
  final name;

  const Chat({Key? key, this.name}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ChatsController cc = Get.find();
  final MessagesController mc = Get.find();
  final ChatUsersController cuc = Get.find();
  var scrollController = ScrollController();
  var txtController = TextEditingController();
  SignalR signalR = new SignalR();
  final UsersController uc = Get.find();

  receiveMessageHandler(args) {
    mc.messageList.add(Message(
        name: args[0],
        message: args[1],
        isMine: args[0] == uc.currentUser.value.username));
    scrollController.jumpTo(scrollController.position.maxScrollExtent + 75);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.group_add),
              onPressed: () {
                Get.toNamed('/searchChatUsers');
              },
            ),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                cuc.getChatUsers(cc.currentChat.value.chatId!);
                Get.defaultDialog(
                    title: 'List of ${cc.currentChat.value.name!} users',
                    content: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: MediaQuery.of(context).size.height - 400,
                        child: Obx(
                          () => ListView.builder(
                            itemCount: cuc.chatUserList.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                title: Text('${cuc.chatUserList[i].username}'),
                                trailing: uc.currentUser.value.username ==
                                            cc.currentChat.value.username &&
                                        uc.currentUser.value.username !=
                                            cuc.chatUserList[i].username
                                    ? ElevatedButton(
                                        onPressed: () {
                                          cuc.deleteUserFromChat(
                                              cc.currentChat.value.chatId!,
                                              cuc.chatUserList[i].email!);
                                        },
                                        child: Text(
                                          'Kick',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                        ),
                                      )
                                    : Text(''),
                              );
                            },
                          ),
                        )));
              },
            ),
          ],
          title: Text('${cc.currentChat.value.name}'),
        ),
        body: Obx(() {
          if (cc.loading.isTrue)
            return CircularProgressIndicator();
          else if (cc.count.value == 0)
            return Center(
              child: Text("You haven't started any chat yet"),
            );
          else
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: mc.messageList.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(
                          mc.messageList[i].isMine
                              ? mc.messageList[i].message!
                              : mc.messageList[i].name! +
                                  ': ' +
                                  mc.messageList[i].message!,
                          textAlign: mc.messageList[i].isMine
                              ? TextAlign.end
                              : TextAlign.start,
                        ),
                      );
                    },
                    separatorBuilder: (_, i) {
                      return Divider(
                        thickness: 2,
                      );
                    },
                  ),
                ),
                /*ElevatedButton(
              onPressed: () {
                //signalR.connect(receiveGroupMessageHandler);
                signalR.joinRoom('pokoj');
              },
              child: Text('join group'),
            ),*/
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: txtController,
                      decoration: InputDecoration(
                        hintText: 'Send Message',
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.lightBlue,
                          ),
                          onPressed: () {
                            //signalR..sendMessage('chuj', txtController.text);
                            signalR
                              ..sendGroupMessage(
                                  cc.currentChat.value.name!,
                                  '${uc.currentUser.value.username}',
                                  txtController.text);
                            mc.createMessage(
                                txtController.text, cc.currentChat.value.chatId!);
                            txtController.clear();
                            scrollController.jumpTo(
                                scrollController.position.maxScrollExtent + 75);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
        }));
  }

  @override
  void initState() {
    signalR.connect(receiveMessageHandler, cc.currentChat.value.name!);
    mc.getMessages(cc.currentChat.value.chatId!);
    /*mc.getMessages(cc.currentChat.value.chatId!).then((value) {
      signalR.messageList = value;
      for (var message in signalR.messageList) {
        message.isMine = message.name == uc.currentUser.value.username;
      }
    });
    print(signalR.messageList.length);*/
    //print('dupa');
    //signalR.joinRoom("pokoj");
  }

  @override
  void dispose() {
    txtController.dispose();
    scrollController.dispose();
    signalR.disconnect();
    super.dispose();
  }
}

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
  var textController = TextEditingController();
  SignalRService signalR = new SignalRService();
  final UsersController uc = Get.find();

  messageHandler(args) {
    mc.messageList.add(Message(
        name: args[0],
        message: args[1],
        isMine: args[0] == uc.currentUser.value.username));
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
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
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Get.defaultDialog(
                    title: '',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Do you wish to leave chat?"),
                        SizedBox(
                          height: 30.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            cc.leaveChat(cc.currentChat.value.chatId!);
                            Get.back();
                            Get.back();
                          },
                          child: Text(
                            'Leave chat',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                    radius: 10.0);
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Send Message',
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.lightBlue,
                          ),
                          onPressed: () {
                            signalR
                              ..sendGroupMessage(
                                  cc.currentChat.value.name!,
                                  '${uc.currentUser.value.username}',
                                  textController.text);
                            mc.createMessage(textController.text,
                                cc.currentChat.value.chatId!);
                            textController.clear();
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
    signalR.connect(messageHandler, cc.currentChat.value.name!);
    mc.getMessages(cc.currentChat.value.chatId!);
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    signalR.disconnect();
    super.dispose();
  }
}

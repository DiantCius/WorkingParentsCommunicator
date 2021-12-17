import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/chats_controller.dart';
import 'package:get/get.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final ChatsController cc = Get.find();
  final chatController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    cc.getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(" chats"),
        ),
        body: Obx(() {
          if (cc.loading.isTrue)
            return CircularProgressIndicator();
          else
            return Column(
              children: <Widget>[
                Container(height: 20),
                Expanded(
                    child: ListView.separated(
                        itemCount: cc.count.value,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              thickness: 0.5,
                            ),
                        itemBuilder: (context, index) {
                          return Obx(() => ListTile(
                                onTap: () {
                                  cc.currentChat.value = cc.chats[index];
                                  Get.toNamed('/chat');
                                },
                                title: Text("${cc.chats[index].name}"),
                              ));
                        })),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    Get.defaultDialog(
                        title: '',
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: chatController,
                              keyboardType: TextInputType.text,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  labelText: 'Chat',
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
                                cc.addChat(chatController.text);
                                Get.back();
                                chatController.clear();
                              },
                              child: Text(
                                'ADD CHAT',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            )
                          ],
                        ),
                        radius: 10.0);
                  },
                  label: Text("Add Chat"),
                  icon: const Icon(Icons.chat),
                  backgroundColor: Colors.blue,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
        }));
  }
}

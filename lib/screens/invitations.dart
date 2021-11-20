import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/invitations_controller.dart';
import 'package:get/get.dart';

class Invitations extends StatefulWidget {
  const Invitations({Key? key}) : super(key: key);

  @override
  _InvitationsState createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  final InvitationsController inv = Get.find();

  @override
  void initState() {
    super.initState();
    inv.getInvitations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Invitations "),
        ),
        body: Obx(() {
          if (inv.loading.isTrue)
            return CircularProgressIndicator();
          else if (inv.count.value == 0)
            return Text('');
          else
            return Column(
              children: <Widget>[
                Container(height: 20),
                Expanded(
                    child: ListView.builder(
                        itemCount: inv.count.value,
                        itemBuilder: (context, index) {
                          return Obx(() => ListTile(
                                onLongPress: () {},
                                onTap: () {},
                                title: Text(
                                    "${inv.invitations[index].invitationId}"),
                                trailing: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () {},
                                  child: const Text('Details'),
                                ),
                              ));
                        })),
              ],
            );
        }));
  }
}

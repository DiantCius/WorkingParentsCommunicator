import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:flutter_client/controllers/invitations_controller.dart';
import 'package:flutter_client/models/invitations_response.dart';
import 'package:get/get.dart';

class Invitations extends StatefulWidget {
  const Invitations({Key? key}) : super(key: key);

  @override
  _InvitationsState createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  final InvitationsController inv = Get.find();
  final ChildrenController cc = Get.find();

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              cc.getChildren();
              Get.back();
            },
          ),
        ),
        body: Obx(() {
          if (inv.loading.isTrue)
            return CircularProgressIndicator();
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
                              title: Row(
                                children: [
                                  Text(
                                      "Invitation to babysitt ${inv.invitations[index].childName}",
                                      style: TextStyle(fontSize: 17)),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.green,
                                      textStyle: const TextStyle(fontSize: 17),
                                    ),
                                    onPressed: () {
                                      inv
                                          .acceptInvitation(
                                              inv.invitations[index]
                                                  .invitationId!,
                                              inv.invitations[index].childName!)
                                          .then((value) => {
                                                if (value
                                                    is InvitationsResponse)
                                                  {print('ok')}
                                                else
                                                  Get.defaultDialog(
                                                      middleText: value.message)
                                              });
                                    },
                                    child: const Text('Accept'),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.red,
                                      textStyle: const TextStyle(
                                          fontSize: 18, color: Colors.red),
                                    ),
                                    onPressed: () {
                                      inv
                                          .declineInvitation(
                                              inv.invitations[index]
                                                  .invitationId!,
                                              inv.invitations[index].childName!)
                                          .then((value) => {
                                                if (value
                                                    is InvitationsResponse)
                                                  {print('ok')}
                                                else
                                                  Get.defaultDialog(
                                                      middleText: value.message)
                                              });
                                    },
                                    child: const Text('Decline'),
                                  ),
                                ],
                              )));
                        })),
              ],
            );
        }));
  }
}

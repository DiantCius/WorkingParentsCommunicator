import 'package:flutter/material.dart';
import 'package:flutter_client/controllers/children_controller.dart';
import 'package:get/get.dart';

class SearchBabysitters extends StatefulWidget {
  const SearchBabysitters({ Key? key }) : super(key: key);

  @override
  _SearchBabysittersState createState() => _SearchBabysittersState();
}

class _SearchBabysittersState extends State<SearchBabysitters> {

  final ChildrenController cc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Choose babysitter ',
            textAlign: TextAlign.center,
          ),
        ),
        body: Text('${cc.currentChild.value.name}'),
      );
  }
}
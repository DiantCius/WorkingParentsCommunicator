import 'package:get/get.dart';

class HomeController extends GetxController
{
  var index = 0.obs;

  void setIndex(int value) {
    index.value = value;
  }
}
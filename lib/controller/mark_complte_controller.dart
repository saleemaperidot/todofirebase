import 'package:get/get.dart';

class AvatarController extends GetxController {
  RxInt selectedAvatarIndex = (-1).obs;

  void updateSelectedAvatar(int index) {
    selectedAvatarIndex.value = index;
  }
}

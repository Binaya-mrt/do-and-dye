import 'package:get/get.dart';

class UtilsController extends GetxController {
  RxBool isObscure = true.obs;
  RxBool isBarber = false.obs;
  RxBool isLoading = false.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  void toggleBarber() {
    isBarber.value = !isBarber.value;
  }
}

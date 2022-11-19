import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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

  pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return pickedFile.readAsBytes();
    }
    return null;

    // return pickedFile;
  }
}

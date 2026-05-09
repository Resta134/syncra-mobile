import 'package:get/get.dart';

import '../controllers/present_speaker_controller.dart';

class PresentSpeakerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpeakerController>(
      () => SpeakerController(),
    );
  }
}

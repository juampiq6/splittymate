import 'package:splittymate/consts.dart';

class AvatarPictureService {
  static String getAvatarUrl(String seed) {
    return '$diceBearAvatarUrl?radius=50&seed=$seed';
  }
}

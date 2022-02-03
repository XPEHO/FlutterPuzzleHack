import 'dart:io';

bool isMobile() {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  } catch (_) {
    return false;
  }
}

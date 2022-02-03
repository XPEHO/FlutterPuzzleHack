import 'dart:io';

import 'package:flutter/foundation.dart';

bool isMobile() {
  if (kIsWeb) {
    return false;
  } else if (Platform.isAndroid || Platform.isIOS) {
    return true;
  }
  return false;
}

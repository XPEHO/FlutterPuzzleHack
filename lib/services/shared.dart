import 'dart:io';

import 'package:flutter/foundation.dart';

// This file is for method in general
/// Method for detection if we are in mobile or web
bool isMobile() {
  if (kIsWeb) {
    return false;
  } else if (Platform.isAndroid || Platform.isIOS) {
    return true;
  }
  return false;
}

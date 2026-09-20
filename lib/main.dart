import 'package:device_preview/device_preview.dart' show DevicePreview;
import 'package:device_preview/presets.dart' show DevicePresets;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'app_widget.dart';

void main() {
  DevicePreview.enable(enabled: kDebugMode);
  DevicePreview.maybeController?.applyPreset(DevicePresets.iPhone16);
  runApp(const AppWidget());
}

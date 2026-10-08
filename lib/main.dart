import 'package:device_preview/device_preview.dart' show DevicePreview;
import 'package:device_preview/presets.dart' show DevicePresets;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'app_widget.dart';

void main() {
  // Don't use WidgetsFlutterBinding.ensureInitialized() here, as it may cause issues with DevicePreview.
  // Use only in production
  // WidgetsFlutterBinding.ensureInitialized();

  DevicePreview.enable(enabled: kDebugMode);
  DevicePreview.maybeController?.applyPreset(DevicePresets.iPhone16);
  runApp(const AppWidget());
}

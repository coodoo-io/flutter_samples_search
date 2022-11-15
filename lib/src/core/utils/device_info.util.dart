import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:samples/src/core/config/app_config.dart';
import 'package:samples/src/core/utils/device_info.dart';

class DeviceInfoUtil {
  static String getBuildNumber(PackageInfo packageInfo) {
    return packageInfo.buildNumber;
  }

  static String getVersion(PackageInfo packageInfo) {
    return packageInfo.version;
  }

  static String getBuildNumberAndVersion(PackageInfo packageInfo) {
    return 'Version ${getVersion(packageInfo)} (Build ${getBuildNumber(packageInfo)})';
  }

  static Future<DeviceInfo?> getDeviceInfo({required DeviceInfoPlugin deviceInfoPlugin}) async {
    // Android
    // if (AppConfig.isAndroid) {
    //   final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    //   return DeviceInfo(
    //     userAgent: androidDeviceInfo.model,
    //     platform: Platform.operatingSystem,
    //   );
    // }

    // iOS
    // if (AppConfig.isIOS) {
    //   final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    //   return DeviceInfo(
    //     userAgent: iosDeviceInfo.utsname.machine,
    //     platform: Platform.operatingSystem,
    //   );
    // }

    // Web
    if (AppConfig.isWeb) {
      final webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      return DeviceInfo(userAgent: webBrowserInfo.userAgent, platform: Platform.operatingSystem);
    }

    // macOS
    // if (AppConfig.isMacOS) {
    //   final macOSInfo = await deviceInfoPlugin.macOsInfo;
    //   return DeviceInfo(userAgent: macOSInfo.kernelVersion, platform: Platform.operatingSystem);
    // }

    // linux
    // if (AppConfig.isLinux) {
    //   final linuxInfo = await deviceInfoPlugin.linuxInfo;
    //   return DeviceInfo(userAgent: linuxInfo.prettyName, platform: Platform.operatingSystem);
    // }

    // if (AppConfig.isWindows) {
    //   final windowsInfo = await deviceInfoPlugin.windowsInfo;
    //   return DeviceInfo(userAgent: windowsInfo.productName, platform: Platform.operatingSystem);
    // }
    return null;
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info.freezed.dart';

@freezed
class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    String? userAgent,
    required String platform,
  }) = _DeviceInfo;
}

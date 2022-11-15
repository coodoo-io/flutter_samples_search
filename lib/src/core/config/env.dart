import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'LOG_LEVEL')
  static const logLevel = _Env.logLevel;
}

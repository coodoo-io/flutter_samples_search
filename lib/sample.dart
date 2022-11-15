// To parse this JSON data, do
//
//     final sample = sampleFromJson(jsonString);

import 'dart:convert';

class Sample {
  Sample({
    required this.id,
    required this.element,
    required this.sourcePath,
    required this.sourceLine,
    required this.channel,
    required this.serial,
    required this.package,
    required this.sampleLibrary,
    required this.copyright,
    required this.description,
    required this.file,
  });

  final String id;
  final String element;
  final String sourcePath;
  final int sourceLine;
  final String channel;
  final String serial;
  final String package;
  final String sampleLibrary;
  final dynamic copyright;
  final String description;
  final String file;

  factory Sample.fromRawJson(String str) => Sample.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sample.fromJson(Map<String, dynamic> json) => Sample(
        id: json['id'],
        element: json['element'],
        sourcePath: json['sourcePath'],
        sourceLine: json['sourceLine'],
        channel: json['channel'],
        serial: json['serial'],
        package: json['package'],
        sampleLibrary: json['library'],
        copyright: json['copyright'],
        description: json['description'].replaceAll('\n', ' '),
        file: json['file'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'element': element,
        'sourcePath': sourcePath,
        'sourceLine': sourceLine,
        'channel': channel,
        'serial': serial,
        'package': package,
        'library': sampleLibrary,
        'copyright': copyright,
        'description': description,
        'file': file,
      };
}

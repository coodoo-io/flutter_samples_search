import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:samples/sample.dart';

part 'samples.api.g.dart';

@riverpod
SamplesApi samplesApi(SamplesApiRef ref) => SamplesApi();

class SamplesApi {
  Future<List<Sample>> getSamples() async {
    List<Sample> sampleList = [];
    String data = await rootBundle.loadString('samples/samples.json');
    final jsonResult = json.decode(data);
    jsonResult.forEach((json) => sampleList.add(Sample.fromJson(json)));
    return sampleList;
  }
}

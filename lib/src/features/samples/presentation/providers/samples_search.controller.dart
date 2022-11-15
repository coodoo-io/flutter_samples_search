import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'samples_search.controller.g.dart';

@riverpod
class SamplesSearchController extends _$SamplesSearchController {
  final TextEditingController searchController = TextEditingController();

  @override
  TextEditingController build() {
    searchController.text = Uri.base.queryParameters['q'] ?? '';
    return searchController;
  }
}

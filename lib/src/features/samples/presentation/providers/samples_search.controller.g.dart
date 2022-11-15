// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'samples_search.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

String $SamplesSearchControllerHash() => r'275cf4c3be8f294ead7be25a0ea309291feee07a';

/// See also [SamplesSearchController].
final samplesSearchControllerProvider = AutoDisposeNotifierProvider<SamplesSearchController, TextEditingController>(
  SamplesSearchController.new,
  name: r'samplesSearchControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : $SamplesSearchControllerHash,
);
typedef SamplesSearchControllerRef = AutoDisposeNotifierProviderRef<TextEditingController>;

abstract class _$SamplesSearchController extends AutoDisposeNotifier<TextEditingController> {
  @override
  TextEditingController build();
}

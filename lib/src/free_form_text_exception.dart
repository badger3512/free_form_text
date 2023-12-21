part of '../free_form_text.dart';

/// Exception thrown by API methods
class FreeFormTextException implements Exception {
  String reason;
  FreeFormTextException(this.reason);
}

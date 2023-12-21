part of '../free_form_text.dart';
/// Cache for [StyledCharacter]. Characters are cached, based on their codepoint and associated [TextStyle].
class CharacterCache {
  Map<int, StyledCharacter> map = {};
  static final CharacterCache _cache = CharacterCache._internal();

  factory CharacterCache() {
    return _cache;
  }

  CharacterCache._internal();

  /// Save a character to the cache.
  /// The hash is a combination of character codepoint and style hashcode.
  void put(StyledCharacter char) {
    int hashCode = char.hashCode;
    if (map.isNotEmpty && map[hashCode] != null) {
      return;
    } else {
      map[hashCode] = char;
    }
  }

  /// Retrieve a character, if present.
  /// Hash is combination of character codepoint and style hashcode.
  StyledCharacter? get(StyledCharacter char) {
    return map[char.hashCode];
  }
}
/// Singleton [CharacterCache]
final cache = CharacterCache();

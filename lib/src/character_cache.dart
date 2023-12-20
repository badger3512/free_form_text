part of '../free_form_text.dart';

class CharacterCache {
  Map<int, StyledCharacter> map = {};
  static final CharacterCache _cache = CharacterCache._internal();

  factory CharacterCache() {
    return _cache;
  }

  CharacterCache._internal();

  void put(StyledCharacter char) {
    int hashCode = char.hashCode;
    if (map.isNotEmpty && map[hashCode] != null) {
      return;
    } else {
      map[hashCode] = char;
    }
  }

  StyledCharacter? get(StyledCharacter char) {
    return map[char.hashCode];
  }
}

final cache = CharacterCache();

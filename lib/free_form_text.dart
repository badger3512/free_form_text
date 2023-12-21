/// Library to implement painting styled, free form text to a Canvas.
library free_form_text;

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:path_provider/path_provider.dart';

part 'src/free_form_text.dart';
part 'src/character_cache.dart';
part 'src/free_form_text_painter.dart';
part 'src/styled_character.dart';
part 'src/offset_util.dart';
part 'src/smooth.dart';
part 'src/free_form_text_exception.dart';

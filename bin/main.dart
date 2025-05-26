#! /usr/bin/env dart

import 'package:cs_scan/cs_scan.dart';
import 'package:debug_output/debug_output.dart';
import 'package:std/std.dart' as std_std;

void main() {
  dump(add2(11, 22));
  String mainSrc = std_std.pathExpand('~/cs-cmd/Test.Main/Test.Main.cs');
  echo(mainSrc);
  List<String> lines = std_std.readFileLines(mainSrc);
  lines = lines.where((x) => x.startsWith('//')).toList();
  echo(lines, type: 'json');
  final reg = RegExp(r'//css_inc[ ]+(.+)[ ]*');
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
    RegExpMatch? match = reg.firstMatch(line);
    if (match != null) {
      echo(match.group(1));
    }
  }
}

#! /usr/bin/env dart

import 'package:cs_scan/cs_scan.dart';
import 'package:debug_output/debug_output.dart';
import 'package:std/misc.dart';
//import 'package:std/std.dart' as std_std;

Set<String> $sourceList = {};

void scanSource(String path) {
  path = pathExpand(path);
  $sourceList.add(path);
  String dir = pathDirectoryName(path);
  pushd(dir);
  List<String> lines = readFileLines(path);
  //lines = lines.where((x) => x.startsWith('//')).toList();
  //echo(lines, type: 'json');
  final reg = RegExp(r'//css_inc[ ]+(.+)[ ]*');
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
    RegExpMatch? match = reg.firstMatch(line);
    if (match != null) {
      echo(match.group(1));
      String src = pathExpand(match.group(1)!);
      $sourceList.add(src);
      scanSource(src);
    }
  }
  popd();
}

void main() {
  dump(add2(11, 22));
  $sourceList.clear();
  String cwd = getCwd();
  String mainSrc = pathExpand('~/cs-cmd/Test.Main/Test.Main.cs');
  scanSource(mainSrc);
  echo($sourceList);
}

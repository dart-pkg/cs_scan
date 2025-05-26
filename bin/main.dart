#! /usr/bin/env dart

import 'package:cs_scan/cs_scan.dart';
import 'package:debug_output/debug_output.dart';
import 'package:std/misc.dart';
//import 'package:std/std.dart' as std_std;

Set<String> $sourceSet = {};
List<String> $sourceList = [];

void scanSource(String path) {
  path = pathExpand(path);
  $sourceSet.add(path);
  String dir = pathDirectoryName(path);
  pushd(dir);
  List<String> lines = readFileLines(path);
  final reg = RegExp(r'^//css_inc[ ]+(.+)[ ]*');
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
    RegExpMatch? match = reg.firstMatch(line);
    if (match != null) {
      String src = pathExpand(match.group(1)!);
      $sourceSet.add(src);
      scanSource(src);
    }
  }
  popd();
}

void main() {
  $sourceSet.clear();
  String cwd = getCwd();
  String mainSrc = pathExpand('~/cs-cmd/Test.Main/Test.Main.cs');
  String mainDir = pathDirectoryName(mainSrc);
  scanSource(mainSrc);
  $sourceList = $sourceSet.toList();
  echo($sourceList, type: 'json');
  for (int i=0; i<$sourceList.length; i++) {
    String rel = pathRelative($sourceList[i], from: mainDir);
    echo(rel, title: r'rel');
  }
}

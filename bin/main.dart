#! /usr/bin/env dart

import 'package:cs_scan/cs_scan.dart';
import 'package:debug_output/debug_output.dart';
import 'package:std/misc.dart';
//import 'package:std/std.dart' as std_std;

Set<String> $sourceSet = {};
List<String> $sourceList = [];
Set<String> $refSet = {};

void scanSource(String path) {
  path = pathExpand(path);
  $sourceSet.add(path);
  String dir = pathDirectoryName(path);
  pushd(dir);
  List<String> lines = readFileLines(path);
  final regInc = RegExp(r'^//css_inc[ ]+(.+)[ ]*');
  final regRef = RegExp(r'^//css_ref[ ]+(.+)[ ]*');
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
    RegExpMatch? matchInc = regInc.firstMatch(line);
    if (matchInc != null) {
      String src = pathExpand(matchInc.group(1)!);
      $sourceSet.add(src);
      scanSource(src);
    }
    RegExpMatch? matchRef = regRef.firstMatch(line);
    if (matchRef != null) {
      String src = matchRef.group(1)!;
      $refSet.add(src);
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
  echo($refSet);
}

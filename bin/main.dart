#! /usr/bin/env dart

import 'package:cs_scan/cs_scan.dart';
import 'package:debug_output/debug_output.dart';
import 'package:std/misc.dart';

class CsScan {
  late final String _path;
  late final String _dir;
  Set<String> $sourceSet = {};
  Set<String> $refSet = {};
  Set<String> $embedSet = {};
  CsScan(String path) {
    _path = pathExpand(path);
    _dir = pathDirectoryName(_path);
    scanSource(_path);
  }
  void scanSource(String path) {
    path = pathExpand(path);
    $sourceSet.add(pathRelative(path, from: _dir));
    String dir = pathDirectoryName(path);
    pushd(dir);
    List<String> lines = readFileLines(path);
    final regInc = RegExp(r'^//css_inc[ ]+(.+)[ ]*');
    final regRef = RegExp(r'^//css_ref[ ]+(.+)[ ]*');
    final regEmbed = RegExp(r'^//css_embed[ ]+(.+)[ ]*');
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      RegExpMatch? matchInc = regInc.firstMatch(line);
      if (matchInc != null) {
        String src = pathExpand(matchInc.group(1)!);
        String rel = pathRelative(src, from: _dir);
        $sourceSet.add(rel);
        scanSource(src);
      }
      RegExpMatch? matchRef = regRef.firstMatch(line);
      if (matchRef != null) {
        String src = matchRef.group(1)!;
        $refSet.add(src);
      }
      RegExpMatch? matchEmbed = regEmbed.firstMatch(line);
      if (matchEmbed != null) {
        String src = pathExpand(matchEmbed.group(1)!);
        String rel = pathRelative(src);
        $embedSet.add(rel);
      }
    }
    popd();
  }
}

// Set<String> $sourceSet = {};
// Set<String> $refSet = {};
// Set<String> $embedSet = {};
//
// void scanSource(String path, String fromDir) {
//   path = pathExpand(path);
//   $sourceSet.add(pathRelative(path, from: fromDir));
//   String dir = pathDirectoryName(path);
//   pushd(dir);
//   List<String> lines = readFileLines(path);
//   final regInc = RegExp(r'^//css_inc[ ]+(.+)[ ]*');
//   final regRef = RegExp(r'^//css_ref[ ]+(.+)[ ]*');
//   final regEmbed = RegExp(r'^//css_embed[ ]+(.+)[ ]*');
//   for (int i = 0; i < lines.length; i++) {
//     String line = lines[i];
//     RegExpMatch? matchInc = regInc.firstMatch(line);
//     if (matchInc != null) {
//       String src = pathExpand(matchInc.group(1)!);
//       String rel = pathRelative(src, from: fromDir);
//       $sourceSet.add(rel);
//       scanSource(src, fromDir);
//     }
//     RegExpMatch? matchRef = regRef.firstMatch(line);
//     if (matchRef != null) {
//       String src = matchRef.group(1)!;
//       $refSet.add(src);
//     }
//     RegExpMatch? matchEmbed = regEmbed.firstMatch(line);
//     if (matchEmbed != null) {
//       String src = pathExpand(matchEmbed.group(1)!);
//       String rel = pathRelative(src, from: fromDir);
//       $embedSet.add(rel);
//     }
//   }
//   popd();
// }

void main() {
  // $sourceSet.clear();
  // String cwd = getCwd();
  // String mainSrc = pathExpand('~/cs-cmd/Test.Main/Test.Main.cs');
  // String mainDir = pathDirectoryName(mainSrc);
  // scanSource(mainSrc, mainDir);
  // echo($sourceSet);
  // echo($refSet);
  // echo($embedSet);
  var csScan = CsScan('~/cs-cmd/Test.Main/Test.Main.cs');
  echo(csScan.$sourceSet);
  echo(csScan.$refSet);
  echo(csScan.$embedSet);
}

library;

import 'package:debug_output/debug_output.dart';
import 'package:std/misc.dart';

class CsScan {
  late final String _path;
  //late final String _dir;
  Set<String> $sourceSet = {};
  Set<String> $refSet = {};
  Set<String> $embedSet = {};
  CsScan(String path) {
    _path = pathExpand(path);
    //_dir = pathDirectoryName(_path);
    scanSource(_path);
  }
  void scanSource(String path) {
    path = pathExpand(path);
    if (!fileExists(path)) {
      return;
    }
    //$sourceSet.add(pathRelative(path, from: _dir));
    $sourceSet.add(path);
    String dir = pathDirectoryName(path);
    pushd(dir);
    List<String> lines = readFileLines(path);
    final regInc = RegExp(r'^//css_inc[ ]+(.+)[ ]*');
    final regRef = RegExp(r'^//css_ref[ ]+(.+)[ ]*');
    final regEmbed = RegExp(r'^//css_embed[ ]+(.+)[ ]*');
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      RegExpMatch? matchInc = regInc.firstMatch(line);
      RegExpMatch? matchRef = regRef.firstMatch(line);
      if (matchRef != null) {
        String src = matchRef.group(1)!;
        $refSet.add(src);
      }
      RegExpMatch? matchEmbed = regEmbed.firstMatch(line);
      if (matchEmbed != null) {
        String src = pathExpand(matchEmbed.group(1)!);
        //rel = pathRelative(src);
        //$embedSet.add(rel);
        $embedSet.add(src);
      }
      if (matchInc != null) {
        String src = pathExpand(matchInc.group(1)!);
        //String rel = pathRelative(src, from: _dir);
        //$sourceSet.add(rel);
        $sourceSet.add(src);
        scanSource(src);
      }
    }
    popd();
  }
}

void main() {
  var csScan = CsScan('~/cs-cmd/Test.Main/Test.Main.cs');
  echo(csScan.$sourceSet);
  echo(csScan.$refSet);
  echo(csScan.$embedSet);
}

// ignore_for_file: prefer_single_quotes
import 'package:test/test.dart';
import 'package:debug_output/debug_output.dart';
import 'package:cs_scan/cs_scan.dart';

void main() {
  group('Run', () {
    test('run1', () {
      String result;
      var csScan = CsScan('~/cs-cmd/Test.Main/Test.Main.cs');
      result = echo(csScan.$sourceSet);
      expect(
        result,
        equals(
          '''{D:/home11/cs-cmd/Test.Main/Test.Main.cs, D:/home11/cs-cmd/Test.Main/Test.Main.api.cs, D:/home11/cs-cmd/Test.Main/lib/lib.cs, D:/home11/cs-cmd/Test.Main/lib/lib.Add3.cs}''',
        ),
      );
      result = echo(csScan.$pkgSet);
      expect(
        result,
        equals(
          '''{{"name":"EasyObject","version":"*"}, {"name":"Newtonsoft.Json","version":"13.0.3"}, {"name":"Global.Sys","version":"*"}}''',
        ),
      );
      result = echo(csScan.$refSet);
      expect(result, equals('''{Test.Lib.exe}'''));
      result = echo(csScan.$embedSet);
      expect(result, equals('''{D:/home11/cs-cmd/Test.Main/test.txt}'''));
    });
  });
}

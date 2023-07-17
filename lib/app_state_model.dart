import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

enum Unit { IMPERIAL, METRIC }

/// This is the state kept by the app at run time.
/// Persistent state is not still kept by the web app, only
/// by mobile apps. That is a flutter issue.
class AppStateModel extends foundation.ChangeNotifier {
  AppStateModel({required this.apiKey});
  final String apiKey;

  // Locations data, getter and setter
  List<String> _locations = ['Berlin', 'London'];

  List<String> get locations => _locations;
  void addLocation(String location) {
    // Check if the a duplicate exists
    // before adding
    for (var idx = 0; idx < _locations.length; idx++) {
      if (_locations[idx].toLowerCase() == location.toLowerCase()) {
        return;
      }
    }
    _locations.add(location);
    try {
      writeAppState();
    } finally {
      notifyListeners();
    }
  }

  // Local database (mobile apps only)
  final String locationsFile = 'locations.json';

  Future<String> getAppDir() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  late final appDir = getAppDir();

  // Write back the state to the local file system in non-web targets
  writeAppState() {
    appDir.then((value) {
      var file = File('$value/$locationsFile');
      print('$value/$locationsFile');
      file.writeAsStringSync(json.encode(_locations));
    });
  }

  loadAppState() {
    appDir.then((value) {
      var file = File('$value/$locationsFile');
      print('$value/$locationsFile');
      if (file.existsSync()) {
        var jsonData = json.decode(file.readAsStringSync());
        for (var index = 0; index < jsonData.length; index++) {
          var location = jsonData[index];
          if (!_locations.contains(location)) {
            addLocation(location);
          }
        }
      }
    });
  }

  // Weather data api
  Future<String> weatherData(String location) async {
    var client = newUniversalHttpClient();
    String stringData = "";
    try {
      HttpClientRequest request = await client.getUrl(Uri.parse(
          'https://cors-anywhere.herokuapp.com/http://api.openweathermap.org/data/2.5/weather?q=$location&APPID=$apiKey&units=${unitString().toLowerCase()}'));
      request.headers.add('content-type', "application/json");
      request.headers.add("Access-Control-Allow-Origin", "*");
      request.headers.add('X-Requested-With', 'XMLHttpRequest');
      HttpClientResponse response = await request.close();
      // Process the response
      String data = await response.transform(utf8.decoder).join();
      if (kDebugMode) {
        print(data);
      }
      final jsonData = json.decode(data);
      stringData += "${jsonData['weather'][0]['main']} ";
      stringData += "${jsonData['main']['temp']}${tempString()} ";

      DateTime sr = DateTime.fromMillisecondsSinceEpoch(
          (jsonData['sys']['sunrise'] + jsonData['timezone']) * 1000,
          isUtc: true);
      String sunrise = DateFormat('kk:mm').format(sr);
      stringData += "Sunrise $sunrise ";

      DateTime ss = DateTime.fromMillisecondsSinceEpoch(
          (jsonData['sys']['sunset'] + jsonData['timezone']) * 1000,
          isUtc: true);
      String sunset = DateFormat('kk:mm').format(ss);
      stringData += "Sunrise $sunset ";

      stringData += "Humidity ${jsonData['main']['humidity']}% ";
      stringData += "Wind ${jsonData['wind']['speed']}${speedString()} ";
    } finally {
      client.close();
    }

    return stringData;
  }

  // Data unit type
  Unit _unit = Unit.IMPERIAL;
  Unit get unit => _unit;
  void setUnit(Unit u) {
    _unit = u;
    notifyListeners();
  }

  void toggleUnit() {
    setUnit(_unit == Unit.IMPERIAL ? Unit.METRIC : Unit.IMPERIAL);
  }

  String unitString() {
    return _unit == Unit.IMPERIAL ? "Imperial" : "Metric";
  }

  String tempString() {
    return _unit == Unit.IMPERIAL ? "F" : "C";
  }

  String speedString() {
    return _unit == Unit.IMPERIAL ? "mph" : "kmph";
  }
}

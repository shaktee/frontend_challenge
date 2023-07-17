import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state_model.dart';

class LocationRowItem extends StatelessWidget {
  const LocationRowItem({
    required this.item,
    required this.index,
    super.key,
  });

  final String item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);

    return FutureBuilder(
        future: model.weatherData(item),
        initialData: "Loading data..",
        builder: (BuildContext context, AsyncSnapshot weatherData) {
          print(weatherData.connectionState);
          print(weatherData.hasData);
          print(weatherData.hasError);
          print(weatherData.error);
          return Container(
              height: 50,
              color: index & 1 == 0 ? Colors.amber[600] : Colors.grey,
              child: ListTile(
                  autofocus: true,
                  title: MaterialButton(
                      onPressed: () {},
                      child: Column(children: [
                        Text(item),
                        weatherData.hasError
                            ? const Text("Could not retrieve weather")
                            : (weatherData.hasData
                                ? Text(weatherData.data)
                                : const Text("No data"))
                      ]))));
        });
  }
}

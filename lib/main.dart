import 'package:flutter/material.dart';
import 'package:frontend_challenge/location_row_item.dart';
import 'package:provider/provider.dart';
import 'app_state_model.dart';

// ignore: constant_identifier_names
const APIKEY = 'YOUR-API-KEY-GOES-HERE';
void main() {
  runApp(ChangeNotifierProvider<AppStateModel>(
      create: (_) => AppStateModel(apiKey: APIKEY)..loadAppState(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void _addCity(AppStateModel model) {}

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        leading: FloatingActionButton(
            onPressed: () => model.toggleUnit(),
            tooltip: 'Toggle between Metric and Imperial',
            child: Text(model.unitString())),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          for (int index = 0; index < model.locations.length; index++)
            LocationRowItem(
              item: model.locations[index],
              index: index,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var cityController = TextEditingController();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Stack(
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: cityController,
                                decoration: const InputDecoration(
                                  labelText: 'City',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                child: const Text("Add City"),
                                onPressed: () {
                                  model.addLocation(cityController.text);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        tooltip: 'Add a city',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

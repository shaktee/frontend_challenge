import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state_model.dart';

class LocationAddRow extends StatelessWidget {
  LocationAddRow({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);
    final formKey = GlobalKey<FormState>();
    var cityController = TextEditingController();
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
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants.dart';

class MedEntry extends StatelessWidget {
  const MedEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New'),
      ),
      body: Column(
        children: [
          PanelTitle(
            title: 'Medicine Name',
            isRequired: true,
          ),
          TextFormField(
            maxLength: 12,
            decoration: const InputDecoration(border: UnderlineInputBorder()),
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: kOtherColor),
          ),
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({Key? key, required this.title, required this.isRequired})
      : super(key: key);
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Name',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextSpan(
              text: "*",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: kPrimaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

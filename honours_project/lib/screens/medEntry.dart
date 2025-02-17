import 'package:flutter/material.dart';

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
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Name',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

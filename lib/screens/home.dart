import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _transcribedText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(
                      Icons.mic_none_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: Text('Speak'),
                    onPressed: () {},
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('Listen'),
                  )
                ],
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_transcribedText),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

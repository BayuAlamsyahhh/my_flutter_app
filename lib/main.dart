import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.100:8765')); // Ganti dengan IP server PC

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Lightroom Remote")),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SliderControl(label: "Exposure", onChanged: (value) => channel.sink.add("exposure:$value")),
              SliderControl(label: "Contrast", onChanged: (value) => channel.sink.add("contrast:$value")),
              SliderControl(label: "Saturation", onChanged: (value) => channel.sink.add("saturation:$value")),
              SliderControl(label: "Temperature", onChanged: (value) => channel.sink.add("temperature:$value")),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(label: "Undo", command: "undo", channel: channel),
                  ActionButton(label: "Redo", command: "redo", channel: channel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderControl extends StatelessWidget {
  final String label;
  final Function(double) onChanged;

  SliderControl({required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Slider(
          min: -100,
          max: 100,
          value: 0,
          onChanged: (value) => onChanged(value),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final String command;
  final WebSocketChannel channel;

  ActionButton({required this.label, required this.command, required this.channel});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => channel.sink.add(command),
      child: Text(label),
    );
  }
}

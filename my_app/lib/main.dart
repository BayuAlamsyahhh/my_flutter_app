import 'package:flutter/material.dart';
import import 'package:flutter/foundation.dart'; 
print(defaultTargetPlatform.toString());
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ControlPage(),
    );
  }
}

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final channel = IOWebSocketChannel.connect('ws://192.168.1.100:8765'); // Ganti dengan IP server PC

  void sendCommand(String command) {
    channel.sink.add(command);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lightroom Remote")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SliderControl(label: "Exposure", onChanged: (value) => sendCommand("exposure:$value")),
            SliderControl(label: "Contrast", onChanged: (value) => sendCommand("contrast:$value")),
            SliderControl(label: "Saturation", onChanged: (value) => sendCommand("saturation:$value")),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(label: "Undo", command: "undo", onPressed: sendCommand),
                ActionButton(label: "Redo", command: "redo", onPressed: sendCommand),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SliderControl extends StatelessWidget {
  final String label;
  final ValueChanged<double> onChanged;

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
  final Function(String) onPressed;

  ActionButton({required this.label, required this.command, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(command),
      child: Text(label),
    );
  }
}

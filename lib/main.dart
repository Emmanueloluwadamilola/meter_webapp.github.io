import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThingSpeak Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiKey = '8CULGSG9EYBE348U';
  final int channelId = 2176140;

  var dataName = ['Voltage', 'Current', 'Temperature'];
  var unit = ['V', 'A', '°C'];

  List<List<double>> channelData = [];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchData();

    // Start a timer to update the data every 5 seconds
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      fetchData();
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  Future<void> fetchData() async {
    final url =
        'https://api.thingspeak.com/channels/$channelId/feeds.json?api_key=$apiKey&results=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        channelData = _parseData(data);
      });
    } else {
      print('Error: Unable to fetch data from ThingSpeak.');
    }
  }

  List<List<double>> _parseData(Map<String, dynamic> data) {
    List<List<double>> parsedData = [];

    for (int i = 1; i <= 3; i++) {
      List<double> fieldData = [];

      if (data['feeds'] != null) {
        for (var feed in data['feeds']) {
          fieldData.add(double.parse(feed['field$i']));
        }
      }

      parsedData.add(fieldData);
    }

    return parsedData;
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Meter Data'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         //mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const Text(
  //             'Voltage,Current And Temperature Monitoring System',
  //             style: TextStyle(
  //                 fontSize: 40,
  //                 color: Colors.blue,
  //                 fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(
  //             height: 50,
  //           ),
  //           for (int i = 0; i < channelData.length; i++)
  //             Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       '${dataName[i]}:',
  //                       style: const TextStyle(
  //                           fontSize: 30,
  //                           color: Colors.blue,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     const SizedBox(width: 10),
  //                     Text(
  //                       channelData[i].isNotEmpty
  //                           ? channelData[i][0].toString()
  //                           : 'No data',
  //                       style: const TextStyle(
  //                           fontSize: 30,
  //                           color: Colors.blue,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                     Text(
  //                       '${unit[i]}',
  //                       style: const TextStyle(
  //                           fontSize: 30,
  //                           color: Colors.blue,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 40),
  //               ],
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meter Data'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF33A1DE),
             Color(0xFFA50C69),
              // Color(0xFFB8833B),
            ],
          ),
        ),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TypewriterAnimatedTextKit(
                text: ['Voltage, Current, and Temperature Monitoring System'],
                textStyle: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                speed: Duration(milliseconds: 100),
                totalRepeatCount: 1,
              ),
              const SizedBox(height: 50),
              for (int i = 0; i < channelData.length; i++)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${dataName[i]}:',
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          channelData[i].isNotEmpty
                              ? channelData[i][0].toString()
                              : 'No data',
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${unit[i]}',
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

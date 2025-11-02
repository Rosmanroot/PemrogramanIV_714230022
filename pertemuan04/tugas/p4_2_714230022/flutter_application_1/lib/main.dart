import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tugas Pertemuan 4'),
          backgroundColor: Colors.deepOrange, // Warna AppBar seperti gambar
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Box 1
              Container(
                width: 250,
                height: 100,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'Box 1',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Memberi sedikit jarak antar Box

              // Row untuk Box 2 dan Box 3
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Box 2
                  Container(
                    width: 120,
                    height: 150,
                    color: Colors.red,
                    margin: const EdgeInsets.only(right: 10), // Jarak antara Box 2 dan Box 3
                    child: const Center(
                      child: Text(
                        'Box 2',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),

                  // Box 3
                  Container(
                    width: 120,
                    height: 150,
                    color: Colors.green,
                    child: const Center(
                      child: Text(
                        'Box 3',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
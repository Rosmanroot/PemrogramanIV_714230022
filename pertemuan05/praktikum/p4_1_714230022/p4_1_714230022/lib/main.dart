import 'package:flutter/material.dart';
import 'model/tourism_place.dart'; 

const iniFontCustom = TextStyle(fontFamily: 'Staatliches',);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tempat Wisata Bandung',
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempat Wisata Bandung'),
      ),
      body: ListView.builder( 
        itemCount: tourismPlaceList.length,
        itemBuilder: (context, index) {
          final TourismPlace place = tourismPlaceList[index];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 4.0, 
              child: InkWell( 
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailScreen(place: place); 
                  }));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0), 
                        child: Image.asset(
                          place.imageAsset, 
                          fit: BoxFit.cover,
                          height: 100, 
                          width: 100,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              place.name, 
                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(place.location), 
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final TourismPlace place; 
  const DetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dihapus agar gambar terlihat penuh (Full-Bleed)
      // dan judul tidak muncul di navigasi bar.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. Gambar Utama + Tombol Kembali
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ), 
                  child: Image.asset(
                    place.imageAsset, 
                    fit: BoxFit.cover,
                    height: 250.0,
                    width: double.infinity,
                  ),
                ),
                // Tombol Kembali Ditempatkan di sini
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // 2. Nama Tempat (Sekarang menjadi judul utama di body)
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: Text( 
                place.name, 
                textAlign: TextAlign.center,
                style: iniFontCustom.copyWith( 
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ),

            // 3. Info Detail (Hari, Jam, Harga)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[ 
                      const Icon(Icons.calendar_today),
                      const SizedBox(height: 8.0),
                      Text(
                        place.openDays, 
                        style: iniFontCustom, 
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[ 
                      const Icon(Icons.access_time),
                      const SizedBox(height: 8.0),
                      Text(
                        place.openTime, 
                        style: iniFontCustom, 
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[ 
                      const Icon(Icons.monetization_on),
                      const SizedBox(height: 8),
                      Text(
                        place.ticketPrice, 
                        style: iniFontCustom, 
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 4. Deskripsi
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                place.description, 
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 17.0,
                ),
              ),
            ),
            
            // 5. Galeri Gambar
            SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0), 
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: place.imageUrls.map((url) { 
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), 
                        child: Image.network(
                          url, 
                          fit: BoxFit.cover, 
                          width: 150, 
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

// === Main App Structure ===
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan label 'DEBUG'
      home: HomePage(),
    );
  }
}

// === HomePage Widget (Stateful) ===
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Variabel state untuk mengontrol skala (ukuran). Awalnya 1.0 (normal).
  double _scale = 1.0;
  // Durasi animasi
  final Duration _duration = const Duration(milliseconds: 300);

  // 2. Metode untuk mengubah skala (toggle: 1.0 -> 2.0 atau 2.0 -> 1.0)
  void _toggleScale() {
    setState(() {
      // Jika skala saat ini 1.0, ubah menjadi 2.0. Jika tidak, kembalikan ke 1.0.
      _scale = _scale == 1.0 ? 2.0 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar (Header) ---
      appBar: AppBar(
        title: const Text('Home Page'),
        // Tampilkan ikon Hamburger (menu)
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.blue, // Warna biru seperti di gambar
      ),

      // --- Drawer (Menu Samping) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(title: Text('Home Page')),
            ListTile(title: Text('About Page')),
          ],
        ),
      ),

      // --- Body (Konten Utama) ---
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3. Teks dibungkus dalam AnimatedScale untuk animasi
            AnimatedScale(
              scale: _scale,
              duration: _duration,
              curve: Curves.easeInOut,
              child: const Text(
                'Hello ULBI',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // 4. Tombol dibungkus dalam AnimatedScale untuk animasi
            AnimatedScale(
              scale: _scale,
              duration: _duration,
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: _toggleScale, // Panggil fungsi toggle
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna tombol biru
                  foregroundColor: Colors.white, // Warna teks putih
                ),
                // Teks tombol berubah berdasarkan skala saat ini
                child: Text(_scale == 1.0 ? 'Perbesar' : 'Kecilkan'),
              ),
            ),
          ],
        ),
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Indeks yang aktif
        selectedItemColor: Colors.blue, // Warna ikon/label aktif
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
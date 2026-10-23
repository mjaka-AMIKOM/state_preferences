import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Tambahkan import provider

import '../providers/user_provider.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Latihan 4: Gunakan package provider untuk mengakses state
    final provider = Provider.of<UserProvider>(context);
    
    // Cek status login sederhana (jika nama tidak kosong, berarti sudah 'login')
    final isLoggedIn = provider.name.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Latihan 1: Tombol toggle Dark Mode
          IconButton(
            icon: Icon(provider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              provider.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 24),
              Text(
                isLoggedIn
                    ? 'Selamat datang, ${provider.name}!'
                    : 'Selamat datang, Tamu!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (isLoggedIn) ...[
                Text(
                  'Email: ${provider.email}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Latihan 2: Menampilkan Counter Kunjungan
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Aplikasi dibuka: ${provider.visitCount} kali',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                icon: Icon(isLoggedIn ? Icons.person : Icons.login),
                label: Text(isLoggedIn ? 'Lihat Profil' : 'Login / Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
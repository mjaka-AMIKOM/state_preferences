import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Latihan 4: Refactoring menggunakan ChangeNotifier
class UserProvider extends ChangeNotifier {
  // Latihan 1: Tema
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Latihan 2: Counter Kunjungan
  int _visitCount = 0;
  int get visitCount => _visitCount;

  // Latihan 3: Daftar Favorit
  List<String> _favorites = [];
  List<String> get favorites => _favorites;

  // State Profil
  String _name = '';
  String _email = '';
  String get name => _name;
  String get email => _email;

  UserProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Tema (Latihan 1)
    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;

    // Load & Increment Visit Counter (Latihan 2)
    _visitCount = (prefs.getInt('visit_count') ?? 0) + 1;
    await prefs.setInt('visit_count', _visitCount);

    // Load Daftar Favorit (Latihan 3)
    _favorites = prefs.getStringList('favorites') ?? [];

    // Load Profil
    _name = prefs.getString('user_name') ?? '';
    _email = prefs.getString('user_email') ?? '';

    notifyListeners(); // Update UI
  }

  // Latihan 1: Toggle Theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
    notifyListeners();
  }

  // Latihan 3: Tambah Favorit
  Future<void> addFavorite(String item) async {
    if (item.isNotEmpty) {
      _favorites.add(item);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', _favorites);
      notifyListeners();
    }
  }

  // Latihan 3: Hapus Favorit
  Future<void> removeFavorite(String item) async {
    _favorites.remove(item);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }

  // Latihan 5: Validasi Keamanan Profil
  Future<String?> saveProfile(String newName, String newEmail) async {
    final prefs = await SharedPreferences.getInstance();
    
    // a) Cek apakah nama mengandung karakter berbahaya (misalnya tag <script>)
    final RegExp htmlTagRegExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    if (htmlTagRegExp.hasMatch(newName)) {
      return 'Error: Nama mengandung karakter berbahaya!';
    }

    // b) Cek apakah email sudah digunakan (Simulasi sederhana)
    String? existingEmail = prefs.getString('user_email');
    if (existingEmail != null && existingEmail != newEmail && newEmail == 'admin@test.com') {
      return 'Error: Email sudah digunakan oleh pengguna lain!';
    }

    // Jika aman, simpan data
    _name = newName;
    _email = newEmail;
    await prefs.setString('user_name', _name);
    await prefs.setString('user_email', _email);
    
    notifyListeners();
    return null; // Return null berarti sukses (tidak ada error)
  }
}
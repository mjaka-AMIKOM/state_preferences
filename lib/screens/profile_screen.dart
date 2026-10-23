import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  
  // Latihan 3: Controller untuk input hobi/favorit
  final TextEditingController _favController = TextEditingController();
  
  bool _controllersInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controllersInitialized) return;
    
    // Latihan 4: Akses state menggunakan provider
    final provider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: provider.name);
    _emailController = TextEditingController(text: provider.email);
    _controllersInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _favController.dispose();
    super.dispose();
  }

  // Latihan 5: Menambahkan Validasi Keamanan
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      
      // Memanggil fungsi saveProfile yang sudah ada validasi keamanannya
      String? errorMessage = await provider.saveProfile(
        _nameController.text.trim(),
        _emailController.text.trim(),
      );

      if (!mounted) return;

      // Cek apakah ada pesan error dari validasi
      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Simulasi logout dengan mengosongkan nama dan email
              final provider = Provider.of<UserProvider>(context, listen: false);
              await provider.saveProfile('', '');
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Latihan 4: Watch provider untuk mengupdate UI secara dinamis
    final provider = context.watch<UserProvider>();
    final isLoggedIn = provider.name.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Profil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 16),
                
                // --- BAGIAN LATIHAN 3: DAFTAR FAVORIT (HOBI) ---
                const Divider(thickness: 2),
                const SizedBox(height: 8),
                const Text(
                  'Daftar Hobi Favorit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _favController,
                        decoration: const InputDecoration(
                          hintText: 'Tambah hobi baru...',
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.deepPurple, size: 36),
                      onPressed: () {
                        provider.addFavorite(_favController.text.trim());
                        _favController.clear();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Tampilkan list menggunakan map
                if (provider.favorites.isEmpty)
                  const Text('Belum ada hobi yang ditambahkan.', style: TextStyle(fontStyle: FontStyle.italic))
                else
                  Column(
                    children: provider.favorites.map((hobi) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(hobi),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => provider.removeFavorite(hobi),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 16),
                // --- AKHIR BAGIAN LATIHAN 3 ---

                Card(
                  color: Colors.amber[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.amber[800]),
                            const SizedBox(width: 8),
                            const Text(
                              'Catatan Keamanan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Data disimpan di SharedPreferences (plaintext). '
                          'Jangan simpan password atau data sensitif di sini. '
                          'Gunakan secure storage untuk data sensitif.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ukl_bismillah/notiga.dart'; 

class SongPlaylistPage extends StatefulWidget {
  final String token;

  const SongPlaylistPage({super.key, required this.token});

  @override
  State<SongPlaylistPage> createState() => _SongPlaylistPageState();
}

class _SongPlaylistPageState extends State<SongPlaylistPage> {
  List playlists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    final url = Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl2/playlists');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        playlists = data['data'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengambil playlist')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3AB7AF),
        title: const Text(
          "However You Want",
          style: TextStyle(color: Colors.white),
          
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      tileColor: Colors.deepPurple.shade50,
                      title: Text(
                        playlist['playlist_name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("Jumlah lagu: ${playlist['song_count']}"),
                      leading: const Icon(
                        Icons.library_music,
                        color:Color(0xFF3AB7AF),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ListSongPage(
                                  playlistId: playlist['uuid'],
                                  playlistName: playlist['playlist_name'],
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

    );
  }
}
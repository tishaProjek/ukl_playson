import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ukl_bismillah/noempat.dart';
import 'package:ukl_bismillah/noempat.dart';
import 'package:ukl_bismillah/trahirya.dart';

class ListSongPage extends StatefulWidget {
  final String playlistId;
  final String playlistName;

  const ListSongPage({super.key, required this.playlistId, required this.playlistName});

  @override
  State<ListSongPage> createState() => _ListSongPageState();
}

class _ListSongPageState extends State<ListSongPage> {
  List songs = [];
  bool isLoading = true;
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  // State for like
  Map<String, bool> likedStatus = {};
  Map<String, int> likeCounts = {};

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    setState(() => isLoading = true);

    final url = Uri.parse(
      'https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song-list/${widget.playlistId}?search=$searchQuery'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        songs = data['data'];
        for (var song in songs) {
          final id = song['uuid'];
          likedStatus[id] = likedStatus[id] ?? false;
          likeCounts[id] = song['likes'] ?? 0;
        }
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil daftar lagu')),
      );
    }
  }

  void handleSearch() {
    setState(() {
      searchQuery = searchController.text;
    });
    fetchSongs();
  }

  void toggleLike(String id) {
    setState(() {
      final isLiked = likedStatus[id] ?? false;
      likedStatus[id] = !isLiked;
      if (!isLiked) {
        likeCounts[id] = (likeCounts[id] ?? 0) + 1;
      } else {
        likeCounts[id] = (likeCounts[id] ?? 0) - 1;
      }
    });

    // TODO: Kirim ke backend kalau ada API like
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist: ${widget.playlistName}'),
        backgroundColor:  Color(0xFF3AB7AF),
        actions: [
  IconButton(
    icon: const Icon(Icons.add),
    onPressed: () {
      // Arahkan ke halaman AddSongPage untuk menambah lagu
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSongPage(playlistId: widget.playlistId),
        ),
      ).then((_) {
        // Setelah kembali dari halaman AddSongPage, refresh daftar lagu
        fetchSongs();
      });
    },
  ),
],

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan judul atau artist...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: handleSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      final id = song['uuid'];
                      final isLiked = likedStatus[id] ?? false;
                      final likeCount = likeCounts[id] ?? 0;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplaySongPage(songId: id),
                              ),
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://learn.smktelkom-mlg.sch.id/ukl2/storage/${song['thumbnail']}',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: const Icon(Icons.music_note, color: Color(0xFF3AB7AF)),
                              ),
                            ),
                          ),
                          title: Text(
                            song['title'],
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song['artist'],
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                ),
                              ),
                              if (song['description'] != null && song['description'].toString().isNotEmpty)
                                Text(
                                  song['description'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: const Color(0xFF3AB7AF),
                                ),
                                onPressed: () => toggleLike(id),
                              ),
                              Text(
                                likeCount.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

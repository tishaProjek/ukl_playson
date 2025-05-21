import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukl_bismillah/notiga.dart';

class AddSongPage extends StatefulWidget {
  final String playlistId;

  const AddSongPage({super.key, required this.playlistId});

  @override
  _AddSongPageState createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _pickedImage = File(pickedFile.path));
    }
  }

  Future<void> submitSong() async {
    if (!_formKey.currentState!.validate()) return;

    final uri = Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song');
    final request = http.MultipartRequest('POST', uri)
      ..fields['playlist_id'] = widget.playlistId
      ..fields['title']       = titleController.text
      ..fields['artist']      = artistController.text
      ..fields['description'] = descriptionController.text
      ..fields['source']      = sourceController.text;

    if (_pickedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'thumbnail', 
        _pickedImage!.path,
        contentType: MediaType('image', _pickedImage!.path.split('.').last),
      ));
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final data = jsonDecode(respStr);

    if (response.statusCode == 201 && data['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lagu berhasil ditambahkan!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan lagu: ${data['message'] ?? response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Lagu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul Lagu'),
                validator: (v) => v!.isEmpty ? 'Judul lagu harus diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: artistController,
                decoration: const InputDecoration(labelText: 'Artis'),
                validator: (v) => v!.isEmpty ? 'Artis harus diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: sourceController,
                decoration: const InputDecoration(labelText: 'Sumber Lagu (URL)'),
              ),
              const SizedBox(height: 24),
              // Tombol pilih gambar
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pilih Thumbnail'),
              ),
              const SizedBox(height: 12),
              // Preview gambar
              if (_pickedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _pickedImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const Text(
                  'Belum ada gambar dipilih',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: submitSong,
                child: const Text('Tambah Lagu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

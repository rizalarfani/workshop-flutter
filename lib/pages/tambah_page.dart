import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as client;
import 'package:image_picker/image_picker.dart';
import 'package:workshop_flutter/utils/utils.dart';

import '../models/success_model.dart';
import '../widget/button_widget.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  TextEditingController? judulBuku;
  TextEditingController? penulis;
  TextEditingController? penerbit;
  TextEditingController? tahun;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    judulBuku = TextEditingController();
    penulis = TextEditingController();
    penerbit = TextEditingController();
    tahun = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    judulBuku?.dispose();
    penulis?.dispose();
    penerbit?.dispose();
    tahun?.dispose();
    super.dispose();
  }

  Future<SuccessModel> addData() async {
    final map = <String, String>{};
    map['judul'] = judulBuku!.text;
    map['tahun'] = tahun!.text;
    map['penulis'] = penulis!.text;
    map['penerbit'] = penerbit!.text;

    try {
      final request = client.MultipartRequest(
        'POST',
        Uri.parse('${Utils.baseUrl}/api_buku/addBuku'),
      );

      request.fields.addAll(map);

      if (_selectedImage != null) {
        request.files.add(await client.MultipartFile.fromPath(
          'cover',
          _selectedImage!.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await client.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return SuccessModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to Simpan Data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Tidak ada gambar yang dipilih',
        backgroundColor: Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simpan Data',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Judul Buku",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: judulBuku,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Masukkan Judul Buku",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(217, 217, 217, 0.7),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(217, 217, 217, 0.7),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Penerbit",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: penerbit,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Masukkan Nama Penerbit",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(217, 217, 217, 0.7),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(217, 217, 217, 0.7),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Penulis",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: penulis,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Masukkan Nama Penulis",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(217, 217, 217, 0.7),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(217, 217, 217, 0.7),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tahun",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: tahun,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan Tahun",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(217, 217, 217, 0.7),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(217, 217, 217, 0.7),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Upload Gambar",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : const Center(
                          child: Text("Klik untuk memilih gambar"),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              ButtonWidget(
                title: "Simpan Data",
                onTap: () async {
                  if (judulBuku!.text.isEmpty ||
                      penulis!.text.isEmpty ||
                      penulis!.text.isEmpty ||
                      tahun!.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Harap isi semua field yang ada',
                        backgroundColor: Colors.redAccent);
                  } else {
                    SuccessModel response = await addData();
                    if (response.status) {
                      Fluttertoast.showToast(
                        msg: response.message,
                        backgroundColor: Colors.black,
                      );
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                        msg: response.message,
                        backgroundColor: Colors.redAccent,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

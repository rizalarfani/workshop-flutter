import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workshop_flutter/models/book_model.dart';
import 'package:http/http.dart' as client;

import '../models/success_model.dart';
import '../utils/utils.dart';
import '../widget/button_widget.dart';

class EditPage extends StatefulWidget {
  final Books book;

  const EditPage({super.key, required this.book});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController? judulBuku = TextEditingController();
  TextEditingController? penulis = TextEditingController();
  TextEditingController? penerbit = TextEditingController();
  TextEditingController? tahun = TextEditingController();
  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    judulBuku?.text = widget.book.judul ?? "";
    penulis?.text = widget.book.penulis ?? "";
    penerbit?.text = widget.book.penerbit ?? "";
    tahun?.text = widget.book.tahun.toString();
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

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      }
    });
  }

  Future<SuccessModel> updateData() async {
    final map = <String, String>{};
    map['id'] = widget.book.id.toString();
    map['judul'] = judulBuku!.text;
    map['tahun'] = tahun!.text;
    map['penulis'] = penulis!.text;
    map['penerbit'] = penerbit!.text;

    try {
      var request = client.MultipartRequest(
          'POST', Uri.parse('${Utils.baseUrl}/api_buku/editBuku'));
      request.fields.addAll(map);

      if (selectedImage != null) {
        request.files.add(await client.MultipartFile.fromPath(
          'cover',
          selectedImage!.path,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return SuccessModel.fromJson(json.decode(responseData));
      } else {
        throw Exception('Failed to update data');
      }
    } catch (e) {
      throw Exception('Failed to update data $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.judul ?? "",
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
              Container(
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
                child: selectedImage != null
                    ? Image.file(selectedImage!, fit: BoxFit.cover)
                    : widget.book.cover != null
                        ? Image.network(
                            widget.book.cover ?? "",
                            fit: BoxFit.cover,
                          )
                        : Container(),
              ),
              TextButton(
                onPressed: pickImage,
                child: const Text("Ganti Gambar"),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 30),
              ButtonWidget(
                title: "Edit Data",
                onTap: () async {
                  SuccessModel edit = await updateData();
                  if (edit.status) {
                    Fluttertoast.showToast(
                      msg: edit.message,
                      backgroundColor: Colors.black,
                    );
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                      msg: edit.message,
                      backgroundColor: Colors.redAccent,
                    );
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workshop_flutter/models/book_model.dart';
import 'package:workshop_flutter/pages/edit_page.dart';
import 'package:workshop_flutter/pages/tambah_page.dart';
import 'package:workshop_flutter/utils/utils.dart';

import 'package:http/http.dart' as client;

import '../models/success_model.dart';
import '../widget/item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Books>? getAllBooksList;
  bool isLoading = false;
  String? errorMessage = '';

  Future<List<Books>> getAllBook() async {
    try {
      final response =
          await client.get(Uri.parse('${Utils.baseUrl}/api_buku/getBuku'));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['data'] != null) {
          List<dynamic> jsonResponse = jsonBody['data'];
          return jsonResponse.map((data) => Books.fromJson(data)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Failed to load data with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<SuccessModel> deleteData(int idBuku) async {
    try {
      final response = await client.get(
        Uri.parse('${Utils.baseUrl}/api_buku/deleteBuku?id=$idBuku'),
      );
      if (response.statusCode == 200) {
        return SuccessModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to Delete Data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() {
      isLoading = true;
    });
    getAllBook().then((books) {
      setState(() {
        getAllBooksList = books;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        errorMessage = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Buku',
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            )
          : getAllBooksList!.isNotEmpty
              ? ListView.builder(
                  itemCount: getAllBooksList?.length ?? 0,
                  itemBuilder: (context, index) {
                    Books book = getAllBooksList![index];
                    return ItemWidget(
                      judul: book.judul ?? "",
                      penerbit: book.penerbit ?? "",
                      penulis: book.penulis ?? "",
                      tahun: book.tahun.toString(),
                      cover: book.cover ?? "",
                      onEdit: () {
                        var navigate =
                            Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return EditPage(
                              book: book,
                            );
                          },
                        ));
                        navigate.then(
                          (value) {
                            fetchData();
                          },
                        );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Delete Data',
                              ),
                              content: const Text(
                                "Apakah anda yakin untuk menhapus data ini?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    SuccessModel response =
                                        await deleteData(book.id ?? 0);
                                    if (response.status) {
                                      Navigator.pop(context);
                                      getAllBook().then((value) {
                                        setState(() {
                                          getAllBooksList = value;
                                        });
                                      });
                                      Fluttertoast.showToast(
                                        msg: response.message,
                                        backgroundColor: Colors.black,
                                      );
                                    }
                                    if (response.status != true) {
                                      Fluttertoast.showToast(
                                        msg: response.message,
                                        backgroundColor: Colors.redAccent,
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                )
              : const Center(
                  child: Text('Data tidak Ditemukan'),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          var navigate = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahPage(),
            ),
          );
          navigate.then((value) {
            fetchData();
          });
        },
      ),
    );
  }
}

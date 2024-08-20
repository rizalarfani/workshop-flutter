class Books {
  int? id;
  String? judul;
  String? penulis;
  String? penerbit;
  int? tahun;
  String? cover;

  Books(
      {this.id,
      this.judul,
      this.penulis,
      this.penerbit,
      this.tahun,
      this.cover});

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judul = json['judul'];
    penulis = json['penulis'];
    penerbit = json['penerbit'];
    tahun = json['tahun'];
    cover = json['cover'] != null ? json['cover'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['judul'] = this.judul;
    data['penulis'] = this.penulis;
    data['penerbit'] = this.penerbit;
    data['tahun'] = this.tahun;
    data['cover'] = this.cover;
    return data;
  }
}

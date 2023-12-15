class TextIds {
  List<String> idlist;

  TextIds({required this.idlist});

  Map<String, dynamic> toMap() {
    return {
      'idlist': idlist,
    };
  }

  factory TextIds.fromMap(Map<String, dynamic> map) {
    return TextIds(idlist: map['idlist'] ?? []);
  }
}
